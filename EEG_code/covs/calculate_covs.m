function [] = calculate_covs( edited_EEG_data, stims_vec )
% calculating the cov matrices of the signals for subjects in
% "edited_EEG_data_dir".
% Stims is a cell with the names of the stims
stims_cell = num2cell(stims_vec);
subj_names = find_subject_names( edited_EEG_data);
N          = length(subj_names);
subj_dir   = [];
for ii = 1:N
    subj_dir = [edited_EEG_data,'\',subj_names{ii}];
    cellfun(@(X) covs_of_stims(X, subj_dir), stims_cell);
    disp(['finished for subject', subj_names{ii}]);
end
end

