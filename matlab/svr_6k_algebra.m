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
% figure(3);
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

%exp_var_training = explained_variance_score(y,y_pred);
%fprintf('Explained variance score (training): %f \n',exp_var_training);

[yval_pred,acc_val,prob_val]=svmpredict(yval,Xval_nor,model);


%exp_var_val = explained_variance_score(yval,yval_pred);
%fprintf('Explained variance score (validation): %f \n',exp_var_val);


%ytest_pred = X_poly_test * theta;
[ytest_pred,acc_test,prob_test]=svmpredict(ytest,Xtest_nor,model);


%exp_var_test = explained_variance_score(ytest,ytest_pred);
%fprintf('Explained variance score (test): %f \n',exp_var_test);



fprintf('------------------------------\n');
figure(1)
plot(y_pred,y,'x');
ylabel('Actual execution time')
xlabel('Predicted execution time')
title('Training set')
axis([0 max(max(y,y_pred)) 0 max(max(y,y_pred))])

exp_var_training = explained_variance_score(y,y_pred);
rsq_training = corrcoef(y, y_pred);
rsq_training = rsq_training(2)^2;
fprintf('R-squared (training): %f \n',rsq_training);
fprintf('Explained variance score (training): %f \n',exp_var_training);
fprintf('------------------------------\n');


figure(2)
plot(yval_pred,yval,'x');
ylabel('Actual execution time')
xlabel('Predicted execution time')
title('Validation set')
axis([0 max(max(yval,yval_pred)) 0 max(max(yval,yval_pred))])

exp_var_validation = explained_variance_score(yval,yval_pred);
rsq = corrcoef(yval, yval_pred);
rsq = rsq(2)^2;
fprintf('R-squared (validation): %f \n',rsq);
fprintf('Explained variance score (validation): %f \n',exp_var_validation);
fprintf('------------------------------\n');


figure(3)
log_log_ytest_pred = (log(ytest_pred));
log_log_ytest = (log(ytest));
min_test = min(min(min(log_log_ytest_pred)),min(min(log_log_ytest)));
max_test = max(max(max(log_log_ytest_pred)),max(max(log_log_ytest)));
plot(log_log_ytest_pred,log_log_ytest,'+');
ylabel('Log of actual execution time')
xlabel('Log of predicted execution time')
title('Test set (log scale)')
hold on

%plot(linspace(0,max(max(log_log_ytest,log_log_ytest_pred))),linspace(0,max(max(log_log_ytest,log_log_ytest_pred))),'-g')
a = annotation('textarrow', [.3 .5], [.6 .5],'String','Perfect prediction');
%axis([0 max(max(ytest,ytest_pred)) 0 max(max(ytest,ytest_pred))])
axis([min_test max_test min_test max_test])
hline = refline([1 0]);
set(hline,'Color','g');


exp_var_test = explained_variance_score(ytest,ytest_pred);
rsq = corrcoef(ytest, ytest_pred);
rsq = rsq(2)^2;
fprintf('R-squared (test): %f \n',rsq);
fprintf('Explained variance score (test): %f \n',exp_var_test);



figure(4)

min_test = min(min(min(ytest_pred)),min(min(ytest)));
max_test = max(max(max(ytest_pred)),max(max(ytest)));
plot(ytest_pred,ytest,'+');
ylabel('Actual execution time')
xlabel('Predicted execution time')
title('Test set')
hold on

%plot(linspace(0,max(max(log_log_ytest,log_log_ytest_pred))),linspace(0,max(max(log_log_ytest,log_log_ytest_pred))),'-g')
a = annotation('textarrow', [.3 .5], [.6 .5],'String','Perfect prediction');
%axis([0 max(max(ytest,ytest_pred)) 0 max(max(ytest,ytest_pred))])
axis([min_test max_test min_test max_test])
hline = refline([1 0]);
set(hline,'Color','g');

