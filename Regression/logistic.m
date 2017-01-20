close all hidden
A=xlsread('..\Features\features_mega_matrix.xlsx',1,'A1:PY21');

resp = [2;1;2;1;2;2;1;2;2;1;1;2;2;1;2;1;1;1;1;2]; %RESPONDER STATUS:
                            % 1 = RESPONDER, 2 = NON-RESPONDER
TTP = A(:,7);
A = A(:,[1:6,8:end]);

[~,m] = size(A);

dev = [];
for i = 1:m
    if A(:,i) ~= zeros(size(A(:,i)))
        [~,dev(i,1),~]=mnrfit(A(:,i),resp);
        
        %figure
        %plot(A(:,i),resp,'.','MarkerSize',20)
    end
  
end

min_dev_ind = find(dev > 0 & dev < 22.3)

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

%visualize 1-dimensional variables and logistic regressions
% for i = 1:length(min_dev_ind)
%         figure
%         plot(A(:,min_dev_ind(i)),resp,'.','MarkerSize',20)
% end

%multivariable logistic regression
B = A(:,min_dev_ind);

%generate training and test sets
train = randsample(20,16);
test=[];
for i = 1:20
   if sum(i==train)==0
       test = [test, i];
   end
end

C = B(train,:);
C_resp = resp(train);

T=B(test,:);
T_resp = resp(test);

%create multivariate model from training data
[b,dev2,stats]=mnrfit(C,C_resp);

%recreate logistic model for each test pattern
y=[];
for i = 1 : length(test)
    a=b(1) + b(2)*T(i,1)+b(3)*T(i,2)+b(4)*T(i,3)+b(5)*T(i,4)+b(6)*T(i,5)+b(7)*T(i,6);
    y(i) = -1/(1+exp(-a)) + 2;
end

y=(y'-1)
T_resp = T_resp-1




