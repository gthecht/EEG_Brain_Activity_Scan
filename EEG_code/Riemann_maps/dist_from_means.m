function [ dist_vec ] = dist_from_means( cov_mat , mean_cell )
% dist_from_means: returns a vector with the distances from the means in
% the mean_cell

%% Inputs:
%       cov_mat - the covariznce matrix we want to find the distances for
%       mean_cell - the cell that holds the mean covariance matrices.
dist_vec = zeros(size(mean_cell));
dist_vec = cellfun( @(X) Riemann_dist( X, cov_mat ), mean_cell, 'UniformOutput', false);


end

