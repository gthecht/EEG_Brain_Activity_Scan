function [test_diff_mat, train_diff_mat, test_pca_mat, train_pca_mat] = ...
    prepareSVM( diff_mat, pca_mat, leaveout, type_vec, stim_num)
% From the data - build training and testing matrices, with sick/healthy 
% labels, or by stim-subject. Leave out subjects for testing.
%% create train and test matrices
test_diff_mat  = diff_mat( ismember(ceil(type_vec/stim_num), leaveout),:);
train_diff_mat = diff_mat(~ismember(ceil(type_vec/stim_num), leaveout),:);
test_pca_mat   = pca_mat( ismember(ceil(type_vec/stim_num), leaveout),:);
train_pca_mat  = pca_mat(~ismember(ceil(type_vec/stim_num), leaveout),:);
end

