

y = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb/y_time.txt',1,0);
yval = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb/yval_time.txt',1,0);
ytest = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb/ytest_time.txt',1,0);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% k_dm = 5 %k_nn = 2
y_pred_k5_knn2 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K5/knn-k2/y_time_pred.txt',1,0);

yval_pred_k5_knn2 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K5/knn-k2/yval_time_pred.txt',1,0);
ytest_pred_k5_knn2 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K5/knn-k2/ytest_time_pred.txt',1,0);


rsval_k5_knn2 = r_square(yval,yval_pred_k5_knn2);
reval_k5_knn2 = rmse(yval,yval_pred_k5_knn2);

%%%%%%% k_dm = 5 %k_nn = 3
y_pred_k5_knn3 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K5/knn-k3/y_time_pred.txt',1,0);

yval_pred_k5_knn3 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K5/knn-k3/yval_time_pred.txt',1,0);
ytest_pred_k5_knn3 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K5/knn-k3/ytest_time_pred.txt',1,0);


rsval_k5_knn3 = r_square(yval,yval_pred_k5_knn3);
reval_k5_knn3 = rmse(yval,yval_pred_k5_knn3);



%%%%%%% k_dm = 5 %k_nn = 4
y_pred_k5_knn4 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K5/knn-k4/y_time_pred.txt',1,0);

yval_pred_k5_knn4 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K5/knn-k4/yval_time_pred.txt',1,0);
ytest_pred_k5_knn4 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K5/knn-k4/ytest_time_pred.txt',1,0);


rsval_k5_knn4 = r_square(yval,yval_pred_k5_knn4);
reval_k5_knn4 = rmse(yval,yval_pred_k5_knn4);



%%%%%%% k_dm = 5 %k_nn = 5
y_pred_k5_knn5 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K5/knn-k5/y_time_pred.txt',1,0);

yval_pred_k5_knn5 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K5/knn-k5/yval_time_pred.txt',1,0);
ytest_pred_k5_knn5 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K5/knn-k5/ytest_time_pred.txt',1,0);

rsval_k5_knn5 = r_square(yval,yval_pred_k5_knn5);
reval_k5_knn5 = rmse(yval,yval_pred_k5_knn5);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% k_dm = 10 %k_nn = 2
y_pred_k10_knn2 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K10/knn-k2/y_time_pred.txt',1,0);

yval_pred_k10_knn2 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K10/knn-k2/yval_time_pred.txt',1,0);
ytest_pred_k10_knn2 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K10/knn-k2/ytest_time_pred.txt',1,0);

rsval_k10_knn2 = r_square(yval,yval_pred_k10_knn2);
reval_k10_knn2 = rmse(yval,yval_pred_k10_knn2);


%%%%%%% k_dm = 10 %k_nn = 3
y_pred_k10_knn3 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K10/knn-k3/y_time_pred.txt',1,0);

yval_pred_k10_knn3 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K10/knn-k3/yval_time_pred.txt',1,0);
ytest_pred_k10_knn3 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K10/knn-k3/ytest_time_pred.txt',1,0);

rsval_k10_knn3 = r_square(yval,yval_pred_k10_knn3);
reval_k10_knn3 = rmse(yval,yval_pred_k10_knn3);

%%%%%%% k_dm = 10 %k_nn = 4
y_pred_k10_knn4 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K10/knn-k4/y_time_pred.txt',1,0);

yval_pred_k10_knn4 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K10/knn-k4/yval_time_pred.txt',1,0);
ytest_pred_k10_knn4 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K10/knn-k4/ytest_time_pred.txt',1,0);

rsval_k10_knn4 = r_square(yval,yval_pred_k10_knn4);
reval_k10_knn4 = rmse(yval,yval_pred_k10_knn4);

%%%%%%% k_dm = 10 %k_nn = 5
y_pred_k10_knn5 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K10/knn-k5/y_time_pred.txt',1,0);
yval_pred_k10_knn5 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K10/knn-k5/yval_time_pred.txt',1,0);
ytest_pred_k10_knn5 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K10/knn-k5/ytest_time_pred.txt',1,0);

rsval_k10_knn5 = r_square(yval,yval_pred_k10_knn5);
reval_k10_knn5 = rmse(yval,yval_pred_k10_knn5);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% k_dm = 15 %k_nn = 2
y_pred_k15_knn2 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K15/knn-k2/y_time_pred.txt',1,0);
yval_pred_k15_knn2 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K15/knn-k2/yval_time_pred.txt',1,0);
ytest_pred_k15_knn2 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K15/knn-k2/ytest_time_pred.txt',1,0);

