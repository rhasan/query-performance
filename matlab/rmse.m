function [ rms ] = rmse( data,estimate )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

rms = sqrt(sum((data(:)-estimate(:)).^2)/numel(data));
end

