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

X = csvread('../6000/x_features.txt',1,0);
Xval = csvread('../6000/xval_features.txt',1,0);
Xtest = csvread('../6000/xtest_features.txt',1,0);


y = csvread('../6000/y_time.txt',1,0);
yval = csvread('../6000/yval_time.txt',1,0);
ytest = csvread('../6000/ytest_time.txt',1,0);

%y = csvread('../6000/y_record_tdb.txt');
%yval = csvread('../6000/yval_record_tdb.txt');
%ytest = csvread('../6000/ytest_record_tdb.txt');


X_extra = csvread('../6000/x_features_simvec.txt',1,0);
Xval_extra = csvread('../6000/xval_features_simvec.txt',1,0);
Xtest_extra = csvread('../6000/xtest_features_simvec.txt',1,0);

[ X, Xval, Xtest ] = merge_extra_features(X, Xval, Xtest, X_extra, Xval_extra, Xtest_extra);

% % 
% outlier = 1500;
% X = X(y <= outlier,:);
% y = y(y <= outlier,:);
% % % % 
% Xval = Xval(yval <= outlier,:);
% yval = yval(yval <= outlier,:);
% % % % 
% Xtest = Xtest(ytest <= outlier,:);
% ytest = ytest(ytest <= outlier,:);


%selected_features = [1 2 3 4 5 6 8 17 18 19 23];
%selected_features = [1:24];

%selected_features = mean(X)~=0;
selected_features = var(X)~=0;
[ X, Xval, Xtest] = select_features(selected_features,X, Xval, Xtest);

% m = Number of examples
m = size(X, 1);


%fprintf('Program paused. Press enter to continue.\n');
%pause;

%=========== reduce dimention ===============
K=1;
[Z ,U, S] = reduce_dimention(X,K);
[Zval ,Uval, Sval] = reduce_dimention(Xval,K);
[Ztest ,Utest, Stest] = reduce_dimention(Xtest,K);

X = Z;
Xval = Zval;
Xtest = Ztest;

figure(3);
plot(X, y, 'rx', 'MarkerSize', 10);

title('Dataset plotted in 2D, using PCA for dimensionality reduction');
%pause;