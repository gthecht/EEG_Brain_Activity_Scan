%% Gilad and Ronen - 28.08.17
%  Using SVM to classify sick/healthy patients from diffusion maps
clear; clc;
%% Loading Struct with data from diff_maps script.
% struct look thus:
    % data_struct = struct('subjects', cell2mat(subj_names), 'stimulations', cell2mat(stim_names), ...
    %     'diffusion_matrix', diffusion_matrix, 'labels', label_vec);

% Ask for filename:
prompt={'Enter filename (and path) for loading:'};
dir_title  = 'load';
filename_cell   = inputdlg(prompt,dir_title);
filename    = filename_cell{1};
load(filename);     % loading data_struct

%% Preparing for SVM:
prompt={'How many dimensions do you want? (enter number)'};
dir_title   = 'SVM dimensions';
dim_cell    = inputdlg(prompt, dir_title);
dim         = str2double(dim_cell{1});
feature_mat = data_struct.diffusion_matrix(:,2:dim+1);
label_vec   = data_struct.type_labels;
% label_vec   = data_struct.labels;
SVM_mat     = [feature_mat, label_vec];
%% building SVM model:
n    = length(label_vec);
k    = floor(0.9 * n);
perm = randperm(n).';
perm_feats  = feature_mat(perm(1:k),:);
perm_labels = label_vec(perm(1:k));
linear_svm  = fitclinear(perm_feats, perm_labels);
%% testing and checking outcome
% Xval_svm      = crossval(linear_svm);
[test_label, test_score] = predict(linear_svm, feature_mat(perm(k+1: end),:));
success_ratio = sum(test_label == label_vec(perm(k+1: end))) / (n-k);


% NOTE
% fitcsvm trains or cross-validates a support vector machine (SVM) model for two-class (binary) classification on a low- through moderate-dimensional predictor data set. fitcsvm supports mapping the predictor data using kernel functions, and supports SMO, ISDA, or L1 soft-margin minimization via quadratic programming for objective-function minimization.
% To train a linear SVM model for binary classification on a high-dimensional data set, that is, data sets that include many predictor variables, use fitclinear instead.
% For multiclass learning by combining binary SVM models, use error-correcting output codes (ECOC). For more details, see fitcecoc.
% To train an SVM regression model, see fitrsvm for low- through moderate-dimensional predictor data sets, or fitrlinear for high-dimensional data sets.