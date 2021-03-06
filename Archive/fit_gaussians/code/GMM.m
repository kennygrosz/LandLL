function C=GMM(x,y)
%given x and y values, fit a 4-peak gaussian mixture model to the data
%returns model object f
%check if x and y are columns and turn them into columns otherwise
if ~iscolumn(x), x=x'; end
if ~iscolumn(y), y=y'; end

%check that x and y are the same size
if length(x)~=length(y), error('x and y must be the same length'),end

% Set up fittype and options.
ft = fittype( 'gauss4' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf 0 -Inf -Inf 0 -Inf -Inf 0 -Inf 150 0];
opts.Upper = [Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf 500 Inf];
opts.StartPoint = [54690 51.051 14.734147844914 34585.8813436664 27.027 18.7032186222794 32534 -107.11 21.5307689533752 19972.6364121955 -7.007 27.6478045085227];

% Fit model to data.
[f, ~] = fit( x, y, ft, opts );

%plotting
figure
hold on
plot(x,y)
plot(f)
xlabel('HU')
ylabel('Frequency')


%print coefficients
C=coeffvalues(f);
end