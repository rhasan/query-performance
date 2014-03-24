function [ cof ] = cor_coef( a, p )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

mean_p = mean(p);
mean_a = mean(a);
n = length(a);

Spa = sum((p-mean_p).*(a-mean_a))/(n-1);

Sp = sum((p-mean_p).*(p-mean_p))/(n-1);

Sa = sum((a-mean_a).*(a-mean_a))/(n-1);


cof = Spa / sqrt(Sp*Sa);

% 
% x = p-mean_p
% y = a-mean_a
% 
% Spa = sum(x.*y)/(n-1)
%  
% Sp = sum(x.*x)/(n-1)
%  
% Sa = sum(y.*y)/(n-1)
% 
% cof = Spa / sqrt(Sp*Sa);




end
