%% ================ experiment with features ==============
X = csvread('../x_features.txt');
y = csvread('../y_time.txt');
K = 1;

[X_norm, mu, sigma,X_mean] = featureNormalizeZeroMean(X);

%  Run PCA
[Z ,U, S] = reduce_dimention(X_norm,K);



figure(25);
plot(Z(:,1), y, 'rx', 'MarkerSize', 10);

title('Dataset plotted in 2D, using PCA for dimensionality reduction');
pause;

%triple
figure(1);
%plotDataPoints(Z, , K);
plot(X(:,1), y, 'rx', 'MarkerSize', 10);

title('Triples in X, Time in y');

%bgp
figure(2);
%plotDataPoints(Z, , K);
plot(X(:,2), y, 'rx', 'MarkerSize', 10);

title('bgp in X, Time in y');

%join
figure(3);
%plotDataPoints(Z, , K);
plot(X(:,3), y, 'rx', 'MarkerSize', 10);

title('join in X, Time in y');

%leftjoin
figure(4);
%plotDataPoints(Z, , K);
plot(X(:,4), y, 'rx', 'MarkerSize', 10);

title('leftjoin in X, Time in y');


%union
figure(5);
%plotDataPoints(Z, , K);
plot(X(:,5), y, 'rx', 'MarkerSize', 10);

title('union in X, Time in y');

%filter
figure(6);
%plotDataPoints(Z, , K);
plot(X(:,6), y, 'rx', 'MarkerSize', 10);

title('filter in X, Time in y');


%graph
figure(7);
%plotDataPoints(Z, , K);
plot(X(:,7), y, 'rx', 'MarkerSize', 10);

title('graph in X, Time in y');

%extend
figure(8);
%plotDataPoints(Z, , K);
plot(X(:,8), y, 'rx', 'MarkerSize', 10);

title('extend in X, Time in y');



%minus
figure(9);
%plotDataPoints(Z, , K);
plot(X(:,9), y, 'rx', 'MarkerSize', 10);

title('minus in X, Time in y');


%path\*
figure(10);
%plotDataPoints(Z, , K);
plot(X(:,10), y, 'rx', 'MarkerSize', 10);

title('path\\* in X, Time in y');



%pathN\*
figure(11);
%plotDataPoints(Z, , K);
plot(X(:,11), y, 'rx', 'MarkerSize', 10);

title('pathN\\* in X, Time in y');



%path\+
figure(12);
%plotDataPoints(Z, , K);
plot(X(:,12), y, 'rx', 'MarkerSize', 10);

title('path\\+ in X, Time in y');


%pathN\+
figure(13);
%plotDataPoints(Z, , K);
plot(X(:,13), y, 'rx', 'MarkerSize', 10);

title('pathN\\+ in X, Time in y');


%path\?
figure(14);
%plotDataPoints(Z, , K);
plot(X(:,14), y, 'rx', 'MarkerSize', 10);

title('path\\? in X, Time in y');



%notoneof
figure(15);
%plotDataPoints(Z, , K);
plot(X(:,15), y, 'rx', 'MarkerSize', 10);

title('notoneof in X, Time in y');



%tolist
figure(16);
%plotDataPoints(Z, , K);
plot(X(:,16), y, 'rx', 'MarkerSize', 10);

title('tolist in X, Time in y');


%order
figure(17);
%plotDataPoints(Z, , K);
plot(X(:,17), y, 'rx', 'MarkerSize', 10);

title('order in X, Time in y');



%project
figure(18);
%plotDataPoints(Z, , K);
plot(X(:,18), y, 'rx', 'MarkerSize', 10);

title('project in X, Time in y');




%distinct
figure(19);
%plotDataPoints(Z, , K);
plot(X(:,19), y, 'rx', 'MarkerSize', 10);

title('distinct in X, Time in y');



%reduced
figure(20);
%plotDataPoints(Z, , K);
plot(X(:,20), y, 'rx', 'MarkerSize', 10);

title('reduced in X, Time in y');


%multi
figure(21);
%plotDataPoints(Z, , K);
plot(X(:,21), y, 'rx', 'MarkerSize', 10);

title('multi in X, Time in y');



%top
figure(22);
%plotDataPoints(Z, , K);
plot(X(:,22), y, 'rx', 'MarkerSize', 10);

title('top in X, Time in y');



%group
figure(23);
%plotDataPoints(Z, , K);
plot(X(:,23), y, 'rx', 'MarkerSize', 10);

title('group in X, Time in y');



%assign
figure(24);
%plotDataPoints(Z, , K);
plot(X(:,24), y, 'rx', 'MarkerSize', 10);

title('assign in X, Time in y');

