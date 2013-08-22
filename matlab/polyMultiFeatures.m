function [X_poly] = polyMultiFeatures(X, p)
    
n = size(X,2);

%X_poly(:,1) = X;
X_poly = polyFeatures(X(:,1), p);
for i = 2:n
    %X_poly(:,i) = X.^i;
    X_poly = [X_poly polyFeatures(X(:,i), p)];
end



end