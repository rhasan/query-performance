function [ re ] = relative_absolute_error( y, y1 )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%Weka: http://stackoverflow.com/questions/10776673/formula-for-relative-absolute-error-and-root-relative-squared-error-used-in
%Relative absolute error
num = sum(abs(y-y1));
den = sum(abs(mean(y)-y));

if num == 0
    re = 0;
   return; 
end

% if den==0
%     
% end

re = num/den*100;


end

