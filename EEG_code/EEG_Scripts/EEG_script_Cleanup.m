%% Gilad Hecht and Ronen Rahamim, June 18th 2017
% EEG_script_Cleanup
% Runs cleanup for a subject, over all stimulations, given that they are
% ordered in the standard manner.
% Downsampples to 1KHz and cuts from t=0 to end.
% For the somatosensory takes from t=0.07sec.

% Organizes everything in edited_data directory.

clear;
clc;

%% get directories:
prompt={'Enter the original data directory',...
        'Enter edited data destination:'};
title  = 'Directories';
directories      = inputdlg(prompt,title);

%% Splitting directories
source_direct = directories{1};
dest_direct   = directories{2};
cellfun(@(x) addpath(x), directories);
cd(dest_direct);

%% Initializing directories and stims:
% Stims are:
stims_vec = [1 2 3 11 12 13 14 15 16];
% Making directory tree
subj_names = find_subject_names( source_direct );
make_dir_tree( dest_direct, subj_names, stims_vec );
% edited_EEG_data path:
edited_EEG_data = [dest_direct, '\edited_EEG_data'];

%% Cleaning the data and downsampling it
disp('    --Cleaning and downsampling data...');
Clean_Stims( source_direct, edited_EEG_data, subj_names, stims_vec );

%% Clearing out the bad electrodes
disp('    --Clearing out the bad electrodes...');
tic
Clear_Electrodes( edited_EEG_data, subj_names, stims_vec );
toc

%% cov matrices:
disp('    --Calculating cov matrices...');
tic
calculate_covs( edited_EEG_data, stims_vec)
toc

disp('    --Done!!');

