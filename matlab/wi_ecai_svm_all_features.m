
clear all;
y = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb/y_time.txt',1,0);
yval = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb/yval_time.txt',1,0);
ytest = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb/ytest_time.txt',1,0);

x_template = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb/x_template.txt',1,0);
xval_template = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb/xval_template.txt',1,0);
xtest_template = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb/xtest_template.txt',1,0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 

y_out = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K25/svm/training_output.txt',1,2);
y_pred = y_out(:,1);

yval_out = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K25/svm/val_output.txt',1,2);
yval_pred = yval_out(:,1);

ytest_out = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K25/svm/test_output.txt',1,2);
ytest_pred = ytest_out(:,1);

rsval = r_square(yval,yval_pred);
reval = rmse(yval,yval_pred);


rstest = r_square(ytest,ytest_pred);
retest = rmse(ytest,ytest_pred);
rsq_test_score = rstest;


templates = [1 3 4 5 6 7 8 9 10 11 12 13 14 15 17 18 19 22 23 24 25];
rsq_test = zeros(length(templates),1);
re_test = zeros(length(templates),1);


for i = 1:length(templates)
    
    templ = templates(i);
    fprintf('Template=%d\n',templ);
    ytest_templ_i = ytest(xtest_template(:)==templ,1);
    ytest_pred_i = ytest_pred(xtest_template(:)==templ,1);
    rsq_test(i) = r_square(ytest_templ_i,ytest_pred_i);
    %tmp = corrcoef(ytest_templ_i,ytest_pred_i);
    %rsq_test(i) = tmp(2);
    %re_test(i) = rmse(ytest_templ_i,ytest_pred_i);
    re_test(i) = rmse(ytest_templ_i,ytest_pred_i);
end

test_rmse = rmse(ytest,ytest_pred);

%bar(rmse_vals);
figure(1);
subplot(2,2,3)
min_test = min(min(min(ytest_pred)),min(min(ytest)));
max_test = max(max(max(ytest_pred)),max(max(ytest)));
%plot(ytest,ytest,'-rs','MarkerSize',5);
xlabel('Predicted execution time (ms)')
ylabel('Actual execution time (ms)')
hold on
plot(ytest_pred,ytest,'+','MarkerSize',8);
axis([min_test-1 max_test+1 min_test-1 max_test+1])
set(gca,'XTick',0:1000:max_test)
set(gca,'YTick',0:1000:max_test)
grid on
hline = refline([1 0]);
set(hline,'Color','r');
legend('Predicted vs. actual data point','Perfect prediction','Location','NorthWest')
th = title(['\fontsize{11}(c) SVM using algebra and graph pattern features (R^2=',num2str(rsq_test_score),')']);
thpos = get(th,'Position');
set(th,'Position',[thpos(1) -2000]);
set(th,'FontWeight','bold');


%sub
subplot(2,2,4)
bar(re_test)
axis tight;
hold on
xlabel('DBPSB Template')
ylabel('RMSE')
set(gca, 'XTickLabel',templates, 'XTick',1:numel(templates))
set(gca,'YTick',0:100:1500)
ylim([0 1500])

xlim=get(gca,'xlim');
plot(xlim,[test_rmse test_rmse], '--k');

legend('Template RMSE','Overall RMSE','Location','NorthWest')
th1 = title({'\fontsize{11}(d) RMSE for SVM using algebra and graph pattern features'});
th1pos = get(th1,'Position');
set(th1,'Position',[th1pos(1) -340]);
set(th1,'FontWeight','bold');


hFig = figure(1);
set(hFig, 'Position', [100 100 800 625])
