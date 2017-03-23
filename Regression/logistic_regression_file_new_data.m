close all hidden
%suppress warnings
warning('off','MATLAB:nearlySingularMatrix')
warning('off','stats:mnrfit:IterOrEvalLimit')

A=xlsread('regression_file_new_data.xlsx',1,'N2:GZ15');

% resp = [2;1;2;1;2;2;1;2;2;1;1;2;2;1;2;1;1;1;1;2]; %RESPONDER STATUS:
resp = [2;2;1;1;1;2;2;1;1;2;1;2;1;2];
             
% 1 = RESPONDER, 2 = NON-RESPONDER


A(1:10,1:10)
% TTP = A(:,1);
% A = A(:,2:end);

[~,m] = size(A);

dev = [];
for i = 1:m
    if A(:,i) ~= zeros(size(A(:,i)))
        
        [~,dev(i,1),~]=mnrfit(A(:,i),resp);
        
        %figure
        %plot(A(:,i),resp,'.','MarkerSize',20)
    end
  
end

% min_dev= find(dev > 0 & dev < 22.3)
% min_dev_ind = [min_dev_ind; 146];
% min_dev_ind=[149,146,210,206] %top features from linear regression email
% [S,I] = sort(dev);
% min_dev_ind = I(1:4)
% dev(1:4)
hist(dev)

for z=1:6
%     min_dev_ind=min_dev(min_dev~=min_dev(z)); %take all but one of the indices
%     min_dev_ind = min_dev(1:2);
%     min_dev_ind=min_dev([1:4])
%     min_dev_ind = [7,27,75,26]

    min_dev_ind = [90, 25, 83, 87]

    % [b,~,~]=mnrfit(A(:,min_dev_ind(3)),resp)
    %
    % figure; hold on
    % x = linspace(min(A(:,min_dev_ind(3))),max(A(:,min_dev_ind(3))),100);
    %
    % % plot(x,resp,'.','MarkerSize',20)
    % y = -1./(1+exp(-(b(1)+b(2)*x))) + 2;
    % plot(x,y)
    % hold on
    % plot(A(:,min_dev_ind(3)),resp,'.','MarkerSize',20)
    %
    % pause
    
    % % visualize 1-dimensional variables and logistic regressions
    % for i = 1:length(min_dev_ind)
    %         figure
    %
    %         [b,~,~]=mnrfit(A(:,min_dev_ind(i)),resp);
    %         x = linspace(min(A(:,min_dev_ind(i))),max(A(:,min_dev_ind(i))),100);
    %         y = -1./(1+exp(-(b(1)+b(2)*x))) + 1;
    %         fig = plot(x,y,'LineWidth',2.5); hold on
    %         legend('probaility of not responding to treatment','Location','Best')
    %
    %
    %         plot(A(:,min_dev_ind(i)),resp-1,'.','MarkerSize',20)
    %         ylabel('Responder Status (1=Responder, 2=Non-Responder)')
    %         xlabel('Feature Value')
    %
    %
    %         saveas(fig,strcat('figures/single_var_logistic_',num2str(i),'.png'))
    % end
    
    %multivariable logistic regression
    B = A(:,min_dev_ind);
    
    
    K = 7; %number of groups for cross validation
    
    pct=[];
    for j =1:100 %run cross validation test 10 times
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
            [b,dev2((j-1)*5+k),stats]=mnrfit(C,C_resp);
            
            %generate output from new logistic model for data in test set
            y=[];
            for i = 1 : length(test)
                %             a=b(1) + b(2)*T(i,1)+b(3)*T(i,2)+b(4)*T(i,3)+b(5)*T(i,4)+b(6)*T(i,5)+b(7)*T(i,6)+ b(8)*T(i,7); %for 7 variables
                %             a=b(1) + b(2)*T(i,1)+b(3)*T(i,2)+b(4)*T(i,3)+b(5)*T(i,4)+b(6)*T(i,5)+b(7)*T(i,6); %for 6 variables
                %                 a=b(1) + b(2)*T(i,1)+b(3)*T(i,2)+b(4)*T(i,3)+b(5)*T(i,4)+b(6)*T(i,5); %for 5 variables
                
                a=b(1) + b(2)*T(i,1)+b(3)*T(i,2)+b(4)*T(i,3)+b(5)*T(i,4); %for 4 variables
%                 a=b(1) + b(2)*T(i,1)+b(3)*T(i,2)+b(4)*T(i,3); %for 3 variables
%                 a=b(1) + b(2)*T(i,1)+b(3)*T(i,2); %for 2 variables
%                 a=b(1) + b(2)*T(i,1); %for 1 variables

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
    
    disp(strcat('Accuracy of TACE effectiveness model: ',num2str(100*mean(pct)),'%'))
    
end



