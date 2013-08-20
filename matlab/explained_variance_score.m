function [ score ] = explained_variance_score( y,y1 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

score = 1 - var(y-y1)/var(y);


end

