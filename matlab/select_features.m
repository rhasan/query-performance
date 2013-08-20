function [ X, Xval, Xtest] = select_features( selected_features, Xo, Xvalo, Xtesto )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    X = Xo(:,selected_features);
    Xval = Xvalo(:,selected_features);
    Xtest = Xtesto(:,selected_features);


end

