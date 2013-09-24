function [ score ] = explained_variance_score( y,y1 )
%http://scikit-learn.org/stable/modules/model_evaluation.html#regression-metrics
%The explained_variance_score computes the explained variance regression score.

score = 1 - var(y-y1)/var(y);


end

