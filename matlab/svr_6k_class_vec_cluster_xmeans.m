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



X_class = csvread('../6000/x_features_class_xmeans.txt',1,0);
Xval_class = csvread('../6000/xval_features_class_xmeans.txt',1,0);
Xtest_class = csvread('../6000/xtest_features_class_xmeans.txt',1,0);

[ X, Xval, Xtest ] = merge_extra_features(X, Xval, Xtest, X_class, Xval_class, Xtest_class);

%selected_features = [1 2 3 4 5 6 18 19];
%removing useless features

% 
outlier = 1500;
X = X(y <= outlier,:);
y = y(y <= outlier,:);
% % % 
Xval = Xval(yval <= outlier,:);
yval = yval(yval <= outlier,:);
% % % 
Xtest = Xtest(ytest <= outlier,:);
ytest = ytest(ytest <= outlier,:);


%selected_features = [1 2 3 4 5 6 8 17 18 19 23];
%selected_features = [1:24];

%selected_features = mean(X)~=0;
selected_features = var(X)~=0;
[ X, Xval, Xtest] = select_features(selected_features,X, Xval, Xtest);

% m = Number of examples
m = size(X, 1);


%fprintf('Program paused. Press enter to continue.\n');
%pause;

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

%% =========== normalize features ================
%normalize
%[X_nor, X_mu, X_sigma,X_mean] = featureNormalizeZeroMean(X);  
%[Xval_nor] = featureNormalizePredZeroMean(Xval, X_mu, X_sigma,X_mean);  
%[Xtest_nor] = featureNormalizePredZeroMean(Xtest, X_mu, X_sigma,X_mean);

[X_nor, X_mu, X_sigma] = featureNormalize(X);  
[Xval_nor] = featureNormalizePred(Xval, X_mu, X_sigma);  
[Xtest_nor] = featureNormalizePred(Xtest, X_mu, X_sigma);
%% =================== cross validating C and nu parameters ========

%nu = 1;
%C = 1;
C=300;
nu=1;

%[C, nu] = getSVRParams(X_nor,y,Xval_nor,yval);



%% =========== Part 5: Learning Curve for SVR Regression =============
% fprintf('Learning Curve starting.\n');
% [error_train, error_val] = ...
%     learningCurveSVR(X_nor, y, ...
%                   Xval_nor, yval, ...
%                   C,nu);
% figure(2);
% plot(1:m, error_train, 1:m, error_val);
% title('Learning curve for linear regression')
% legend('Train', 'Cross Validation')
% xlabel('Number of training examples')
% ylabel('Error')
% %axis([0 m 0 0.02])
% 
% fprintf('# Training Examples\tTrain Error\tCross Validation Error\n');
% for i = 1:m
%     fprintf('  \t%d\t\t%f\t%f\n', i, error_train(i), error_val(i));
% end
% fprintf('Learning Curve finished.\n');

%%==================== training and evaluating SVR ======================
%options = sprintf('-c %1.3f -g %1.3f',C,sigma);
%model = svmtrain(y, X, options);
%[predict_label, accuracy, dec_values] = svmpredict(yval, Xval, model);



tic;model = svmtrain(y,X_nor,['-s 4 -t 2 -n ' num2str(nu) ' -c ' num2str(C)]);toc


[y_pred,acc_train,prob_train] = svmpredict(y,X_nor,model);
%y_pred = X_poly * theta;

exp_var_training = explained_variance_score(y,y_pred);
fprintf('Explained variance score (training): %f \n',exp_var_training);



%ytest_pred = X_poly_test * theta;
[ytest_pred,acc_test,prob_test]=svmpredict(ytest,Xtest_nor,model);


exp_var_test = explained_variance_score(ytest,ytest_pred);
fprintf('Explained variance score (test): %f \n',exp_var_test);

figure(3)
scatter(y,y_pred,'x');
xlabel('Actual execution time')
ylabel('Predicted execution time')
title('Training set')
axis([0 max(max(y,y_pred)) 0 max(max(y,y_pred))])
%axis([0 50 0 50])



figure(4)
scatter(ytest,ytest_pred,'x');
xlabel('Actual execution time');
ylabel('Predicted execution time');
title('Test set');
axis([0 max(max(ytest,ytest_pred)) 0 max(max(ytest,ytest_pred))]);
%axis([0 50 0 50]);
%tmp = corrcoef( y, y_pred)
%tmp1 = corrcoef(ytest,ytest_pred)
%tmp
