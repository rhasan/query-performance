function [C, nu] = getSVRParams(X, y, Xval, yval)
% returns your choice of C and nu for SVR
% uses -t 2 -- radial basis function: exp(-gamma*|u-v|^2)
% You need to return the following variables correctly.
C = 1;
nu = 0.3;

% ====================== YOUR CODE HERE ======================
% Instructions: Fill in this function to return the optimal C and sigma
%               learning parameters found using the cross validation set.
%               You can use svmPredict to predict the labels on the cross
%               validation set. For example, 
%                   predictions = svmPredict(model, Xval);
%               will return the predictions on the cross validation set.
%
%  Note: You can compute the prediction error using 
%        mean(double(predictions ~= yval))
%


C_vec = [0.01 0.03 0.1 0.3 1 3 10 30]';
nu_vec = [0.01 0.03 0.1 0.3 1]';

min_error = Inf;
for i = 1:length(C_vec)
    C_try = C_vec(i);
    for j = 1:length(nu_vec)
        nu_try = nu_vec(j);
        % Train the SVM
        %model= svmTrain(X, y, C_try, @(x1, x2) gaussianKernel(x1, x2, sigma_try));
        
        %options = sprintf('-c %1.3f -n %1.3f',C_try,nu_try);
        
        %model = svmtrain(y, X, options);
        model = svmtrain(y,X,['-s 4 -t 2 -n ' num2str(nu_try) ' -c ' num2str(C_try)]);
        
        %predictions = svmPredict(model, Xval);
        [yval_pred,acc,pro] = svmpredict(yval, Xval, model);
        error = mean((yval_pred - yval).^2);
        if min_error>error
            min_error = error;
            C = C_try;
            nu = nu_try;
        end
        %fprintf('C=%f nu=%f error=%f acc=%f pro=%f\n',C_try,nu_try,error,acc,pro);
        fprintf('C=%f nu=%f error=%f \n',C_try,nu_try,error);
    end
end
fprintf('C=%f nu=%f\n',C,nu);


%C = 3;
%sigma = 30;

% =========================================================================

end