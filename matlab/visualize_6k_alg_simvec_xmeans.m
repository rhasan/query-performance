y = csvread('../6000/y_time.txt',1,0);
y_pred = csvread('../6000/y_time_pred.txt',1,0);

ytest = csvread('../6000/ytest_time.txt',1,0);
ytest_pred = csvread('../6000/ytest_time_pred.txt',1,0);



figure(1)
scatter(y_pred,y,'x');
ylabel('Actual execution time')
xlabel('Predicted execution time')
title('Training set')
axis([0 max(max(y,y_pred)) 0 max(max(y,y_pred))])

exp_var_training = explained_variance_score(y,y_pred);
rsq_training = corrcoef(y, y_pred);
rsq_training = rsq_training(2)^2;
fprintf('R-squared (training): %f \n',rsq_training);
fprintf('Explained variance score (training): %f \n',exp_var_training);


figure(2)
scatter(ytest_pred,ytest,'x');
ylabel('Actual execution time')
xlabel('Predicted execution time')
title('Training set')
axis([0 max(max(ytest,ytest_pred)) 0 max(max(ytest,ytest_pred))])

exp_var_training = explained_variance_score(ytest,ytest_pred);
rsq_test = corrcoef(ytest, ytest_pred);
rsq_test = rsq_test(2)^2;
fprintf('R-squared (test): %f \n',rsq_test);

fprintf('Explained variance score (test): %f \n',exp_var_training);