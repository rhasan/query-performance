clear all;
y = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb/y_time.txt',1,0);
yval = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb/yval_time.txt',1,0);
ytest = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb/ytest_time.txt',1,0);

x_template = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb/x_template.txt',0,0);
xval_template = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb/xval_template.txt',0,0);
xtest_template = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb/xtest_template.txt',0,0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% k_dm = 5 %k_nn = 2
y_pred = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K5/knn-k2/y_time_pred.txt',1,0);

yval_pred = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K5/knn-k2/yval_time_pred.txt',1,0);
ytest_pred = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K5/knn-k2/ytest_time_pred.txt',1,0);



templates = [1 3 4 5 6 7 8 9 10 11 12 13 14 15 17 18 19 22 23 24 25];


nt = length(templates);
qpt = 20+1;

mat_X = zeros(qpt,nt);
mat_X(1,:) = templates(:)';

for i = 1:length(templates)
    
    templ = templates(i);
    fprintf('Template=%d\n',templ);
    ytest_templ_i = ytest(xtest_template(:)==templ,1);
    %t = length(ytest_templ_i)
    %mat_X(i,1:end) = min(ytest_templ_i);
    mat_X(2:end,i) = ytest_templ_i(:);
    %ytest_pred_i = ytest_pred(xtest_template(:)==templ,1)
end
%boxplot(mat_X)

%legend('Template RMSE','Overall RMSE','Location','NorthWest')