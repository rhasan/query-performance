function [X_norm] = featureNormalizePredZeroMean(X, mu, sigma, X_mean)
%FEATURENORMALIZE Normalizes the features in X 
%   FEATURENORMALIZE(X) returns a normalized version of X where
%   the mean value of each feature is 0 and the standard deviation
%   is 1. This is often a good preprocessing step to do when
%   working with learning algorithms.

%subtracts mean feature value for each example to avoide divide by zero
%X_mean = mean(X,2);
%X = bsxfun(@plus, X, X_mean);

%X_mean = mean(mean(X,2));
X = X + X_mean;


%mu = mean(X);
X_norm = bsxfun(@minus, X, mu);

%sigma = std(X_norm);
X_norm = bsxfun(@rdivide, X_norm, sigma);


% ============================================================

end
