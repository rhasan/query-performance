%% Initialization
clear ; close all; clc

%% =========== Part 1: Loading and Visualizing Data =============
%  We start the exercise by first loading and visualizing the dataset. 
%  The following code will load the dataset into your environment and plot
%  the data.
%

% Load Training Data
fprintf('Loading Data ...\n')


% Load from ex5data1: 
% You will have X, y, Xval, yval, Xtest, ytest in your environment

%load ('ex5data1.mat');
X = csvread('../x_features.txt');
y = csvread('../y_time.txt');
Xval = csvread('../xval_features.txt');
yval = csvread('../yval_time.txt');
Xtest = csvread('../xtest_features.txt');
ytest = csvread('../ytest_time.txt');

%selected_features = [1 2 3 4 5 6 18 19];
selected_features = mean(X)~=0;
%selected_features = [1 2 3 4 5 6 8 17 18 19 23];
%selected_features = [1:24];
[ X, Xval, Xtest] = select_features(selected_features,X, Xval, Xtest);

% m = Number of examples
m = size(X, 1);


fprintf('Program paused. Press enter to continue.\n');
pause;

%%=========== reduce dimention ===============
%K=1;
%[Z ,U, S] = reduce_dimention(X,K);
%[Zval ,Uval, Sval] = reduce_dimention(Xval,K);
%[Ztest ,Utest, Stest] = reduce_dimention(Xtest,K);

%X = Z;
%Xval = Zval;
%Xtest = Ztest;

%figure(3);
%plot(X, y, 'rx', 'MarkerSize', 10);

%title('Dataset plotted in 2D, using PCA for dimensionality reduction');
%pause;

%% =========== Part 6: Feature Mapping for Polynomial Regression =============
%  One solution to this is to use polynomial regression. You should now
%  complete polyFeatures to map each example into its powers
%

p = 4;

% Map X onto Polynomial Features and Normalize
X_poly = polyMultiFeatures(X, p);
[X_poly, mu, sigma] = featureNormalize(X_poly);  % Normalize
X_poly = [ones(m, 1), X_poly];                   % Add Ones

% Map X_poly_test and normalize (using mu and sigma)
X_poly_test = polyMultiFeatures(Xtest, p);
X_poly_test = bsxfun(@minus, X_poly_test, mu);
X_poly_test = bsxfun(@rdivide, X_poly_test, sigma);
X_poly_test = [ones(size(X_poly_test, 1), 1), X_poly_test];         % Add Ones

% Map X_poly_val and normalize (using mu and sigma)
X_poly_val = polyMultiFeatures(Xval, p);
X_poly_val = bsxfun(@minus, X_poly_val, mu);
X_poly_val = bsxfun(@rdivide, X_poly_val, sigma);
X_poly_val = [ones(size(X_poly_val, 1), 1), X_poly_val];           % Add Ones

fprintf('Normalized Training Example 4:\n');
X_poly(4, :)
%fprintf('  %f  \n', X_poly(1, :));

fprintf('\nProgram paused. Press enter to continue.\n');
pause;


%% =========== Part 8: Validation for Selecting Lambda =============
%  You will now implement validationCurve to test various values of 
%  lambda on a validation set. You will then use this to select the
%  "best" lambda value.
%

[lambda_vec, error_train, error_val] = ...
    validationCurve(X_poly, y, X_poly_val, yval);

close all;
figure(1);
plot(lambda_vec, error_train, lambda_vec, error_val);
legend('Train', 'Cross Validation');
xlabel('lambda');
ylabel('Error');

min_error_val = Inf;
min_lambda = 0;
for i = 1:length(lambda_vec)
	fprintf(' %f\t%f\t%f\n', ...
            lambda_vec(i), error_train(i), error_val(i));
    if min_error_val > error_val(i)
        min_lambda = lambda_vec(i);
        min_error_val = error_val(i);
    end
end

fprintf('Validation for Selecting Lambda finished, lambda %f\n',min_lambda);
fprintf('Program paused. Press enter to continue.\n');
pause;


%% =========== Part 5: Learning Curve for Linear Regression =============
%  Next, you should implement the learningCurve function. 
%
%  Write Up Note: Since the model is underfitting the data, we expect to
%                 see a graph with "high bias" -- slide 8 in ML-advice.pdf 
%
lambda = min_lambda;



[theta] = trainLinearReg(X_poly, y, lambda);

y_pred = X_poly * theta;
exp_var_training = explained_variance_score(y,y_pred);
fprintf('Explained variance score (training): %f \n',exp_var_training);

ytest_pred = X_poly_test * theta;
exp_var_test = explained_variance_score(ytest,ytest_pred);
fprintf('Explained variance score (test): %f \n',exp_var_test);


%[theta] = trainLinearReg(X_poly, y, lambda);
fprintf('Learning Curve starting.\n');
[error_train, error_val] = ...
    learningCurve(X_poly, y, ...
                  X_poly_val, yval, ...
                  lambda);
figure(2);
plot(1:m, error_train, 1:m, error_val);
title('Learning curve for linear regression')
legend('Train', 'Cross Validation')
xlabel('Number of training examples')
ylabel('Error')
axis([0 m 0 0.02])

fprintf('# Training Examples\tTrain Error\tCross Validation Error\n');
for i = 1:m
    fprintf('  \t%d\t\t%f\t%f\n', i, error_train(i), error_val(i));
end
fprintf('Learning Curve finished.\n');
%fprintf('Program paused. Press enter to continue.\n');
%pause;
