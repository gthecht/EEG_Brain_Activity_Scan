function [ dist_vec ] = dist_from_typical_mats( cov_mat , typic_cell )
% dist_from_means: returns a vector with the distances from the typical matrices in
% the typic_cell

% Inputs:
%       cov_mat - the covariznce matrix we want to find the distances for
%       mean_cell - the cell that holds the mean covariance matrices.

% Output:
%       dist_vec - distance from all the typical matrices
%% Code:
dist_cell = cellfun( @(X) Riemann_dist( X, cov_mat ), typic_cell, 'UniformOutput', false);
dist_vec = cell2mat(dist_cell);
end

