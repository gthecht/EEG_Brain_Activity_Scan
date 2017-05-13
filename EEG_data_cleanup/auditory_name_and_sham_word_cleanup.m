%% Gilad & Ronen 29.04.17
%  Clean up the data of stim14 and stim16 - the auditory signal of own name
%  and sham word.
%  This code isn't at all nifty. It uses only for-loops to do everything,
%  but that isn't important in this case as it is a one-time run-code and
%  isn't too long.

clear;
clc;
addpath('C:\Users\Ronen\Documents\BrainStorm\brainstormdb\EEG_data\Project_Sample_Data\data\C04\1') 
%% loading original signals:
visual_trials = (1:124)';
data_Stim_14_orig = cell(size(visual_trials));
data_Stim_16_orig = cell(size(visual_trials));

for ii = visual_trials'
    data_Stim_14_str  = sprintf('data_Stim_14_trial%.3d_02.mat', ii);
    temp_struct      = load(data_Stim_14_str, 'F');
    data_Stim_14_orig{ii} = [temp_struct.F];
end

for ii = visual_trials'
    data_Stim_16_str  = sprintf('data_Stim_16_trial%.3d_02.mat', ii);
    temp_struct      = load(data_Stim_16_str, 'F');
    data_Stim_16_orig{ii} = [temp_struct.F];
end

%% And finally we want to cut off the signal before t=0:
data_Stim_14_cutoff = cell(size(data_Stim_14_orig));
data_Stim_16_cutoff = cell(size(data_Stim_16_orig));
for ii = visual_trials'
    data_Stim_14_cutoff{ii} = data_Stim_14_orig{ii}(:,101:end);
    data_Stim_16_cutoff{ii} = data_Stim_16_orig{ii}(:,101:end);
end
% Now we'll save it: (only if you haven't got it already
% save ('Processed_data\data_Stim_14_cutoff.mat','data_Stim_14_cutoff');
% save ('Processed_data\data_Stim_16_cutoff.mat','data_Stim_16_cutoff');

