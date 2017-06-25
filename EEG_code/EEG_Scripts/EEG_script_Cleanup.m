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
prompt={'Enter the subject''s original directory',...
        'Enter edited data destination:'};
title  = 'Directories';
directories      = inputdlg(prompt,title);

%% Splitting directories
source_direct = directories{1};
dest_direct   = directories{2};
                            % adds all subfolders of code to path.
cellfun(@(x) addpath(x), directories);
cd(dest_direct);

%% Making directory tree
subj_names = find_subj_names( source_direct );
make_dir_tree( dest_direct, subj_names );
edited_EEG_data_dir = [dest_direct, '\edited_EEG_data'];
%% Cleaning the data and downsampling it
disp('Cleaning and downsampling data...');

Clean_Stims( source_direct, dest_direct, subj_names );
%% Clearing out the bad electrodes
num_of_electrodes = 68;
eta = 5;
window_len = 31;
threshold = 100;
percent = 0.01;
disp('Clearing out the bad electrodes...');
tic
[good_electrodes, bad_electrodes] = Clear_Electrodes( edited_EEG_data_dir,...
                        subj_names, num_of_electrodes, threshold,...
                        eta, window_len, percent );
toc
% for ii=1:20
%     beep;
%     pause(0.5);
% end
%% cov matrices:
disp('Calculating cov matrices...');
tic

calculate_covs( edited_EEG_data_dir)

toc

