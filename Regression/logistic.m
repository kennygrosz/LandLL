close all hidden
A=xlsread('..\Features\features_mega_matrix.xlsx',1,'A3:PY22');

resp = [2;1;2;1;2;2;1;2;2;1;1;2;2;1;2;1;1;1;1;2]; %RESPONDER STATUS:
                            % 1 = RESPONDER, 2 = NON-RESPONDER
TTP = A(:,7);
A = A(:,[1:6,8:end]);

[~,m] = size(A);

dev = [];
for i = 1:m
    if A(:,i) ~= zeros(size(A(:,i)))
        [b,dev(i,1),stats]=mnrfit(A(:,i),resp);
        
        %figure
        %plot(A(:,i),resp,'.','MarkerSize',20)
    end
  
end

min_dev_ind = find(dev > 0 & dev < 22.3);

%visualize 1-dimensional variables and logistic regressions
for i = 1:length(min_dev_ind)
%         figure
%         plot(A(:,min_dev_ind(i)),resp,'.','MarkerSize',20)
end

%multivariable logistic regression
B = A(:,min_dev_ind);
[b,dev2,stats]=mnrfit(B,resp)



