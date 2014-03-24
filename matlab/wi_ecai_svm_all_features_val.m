
y = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb/y_time.txt',1,0);
yval = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb/yval_time.txt',1,0);
ytest = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb/ytest_time.txt',1,0);

x_template = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb/x_template.txt',1,0);
xval_template = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb/xval_template.txt',1,0);
xtest_template = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb/xtest_template.txt',1,0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 


yval_out_kdm5 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K5/svm/val_output.txt',1,2);
yval_pred_kdm5 = yval_out_kdm5(:,1);

rsval_kdm5 = r_square(yval,yval_pred_kdm5);
reval_kdm5 = rmse(yval,yval_pred_kdm5);

yval_out_kdm10 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K10/svm/val_output.txt',1,2);
yval_pred_kdm10 = yval_out_kdm10(:,1);

rsval_kdm10 = r_square(yval,yval_pred_kdm10);
reval_kdm10 = rmse(yval,yval_pred_kdm10);


yval_out_kdm15 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K15/svm/val_output.txt',1,2);
yval_pred_kdm15 = yval_out_kdm15(:,1);

rsval_kdm15 = r_square(yval,yval_pred_kdm15);
reval_kdm15 = rmse(yval,yval_pred_kdm15);



yval_out_kdm20 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K20/svm/val_output.txt',1,2);
yval_pred_kdm20 = yval_out_kdm20(:,1);

rsval_kdm20 = r_square(yval,yval_pred_kdm20);
reval_kdm20 = rmse(yval,yval_pred_kdm20);




yval_out_kdm25 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K25/svm/val_output.txt',1,2);
yval_pred_kdm25 = yval_out_kdm25(:,1);


rsval_kdm25 = r_square(yval,yval_pred_kdm25);
reval_kdm25 = rmse(yval,yval_pred_kdm25);

rmse_val = [reval_kdm5 reval_kdm10 reval_kdm15 reval_kdm20 reval_kdm25]
rsq_val = [rsval_kdm5 rsval_kdm10 rsval_kdm15 rsval_kdm20 rsval_kdm25]

ytest_out_kdm25 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K25/svm/test_output.txt',1,2);
ytest_pred_kdm25 = ytest_out_kdm25(:,1);
rmsetest_kdm25 = rmse(ytest,ytest_pred_kdm25)
rstest_kdm25 = r_square(ytest,ytest_pred_kdm25)
