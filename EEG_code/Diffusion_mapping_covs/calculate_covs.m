function [] = calculate_covs( edited_EEG_data_dir, stims_vec )
% calculating the cov matrices of the signals for subjects in
% "edited_EEG_data_dir".
% Stims is a cell with the names of the stims

subj_names = find_subject_names( edited_EEG_data_dir);
N          = length(subj_names);
subj_dir   = [];
for ii = 1:N
    subj_dir = [edited_EEG_data_dir,'\',subj_names{ii}];
    cellfun(@(X) covs_of_stims(X, subj_dir), stims_vec);
    disp(['finished for subject', subj_names{ii}]);
end
end

