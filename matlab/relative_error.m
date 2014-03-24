function [ re ] = relative_error( y, y1 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%http://en.wikipedia.org/wiki/Mean_absolute_percentage_error
abs_re_error = abs((y-y1)./y);
 
re = sum(abs_re_error)/length(y);

end

