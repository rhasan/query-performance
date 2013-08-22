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

selected_features = [1 2 3 4 5 6 18 19];
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

%options = sprintf('-c %1.3f -g %1.3f',C,sigma);
%model = svmtrain(y, X, options);
%[predict_label, accuracy, dec_values] = svmpredict(yval, Xval, model);

%nu = 1;
%C = 1;
%[C, nu] = getSVRParams(X,y,Xval,yval);

C=3;
nu=0.3;
tic;model = svmtrain(y,X,['-s 4 -t 2 -n ' num2str(nu) ' -c ' num2str(C)]);toc


[y_pred,acc_train,prob_train] = svmpredict(y,X,model);
%y_pred = X_poly * theta;
exp_var_training = explained_variance_score(y,y_pred);
fprintf('Explained variance score (training): %f \n',exp_var_training);

%ytest_pred = X_poly_test * theta;
[ytest_pred,acc_test,prob_test]=svmpredict(ytest,Xtest,model);
exp_var_test = explained_variance_score(ytest,ytest_pred);
fprintf('Explained variance score (test): %f \n',exp_var_test);


%tmp = corrcoef( y, y_pred)
%tmp1 = corrcoef(ytest,ytest_pred)
%tmp
