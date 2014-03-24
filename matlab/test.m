
y = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb/y_time.txt',1,0);
yval = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb/yval_time.txt',1,0);
ytest = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb/ytest_time.txt',1,0);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% k_dm = 5 %k_nn = 2
y_pred_k5_knn2 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K5/knn-k2/y_time_pred.txt',1,0);

yval_pred_k5_knn2 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K5/knn-k2/yval_time_pred.txt',1,0);
ytest_pred_k5_knn2 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K5/knn-k2/ytest_time_pred.txt',1,0);


reval_k5_knn2 = relative_error(yval,yval_pred_k5_knn2);