function feature_graphs



%data import
[X,Y]=import_data;

function [X,Y]=import_data()

X=xlsread('features_mega_matrix_newish.xlsx',1,'D2:QG21');
X=X'; %447 x 20 feature matrix
[~,headers,~] = xlsread('features_mega_matrix_newish.xlsx',1,'D1:QG1');


Y=xlsread('features_mega_matrix_newish.xlsx',1,'C2:C21');
Y=Y'; %desired output (-1 = nonresponder, 1 = responder)
end

features_per_graph=5;
[N,P]=size(X); %N = number of features


function [y,m,b]=scale(x,fmin,fmax)
%take a vector x and linearly scale it to be between [fmin, fmax]
%return the new vector and (m,b), the constants needed to return it to its
%original value

xmin=min(x); xmax = max(x);
m = (fmax-fmin)/(xmax-xmin); %slope formula
b = fmin-(fmax-fmin)/(xmax-xmin)*xmin; %intercept

y = m*x+b;
%to get back to previous scale, use x=(y-b)/m
end


X_scale = X;
for i = 1 : N
    xmin=min(X(i,:)); xmax = max(X(i,:));
    if xmin == xmax
        if xmin ~= 0
            X_scale(i,:) = X(i,:)/xmin;
        end
    else
        [X_scale(i,:),m(i),b(i)] = scale(X(i,:),-1,1);
    end
end

xaxis = linspace(1,features_per_graph, features_per_graph);
first_index = 1;
last_index = features_per_graph;
     

fig_index = 1;
colors = {'r.-','r','g.-'};

while last_index <= 25
    figure(fig_index)
    for i = 1:P
        hold on
        
        %scatter(xaxis,X_scale(first_index:last_index,i),colors(Y(i)+2),'filled');
        %xlabel(headers(first_index:last_index))
        plot(xaxis,X_scale(first_index:last_index,i),colors{Y(i)+2},'MarkerSize',14)
        ylim([-1.1 1.1])
        set(gca,'XTick',[1 2 3 4 5])
        set(gca,'XTickLabel',headers(first_index:last_index))
     
    end

    
    first_index = last_index + 1;
    last_index = first_index + features_per_graph - 1;
    fig_index = fig_index + 1;
end


disp(size(X_scale))



end