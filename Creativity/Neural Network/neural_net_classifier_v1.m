function neural_net_classifier_v1
%parameters
close all hidden
hid_n = 5; %number of hiden PEs in layer 2
mu = .01; %learning rate
n = 20000; %maximum number of learn steps
K=10; %epoch size
alpha = .75;
tol = 0;

%data import
[X,Y]=import_data;


%scaling

X_scale = X;

disp('size')
disp(X(1:10,1))
[N,~]=size(X); %N = number of features
m = zeros(N,1); %feature scaling parameter
b = zeros(N,1); %feature scaling parameter

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


X_CV = X_scale(:,1:16);
Y_CV = Y(:,1:16);

X_test = X_scale(:,17:20);
Y_test = Y(:,17:20);

[W1,W2,e_train] = gen_net(X_CV,Y_CV,hid_n,mu,n,tol,K,alpha);


figure
plot(1:length(e_train),e_train)

for i = 1:4
    out(i)=test_all_net(W1,W2,X_test(:,i))
end

round(out,1)==Y_test



end

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


function [X,Y]=import_data()

X=xlsread('features_mega_matrix_new.xlsx',1,'D2:QG21');
X=X'; %447 x 20 feature matrix

Y=xlsread('features_mega_matrix_new.xlsx',1,'C2:C21');
Y=Y'; %desired output (-1 = nonresponder, 1 = responder)
end


function [W1,W2,E] = gen_net(training_mat, desired_mat, hid_n, mu, n, tol,K,alpha)
[inp_n, ~] = size(training_mat); %input nodes
[out_n, P] = size(desired_mat); %output nodes

%initialize weight matrices
W1 = -.1 + (.1-(-.1)).*rand(hid_n, inp_n+1); 
W2 = -.1 + (.1-(-.1)).*rand(out_n, hid_n +1); 
prev_W1 = W1;
prev_W2 = W2;
E=zeros(n,1);

for j = 1:n
    RN = randperm(P);
    INP = training_mat(:,[RN]);
    DES = desired_mat(:,[RN]);
    
    cum_dW1 = zeros(size(W1));
    cum_dW2 = zeros(size(W2));

    
    for i = 1:K %in each epoch
        hid_net = W1*[1;INP(:,i)];  %10x1
        %hid_net
        hid_out = tanh(hid_net); %10x1
       % hid_out
        y_net = W2*[1;hid_out]; %1x1
       % y_net
        y_out = tanh(y_net); %1x1
      %  y_out
        
        yp_out = 1-(y_out.^2); %1x1
        
        % -------BACK PROPAGATION----------------
        % algorithm for changing weights
        
        %step 1, most outer layer
        outer_delta= (DES(:,i) - y_out).*yp_out; %1x1
%         W2_new = W2 + mu*outer_delta*[1;hid_out]'; %1x11
        yp_hid = 1-(hid_out.^2);  %10x1
        inner_delta = yp_hid .* (W2(:,2:end)*outer_delta)'; %10x1
%         W1 = W1 + mu*inner_delta*[1;INP(:,i)]';%10x2 

        cum_dW2 = cum_dW2 + mu*outer_delta*[1;hid_out]';
        cum_dW1 = cum_dW1 + mu*inner_delta*[1;INP(:,i)]' ;
        
    end

    %update weights, batch style!
    holder = W2;
    W2 = W2 + cum_dW2 + alpha*(W2 - prev_W2);
    prev_W2 = holder;
    holder = W1;
    W1 = W1 + cum_dW1 + alpha*(W1 - prev_W1);
    prev_W1 = holder;
    
    %test if errors are within tolerance for given W1,W2:

    
    e=test_all_net(W1,W2,INP(:,i)) - DES(:,i);
    ee=sum(abs(e)); %average absolute error
    E(j) = ee;
    
    if ee <= tol
        disp(strcat('Training Terminated, Tolerance of', tol,' Reached'));
        disp('Number of iterations ='), disp(K*j+i)
        break
    end
    if j == n
        disp('Training Terminated, Max Learning Steps Reached')
        disp('Number of Learning Steps ='), disp(K*j+i)
    end
end
end



function y = test_all_net(W1,W2, input_vec)

[~,n] = size(input_vec);

for i = 1 : length(n)

    hid_net = W1*[1;input_vec];  %10x1
    hid_out = tanh(hid_net); %10x1
    y_net = W2*[1;hid_out]; %1x1
    y_out = tanh(y_net); %1x1
    y(i)=y_out;
end
end

function E = error_calc(y,y_des)
%calculate error for a particular output
if length(y)~=length(y_des), error('real and desired vectors must be same length'),end

e = y_des- y; %vector of individual errors
E = sum(abs(e))/length(y);
end


