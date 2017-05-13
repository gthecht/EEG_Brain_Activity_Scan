%% Gilad & Ronen 29.04.17
%  Clean up the data of stim13 and 15 - the auditory signal of sham words.
%  This code isn't at all nifty. It uses only for-loops to do everything,
%  but that isn't important in this case as it is a one-time run-code and
%  isn't too long.

clear;
clc;
addpath('C:\Users\Ronen\Documents\BrainStorm\brainstormdb\EEG_data\Project_Sample_Data\data\C04\1') 
%% loading original signals:
visual_trials = (1:476)';
data_Stim_13_orig = cell(size(visual_trials));
data_Stim_15_orig = cell(size(visual_trials));

for ii = visual_trials'
    data_Stim_13_str  = sprintf('data_Stim_13_trial%.3d_02.mat', ii);
    temp_struct      = load(data_Stim_13_str, 'F');
    data_Stim_13_orig{ii} = [temp_struct.F];
end

for ii = visual_trials'
    data_Stim_15_str  = sprintf('data_Stim_13_trial%.3d_02.mat', ii);
    temp_struct      = load(data_Stim_15_str, 'F');
    data_Stim_15_orig{ii} = [temp_struct.F];
end

%% And finally we want to cut off the signal before t=0:
data_Stim_13_cutoff = cell(size(data_Stim_13_orig));
data_Stim_15_cutoff = cell(size(data_Stim_15_orig));
for ii = visual_trials'
    data_Stim_13_cutoff{ii} = data_Stim_13_orig{ii}(:,101:end);
    data_Stim_15_cutoff{ii} = data_Stim_15_orig{ii}(:,101:end);
end
% Now we'll save it: (only if you haven't got it already
% save ('Processed_data\data_Stim_13_cutoff.mat','data_Stim_13_cutoff');
% save ('Processed_data\data_Stim_15_cutoff.mat','data_Stim_15_cutoff');

