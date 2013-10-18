function [ rs ] = r_square( y, y1 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
SSresid = sum((y-y1).^2);
%y_mean = mean(y);
%SEmean = sum((y-y_mean).^2);
SStotal = (length(y)-1) * var(y);
rs = 1 - SSresid/SStotal;

end

