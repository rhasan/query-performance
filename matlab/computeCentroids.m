function [centroids, newK] = computeCentroids(X, idx, K)
%COMPUTECENTROIDS returs the new centroids by computing the means of the 
%data points assigned to each centroid.
%   centroids = COMPUTECENTROIDS(X, idx, K) returns the new centroids by 
%   computing the means of the data points assigned to each centroid. It is
%   given a dataset X where each row is a single data point, a vector
%   idx of centroid assignments (i.e. each entry in range [1..K]) for each
%   example, and K, the number of centroids. You should return a matrix
%   centroids, where each row of centroids is the mean of the data points
%   assigned to it.
%

% Useful variables
[m n] = size(X);

% You need to return the following variables correctly.
centroids = zeros(K, n);


% ====================== YOUR CODE HERE ======================
% Instructions: Go over every centroid and compute mean of all points that
%               belong to it. Concretely, the row vector centroids(i, :)
%               should contain the mean of the data points assigned to
%               centroid i.
%
% Note: You can use a for-loop over the centroids to compute this.
%
new_k_it = 1;
for k=1:K
    %centroids(k,:) = mean(X(idx(:,1)==k,:));
    cluster_contents = X(idx(:,1)==k,:);
    cluster_size = size(cluster_contents,1);
    if cluster_size > 0
        centroids(new_k_it,:) = mean(cluster_contents);
        new_k_it = new_k_it + 1;
    end


% =============================================================
end

centroids = centroids(1:(new_k_it-1),:);

newK = size(centroids,1);