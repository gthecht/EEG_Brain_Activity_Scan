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
source_direct      = directories{1};
dest_direct     = directories{2};
                            % adds all subfolders of code to path.
cellfun(@(x) addpath(x), directories);
cd(dest_direct);

%% making directory tree:
all_source_files = dir(source_direct);
subj_names = {all_source_files.name}.';
subj_names = subj_names(contains(subj_names, ["C","S"]));
make_dir_tree( dest_direct, subj_names );
%% Cleaning the data and downsampling it
Clean_Stims( source_direct, dest_direct, subj_names );


















