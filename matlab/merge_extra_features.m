function [ X, Xval, Xtest ] = merge_extra_features(Xo, Xvalo, Xtesto, X_extra, Xval_extra, Xtest_extra)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here



X = cat(2, Xo, X_extra);
Xval = cat(2, Xvalo, Xval_extra);
Xtest = cat(2, Xtesto,Xtest_extra);

end

