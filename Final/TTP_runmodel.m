function TTP_runmodel(file_link)
%given model coefficients from TTP train, run model on given dataset
%Data must be in same column order as the data presented to the training model
%Data columns must start on column 1 instead of 3
%
%runs model with features and coefficients specified in the
%trained_model.mat file

%load in data and 
Data=xlsread(file_link,1); %load up data
load('trained_model.mat'); %this loads the variables into the workspace


%-----run classification model for each patient-----
b = log_coeff;
B = Data(:,log_vars);
[m,n]=size(B); %m is number of patients, n is features in model

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

%-----run TTP prediction model for each patient-----
o = ones(m,1);
b1 = R_coeff; b2 = NR_coeff; a1 = R_vars; a2 = NR_vars;
B1 = [o,Data(:,a1)]; B2 = [o,Data(:,a2)];

[~,n1]=size(B1);[~,n2]=size(B2);

y = zeros(m,1); %initialize TTP vector

for j = 1:m
    if classes(i) == 0 %if patient is a responder
        for i = 1 : n1
            y(j) = y(j) + b1(i)*B1(j,i);
        end
    elseif classes(i) == 1 %nonresponder model
        for i = 1 : n2
            y(j) = y(j) + b2(i)*B2(j,i);
        end
    end
end

Response = classes;
TTP = y;

table(Response, TTP)
end