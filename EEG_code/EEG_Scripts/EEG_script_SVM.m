%% Gilad and Ronen - 28.08.17
%  Using SVM to classify sick/healthy patients from diffusion maps
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
% Pick number of dimensions:
prompt={'How many dimensions do you want? (enter number)'};
dir_title   = 'SVM dimensions';
dim_cell    = inputdlg(prompt, dir_title);
dim         = str2double(dim_cell{1});

% Build feature matrix (with labels at the end - both the sick/healthy
% label, and the type label:
diff_features = data_struct.diffusion_matrix(:,2:dim+1);
pca_features  = data_struct.pca_vec(:,1:dim);
type_vec   = data_struct.type_labels;
sick_vec   = data_struct.labels;
diff_mat   = [diff_features, type_vec', sick_vec'];
pca_mat    = [pca_features, type_vec', sick_vec'];
% leave out sick and healthy subjects for testing

%% building SVM model:
n    = length(type_vec);
k    = floor(0.9 * n);
perm = randperm(n).';
perm_feats  = diff_features(perm(1:k),:);
perm_labels = type_vec(perm(1:k));
linear_svm  = fitclinear(perm_feats, perm_labels);
%% testing and checking outcome
% Xval_svm      = crossval(linear_svm);
[test_label, test_score] = predict(linear_svm, diff_features(perm(k+1: end),:));
success_ratio = sum(test_label == type_vec(perm(k+1: end))) / (n-k);


% NOTE
% fitcsvm trains or cross-validates a support vector machine (SVM) model for two-class (binary) classification on a low- through moderate-dimensional predictor data set. fitcsvm supports mapping the predictor data using kernel functions, and supports SMO, ISDA, or L1 soft-margin minimization via quadratic programming for objective-function minimization.
% To train a linear SVM model for binary classification on a high-dimensional data set, that is, data sets that include many predictor variables, use fitclinear instead.
% For multiclass learning by combining binary SVM models, use error-correcting output codes (ECOC). For more details, see fitcecoc.
% To train an SVM regression model, see fitrsvm for low- through moderate-dimensional predictor data sets, or fitrlinear for high-dimensional data sets.