rsval_k15_knn2 = r_square(yval,yval_pred_k15_knn2);
reval_k15_knn2 = rmse(yval,yval_pred_k15_knn2);


%%%%%%% k_dm = 15 %k_nn = 3
y_pred_k15_knn3 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K15/knn-k3/y_time_pred.txt',1,0);
yval_pred_k15_knn3 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K15/knn-k3/yval_time_pred.txt',1,0);
ytest_pred_k15_knn3 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K15/knn-k3/ytest_time_pred.txt',1,0);

rsval_k15_knn3 = r_square(yval,yval_pred_k15_knn3);
reval_k15_knn3 = rmse(yval,yval_pred_k15_knn3);

%%%%%%% k_dm = 15 %k_nn = 4
y_pred_k15_knn4 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K15/knn-k4/y_time_pred.txt',1,0);
yval_pred_k15_knn4 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K15/knn-k4/yval_time_pred.txt',1,0);
ytest_pred_k15_knn4 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K15/knn-k4/ytest_time_pred.txt',1,0);

rsval_k15_knn4 = r_square(yval,yval_pred_k15_knn4);
reval_k15_knn4 = rmse(yval,yval_pred_k15_knn4);

%%%%%%% k_dm = 15 %k_nn = 5
y_pred_k15_knn5 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K15/knn-k5/y_time_pred.txt',1,0);
yval_pred_k15_knn5 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K15/knn-k5/yval_time_pred.txt',1,0);
ytest_pred_k15_knn5 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K15/knn-k5/ytest_time_pred.txt',1,0);

rsval_k15_knn5 = r_square(yval,yval_pred_k15_knn5);
reval_k15_knn5 = rmse(yval,yval_pred_k15_knn5);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% k_dm = 20 %k_nn = 2
y_pred_k20_knn2 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K20/knn-k2/y_time_pred.txt',1,0);
yval_pred_k20_knn2 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K20/knn-k2/yval_time_pred.txt',1,0);
ytest_pred_k20_knn2 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K20/knn-k2/ytest_time_pred.txt',1,0);

rsval_k20_knn2 = r_square(yval,yval_pred_k20_knn2);
reval_k20_knn2 = rmse(yval,yval_pred_k20_knn2);

%%%%%%% k_dm = 20 %k_nn = 3
y_pred_k20_knn3 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K20/knn-k3/y_time_pred.txt',1,0);
yval_pred_k20_knn3 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K20/knn-k3/yval_time_pred.txt',1,0);
ytest_pred_k20_knn3 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K20/knn-k3/ytest_time_pred.txt',1,0);

rsval_k20_knn3 = r_square(yval,yval_pred_k20_knn3);
reval_k20_knn3 = rmse(yval,yval_pred_k20_knn3);

%%%%%%% k_dm = 20 %k_nn = 4
y_pred_k20_knn4 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K20/knn-k4/y_time_pred.txt',1,0);
yval_pred_k20_knn4 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K20/knn-k4/yval_time_pred.txt',1,0);
ytest_pred_k20_knn4 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K20/knn-k4/ytest_time_pred.txt',1,0);

rsval_k20_knn4 = r_square(yval,yval_pred_k20_knn4);
reval_k20_knn4 = rmse(yval,yval_pred_k20_knn4);

%%%%%%% k_dm = 20 %k_nn = 5
y_pred_k20_knn5 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K20/knn-k5/y_time_pred.txt',1,0);
yval_pred_k20_knn5 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K20/knn-k5/yval_time_pred.txt',1,0);
ytest_pred_k20_knn5 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K20/knn-k5/ytest_time_pred.txt',1,0);

rsval_k20_knn5 = r_square(yval,yval_pred_k20_knn5);
reval_k20_knn5 = rmse(yval,yval_pred_k20_knn5);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% k_dm = 25 %k_nn = 2
y_pred_k25_knn2 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K25/knn-k2/y_time_pred.txt',1,0);
yval_pred_k25_knn2 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K25/knn-k2/yval_time_pred.txt',1,0);
ytest_pred_k25_knn2 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K25/knn-k2/ytest_time_pred.txt',1,0);

