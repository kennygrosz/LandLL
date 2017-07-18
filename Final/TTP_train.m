function TTP_train(file_link)
%inputs a data file that meets the following specifications:
    % 1 Row Header With Variable Names, each column is a  feature
    % Each row is a patient's data
    % Column 1 is TTP
    % Column 2 is Response Status (0 or 1)
    % All variables are numerical (i.e. categorical variables converted to
    % numbers
 

% data_source = '../Regression/regression_file_new_data2.xlsx';

Data=xlsread(file_link,1);

TTP = Data(:,1);
Resp_Status = Data(:,2)+1;
F = Data(:,3:end); 

%STAGE 1: Logistic Variable Selection
disp('... Classification Stage...')
[classes, class_pct, log_vars, log_coeff]=logistic(F,Resp_Status);
    %1 = non-responder, 0 = responder
disp(strcat('Classification Accuracy is: ',num2str(class_pct*100),'%'))
disp('')

%STAGE 2: Linear Regression on Responders and Non-Responders
disp('... TTP Prediction Stage ...')
%---split data into responders and nonresponders----
R_ind = find(classes==0); NR_ind = find(classes==1); %indices

R_F = F(R_ind,:); R_TTP = TTP(R_ind,:);
NR_F = F(NR_ind,:); NR_TTP = TTP(NR_ind,:);

%----perform linear regression based feature selection and multiple
%regression
[R_TTP_p,R_resid,R_r2a, R_vars, R_coeff]=linear(R_F,R_TTP);
[NR_TTP_p,NR_resid,NR_r2a, NR_vars, NR_coeff]=linear(NR_F,NR_TTP);

figure
hold on
boxplot([R_resid,NR_resid],{'Responders','Non-Responders'})
ylabel('Error in Model TTP Prediction (Weeks)')
title('Model Prediction Error')
hold off


disp(strcat('Responder Adjusted R^2 = ',num2str(R_r2a)))
disp(strcat('Non-Responder Adjusted R^2 = ',num2str(NR_r2a)))

save('trained_model.mat','log_vars','log_coeff', 'R_vars','R_coeff', 'NR_vars','NR_coeff')

end

function [y,resid,r2a, lin_vars, lin_coeff]=linear(A,resp)

% A is the matrix of features
% Resp_Status is a vector of TTP values

    
%suppress warnings
warning('off','MATLAB:nearlySingularMatrix')
warning('off','stats:mnrfit:IterOrEvalLimit')   

[~,m] = size(A);

dev = [];
for i = 1:m
    if A(:,i) ~= zeros(size(A(:,i)))
        o = ones(size(resp));
        [~,~,~,~,stats]=regress(resp,[o,A(:,i)]);
        dev(i,1) = stats(1);
    end  
end

[dev,ind] = sort(dev,1,'descend');

i=find(dev>0,7,'first');


min_dev_ind = ind(i); %hard-code adding 3 indices from before


max_pct = 0;
for v = 2:4
    V = combnk(min_dev_ind,v);
    
    [m,~]=size(V); %number of permutations
    
    %for each permutation of variables, create model and perform
    %cross-validation
    
    for i = 1:m
        
        ind = V(i,:);
        
        B = [o,A(:,ind)];
        [~,~,~,~,stats]=regress(resp,B);
        
        n = length(resp);
        p = length(ind);
        
        r2=stats(1);
        
        r2a = r2 - (1-r2)*p/(n-p-1); %adjusted r2
        pct = r2a; 

                
        if pct > max_pct
            max_pct = pct;
            max_pct_ind = V(i,:);
            
        end
        
    end
end

%generate final TTP Predictions



%multivariable logistic regression
B = [o,A(:,max_pct_ind)];
[m,n]=size(B);


[b,~,~,~,stats] = regress(resp,B);


%generate model output
y=zeros(m,1);
for i = 1 : n
    y = y + b(i)*B(:,i);
end

resid = abs(y-resp);
r2 = stats(1);

n = length(resp);
p = length(max_pct_ind);


r2a = r2 - (1-r2)*p/(n-p-1); %adjusted r2

lin_coeff = b;
lin_vars = max_pct_ind;

end


function [classes,max_pct,log_vars, log_coeff]=logistic(A,resp)

% A is the matrix of features
% Resp_Status is the 0-1 vector of responder vs. non-responder

    
%suppress warnings
warning('off','MATLAB:nearlySingularMatrix')
warning('off','stats:mnrfit:IterOrEvalLimit')   

[~,m] = size(A);

dev = [];
for i = 1:m
    if A(:,i) ~= zeros(size(A(:,i)))
        [~,dev(i,1),~]=mnrfit(A(:,i),resp);
    end  
end


% pct=logistic_crossval(A,[25,83,87],resp)
% 
% if pct > max_pct
%     max_pct = pct
%     max_pct_ind = V(i,:)
%     pause
% end

[dev,ind] = sort(dev);

i=find(dev>0,5,'first');

min_dev_ind = [ind(i); 25;83;87]; %hard-code adding 3 indices from before

max_pct = 0;
for v = 3:4
    V = combnk(min_dev_ind,v);
    
    [m,~]=size(V);
    
    %for each permutation of variables, create model and perform
    %cross-validation
    
    for i = 1:m
        pct=logistic_crossval(A,V(i,:),resp);
        
        if pct > max_pct
            max_pct = pct;
            max_pct_ind = V(i,:);
        end
        
    end
end

%generate final classes


%multivariable logistic regression
B = A(:,max_pct_ind);
[m,n]=size(B);

b=mnrfit(B,resp);

%generate model output
y=[];
for i = 1 : m
    a = b(1);
    
    for j = 1:n
        a = a + b(j+1)*B(i,j);
        
    end    
    y(i) = -1/(1+exp(-a)) + 2;
end

%clean and threshold results
y=(y'-1);
classes = round(y,0);

log_coeff = b;
log_vars = max_pct_ind;
end

function pct = logistic_crossval(A,min_dev_ind,resp)

N = length(min_dev_ind);

%multivariable logistic regression
B = A(:,min_dev_ind);


K = 7; %number of groups for cross validation

pct=[];
for j =1:20 %run cross validation test 10 times
    indices = crossvalind('KFold',length(resp),K); %generate indices for K-Fold cross validation
    for k = 1:K
        test = find(indices==k); train = find(indices~=k); %generate index vectors for train and test sets
        
        %------------specific to logistic regression---------------
        % insert your own modeling code here---------
        %generate training/testing data
        C = B(train,:);
        C_resp = resp(train);
        
        T=B(test,:);
        T_resp = resp(test);
        
        %create multivariate model from training data
        b=mnrfit(C,C_resp);
        
        %generate output from new logistic model for data in test set
        y=[];

        
        for i = 1 : length(test)
            a = b(1);
            
            for j = 1:N
                a = a + b(j+1)*T(i,j);
                
            end
%             
%             %             a=b(1) + b(2)*T(i,1)+b(3)*T(i,2)+b(4)*T(i,3)+b(5)*T(i,4)+b(6)*T(i,5)+b(7)*T(i,6)+ b(8)*T(i,7); %for 7 variables
%             %             a=b(1) + b(2)*T(i,1)+b(3)*T(i,2)+b(4)*T(i,3)+b(5)*T(i,4)+b(6)*T(i,5)+b(7)*T(i,6); %for 6 variables
%             %                 a=b(1) + b(2)*T(i,1)+b(3)*T(i,2)+b(4)*T(i,3)+b(5)*T(i,4)+b(6)*T(i,5); %for 5 variables
%             
%             %                 a=b(1) + b(2)*T(i,1)+b(3)*T(i,2)+b(4)*T(i,3)+b(5)*T(i,4); %for 4 variables
%             a=b(1) + b(2)*T(i,1)+b(3)*T(i,2)+b(4)*T(i,3); %for 3 variables
%             %                 a=b(1) + b(2)*T(i,1)+b(3)*T(i,2); %for 2 variables
%             %                 a=b(1) + b(2)*T(i,1); %for 1 variables
            
            y(i) = -1/(1+exp(-a)) + 2;
        end
        
        %clean and threshold results
        y=(y'-1);
        thresh_y = round(y,0);
        T_resp = T_resp-1;
        
        %---------------------------------------------------------
        %include a measure of model accuracy on test set below
        
        %evaluate model accuracy
        num_right = sum(T_resp == thresh_y);
        pct= [pct, num_right/length(test)]; %store results for each trial
    end
end

pct = mean(pct);
end





