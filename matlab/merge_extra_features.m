function [ X, Xval, Xtest ] = merge_extra_features(Xo, Xvalo, Xtesto)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

X_extra = csvread('../x_features_extra.txt');
Xval_extra = csvread('../xval_features_extra.txt');
Xtest_extra = csvread('../xtest_features_extra.txt');

X = cat(2, Xo, X_extra);
Xval = cat(2, Xvalo, Xval_extra);
Xtest = cat(2, Xtesto,Xtest_extra);

end

