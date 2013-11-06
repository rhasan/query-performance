y = csvread('../6000/y_time.txt',1,0);
y_pred = csvread('../6000/y_time_pred.txt',1,0);

ytest = csvread('../6000/ytest_time.txt',1,0);
ytest_pred = csvread('../6000/ytest_time_pred.txt',1,0);



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

% 
% figure(2)
% plot(yval_pred,yval,'x');
% ylabel('Actual execution time')
% xlabel('Predicted execution time')
% title('Validation set')
% axis([0 max(max(yval,yval_pred)) 0 max(max(yval,yval_pred))])
% 
% exp_var_validation = explained_variance_score(yval,yval_pred);
% rsq = corrcoef(yval, yval_pred);
% rsq = rsq(2)^2;
% fprintf('R-squared (validation): %f \n',rsq);
% fprintf('Explained variance score (validation): %f \n',exp_var_validation);
% fprintf('------------------------------\n');


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