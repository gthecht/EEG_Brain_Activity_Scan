%% Gilad and Ronen - 28.08.17
%  Using SVM to classify sick/healthy patients from diffusion maps
% This is only good for seperating between sick and healthy, not between
% stims. For that, use the classifier app.
clear; clc;
%% Loading Struct with data from diff_maps script.
% struct look thus:
    % data_struct = struct('subjects', cell2mat(subj_names), 'stimulations', cell2mat(stim_names), ...
    %   'diffusion_matrix', diffusion_matrix, 'PCA_matrix', pca_vec, 'labels', label_vec, 'type_labels', type_label);

% Loading data:
data_cell = load_SVMdata(); 
% this cell contains structs, of different names, each containing the 
% struct named 'data_struct'. This has the description above.

%% Preparing for SVM:
[leftout, sick_indicator, diff_mat, pca_mat, type_vec, stim_num] = ...
                    choose_learning_aspects(data_cell{1}.data_struct);
%% Beginning cells:
n = size(leftout,1);
test_diff_cell  = cell(n,1);
train_diff_cell = cell(n,1);
test_pca_cell   = cell(n,1);
train_pca_cell  = cell(n,1);
% and SVM models:
SVM_diff_type  = cell(n,1);
SVM_diff_sh    = cell(n,1);
SVM_diff_test  = cell(n,1);
confmat_diff   = cell(n,1);
%% Running over all rows:
for ii = 1:n
    [test_diff_cell{ii}, train_diff_cell{ii}, test_pca_cell{ii}, train_pca_cell{ii}] = ...
            prepareSVM( diff_mat, pca_mat, leftout(ii,:), type_vec, stim_num);
    % building SVM models:
    % model according to types - subject-stim, over diff_maps:
    SVM_diff_type{ii}  = fitcecoc(train_diff_cell{ii}(:,1:end-2), train_diff_cell{ii}(:,end-1));
    % model according to sick/healthy, over diff_maps:
    SVM_diff_sh{ii}    = fitclinear(train_diff_cell{ii}(:,1:end-2), train_diff_cell{ii}(:,end));

    % % model according to types - subject-stim, over pca_maps:
    % SVM_pca_type  = fitcecoc(test_pca_cell{ii}(:,1:end-2), test_pca_cell{ii}(:,end-1));
    % % model according to sick/healthy, over pca_maps:
    % SVM_pca_sh    = fitclinear(test_pca_cell{ii}(:,1:end-2), test_pca_cell{ii}(:,end));

    % testing and checking outcome:
    SVM_diff_test{ii} = predict(SVM_diff_sh{ii}, test_diff_cell{ii}(:, 1:end-2));
    confmat_diff{ii}  = confusionmat(SVM_diff_test{ii}, test_diff_cell{ii}(:, end));
end
%% To do next:
% use the app to export training models
% show the decision space - to see why its not good - By coloring the
% space.
% Don't use only linear SVM
% Maybe look on leave one subject out



% NOTE
% fitcsvm trains or cross-validates a support vector machine (SVM) model for two-class (binary) classification on a low- through moderate-dimensional predictor data set. fitcsvm supports mapping the predictor data using kernel functions, and supports SMO, ISDA, or L1 soft-margin minimization via quadratic programming for objective-function minimization.
% To train a linear SVM model for binary classification on a high-dimensional data set, that is, data sets that include many predictor variables, use fitclinear instead.
% For multiclass learning by combining binary SVM models, use error-correcting output codes (ECOC). For more details, see fitcecoc.
% To train an SVM regression model, see fitrsvm for low- through moderate-dimensional predictor data sets, or fitrlinear for high-dimensional data sets.