rsval_k25_knn2 = r_square(yval,yval_pred_k25_knn2);
reval_k25_knn2 = rmse(yval,yval_pred_k25_knn2);

%%%%%%% k_dm = 25 %k_nn = 3
y_pred_k25_knn3 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K25/knn-k3/y_time_pred.txt',1,0);
yval_pred_k25_knn3 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K25/knn-k3/yval_time_pred.txt',1,0);
ytest_pred_k25_knn3 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K25/knn-k3/ytest_time_pred.txt',1,0);

rsval_k25_knn3 = r_square(yval,yval_pred_k25_knn3);
reval_k25_knn3 = rmse(yval,yval_pred_k25_knn3);

%%%%%%% k_dm = 25 %k_nn = 4
y_pred_k25_knn4 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K25/knn-k4/y_time_pred.txt',1,0);
yval_pred_k25_knn4 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K25/knn-k4/yval_time_pred.txt',1,0);
ytest_pred_k25_knn4 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K25/knn-k4/ytest_time_pred.txt',1,0);

rsval_k25_knn4 = r_square(yval,yval_pred_k25_knn4);
reval_k25_knn4 = rmse(yval,yval_pred_k25_knn4);

%%%%%%% k_dm = 25 %k_nn = 5
y_pred_k25_knn5 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K25/knn-k5/y_time_pred.txt',1,0);
yval_pred_k25_knn5 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K25/knn-k5/yval_time_pred.txt',1,0);
ytest_pred_k25_knn5 = csvread('/Users/hrakebul/Documents/code/query-performance/dbpsb-K25/knn-k5/ytest_time_pred.txt',1,0);

rsval_k25_knn5 = r_square(yval,yval_pred_k25_knn5);
reval_k25_knn5 = rmse(yval,yval_pred_k25_knn5);




X = [5 10 15 20 25]; %K
Y = [2 3 4 5]; %k for k-nn
Z = [ rsval_k5_knn2 rsval_k10_knn2 rsval_k15_knn2 rsval_k20_knn2 rsval_k25_knn2;
      rsval_k5_knn3 rsval_k10_knn3 rsval_k15_knn3 rsval_k20_knn3 rsval_k25_knn3;
      rsval_k5_knn4 rsval_k10_knn4 rsval_k15_knn4 rsval_k20_knn4 rsval_k25_knn4;
      rsval_k5_knn5 rsval_k10_knn5 rsval_k15_knn5 rsval_k20_knn5 rsval_k25_knn5]; %R-squared

Z1 = [ reval_k5_knn2 reval_k10_knn2 reval_k15_knn2 reval_k20_knn2 reval_k25_knn2;
      reval_k5_knn3 reval_k10_knn3 reval_k15_knn3 reval_k20_knn3 reval_k25_knn3;
      reval_k5_knn4 reval_k10_knn4 reval_k15_knn4 reval_k20_knn4 reval_k25_knn4;
      reval_k5_knn5 reval_k10_knn5 reval_k15_knn5 reval_k20_knn5 reval_k25_knn5]; %Relative absolute error 




figure;
subplot(1,2,1)
surf(X,Y,Z1);
alpha(0.5);

axis tight; hold on;
set(gca,'YTick',2:1:5);
set(gca,'XTick',5:5:25);

xlabel('K_{gp}');
ylabel('k');
zlabel('RMSE');

th = title('\fontsize{11} (a) RMSE values for different K_{gp} and k');
thpos = get(th,'Position');
set(th,'Position',[thpos(1) thpos(2) thpos(3)-25]);
set(th,'FontWeight','bold');

subplot(1,2,2);
%[X,Y,Z] = meshgrid(X,Y,Z);
surf(X,Y,Z);
alpha(0.5);
%mesh(X,Y,Z); %interpolated

axis tight; hold on;
set(gca,'YTick',2:1:5);
set(gca,'XTick',5:5:25);

xlabel('K_{gp}');
ylabel('k');
zlabel('R^2');

th1 = title('\fontsize{11}(b) R^2 values for different K_{gp} and k');
th1pos = get(th1,'Position');
set(th1,'Position',[th1pos(1) th1pos(2) min(min(Z))-0.0013]);
set(th1,'FontWeight','bold');


hFig = figure(1);
set(hFig, 'Position', [100 100 800 400]);
%set(hFig, 'Position', [100 100 600 500]);




