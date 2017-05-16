%% Gilad Hecht and Ronen Rahamim, May 16th 2017
% In this script we'll run the two  functions we created earlier to cut the
% data between the relevant times, and we'll try to delete the bad
% electrodes from our data for each stim and each repeat of the experiment.

clear;
clc;

%% adding the path to the data and to the functions

addpath('C:\Users\Ronen\Documents\BrainStorm\brainstormdb\EEG_data\Project_Sample_Data\data\C04\1') % the whole data of C04 only
addpath('D:\Project1\EEG_code\Prepare_signal')          % where the function "eeg_cleanup" is
% addpath('D:\Project1\EEG_code\Finding_good_electrodes') % where the function "local_std" is

%% Loading the data

somatosensory_trials = (1:299)';                            % number of repeats 
data_Stim_1_orig     = cell(size(somatosensory_trials));    % each row is a repeat from the experiment
data_Stim_1_clean    = cell(size(somatosensory_trials));    % each row will be a clean repeat from the experiment

for ii = somatosensory_trials'
    data_Stim_1_str  = sprintf('data_Stim_1_trial%.3d.mat', ii);
    temp_struct      = load(data_Stim_1_str, 'F');
%     data_Stim_1_clean{ii} = eeg_cleanup([temp_struct.F]);
    data_Stim_1_orig{ii} = [temp_struct.F];
end

%% adding the path to function "eeg_cleanup"

addpath('D:\Project1\EEG_code\Prepare_signal')          % where the function "eeg_cleanup" is

%% Cutting each repeat in the stims

data_Stim_1_clean = cell(size(somatosensory_trials));    % each row will be a clean repeat from the experiment



