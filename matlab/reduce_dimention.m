function [ Z, U, S] = reduce_dimention( X, K )

    %% ========= reduce dimentions of a dataset =========
    %X = csvread('../x_features.txt');
    %y = csvread('../y_time.txt');
    %K = 1;

    %[X_norm, mu, sigma] = featureNormalizeZeroMean(X);

    %  Run PCA
    [U, S] = pca(X);

    Z = projectData(X, U, K);

    %figure(25);
    %plotDataPoints(Z, , K);
    %plot(Z(:,1), y, 'rx', 'MarkerSize', 10);

    %title('Dataset plotted in 2D, using PCA for dimensionality reduction');
    %fprintf('Program paused. Press enter to continue.\n');
    %pause;
end