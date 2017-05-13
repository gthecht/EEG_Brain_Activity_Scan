%% Gilad & Ronen 29.04.17
%  Clean up the data of stim11 - the auditory signal of Frequent tone.
%  This code isn't at all nifty. It uses only for-loops to do everything,
%  but that isn't important in this case as it is a one-time run-code and
%  isn't too long.

clear;
clc;
addpath('C:\Users\Ronen\Documents\BrainStorm\brainstormdb\EEG_data\Project_Sample_Data\data\C04\1') 
%% loading original signals:
visual_trials = (1:480)';
data_Stim_11_orig = cell(size(visual_trials));

for ii = visual_trials'
    data_Stim_11_str  = sprintf('data_Stim_11_trial%.3d_02.mat', ii);
    temp_struct      = load(data_Stim_11_str, 'F');
    data_Stim_11_orig{ii} = [temp_struct.F];
end

%% And finally we want to cut off the signal before t=0:
data_Stim_11_cutoff = cell(size(data_Stim_11_orig));
for ii = visual_trials'
    data_Stim_11_cutoff{ii} = data_Stim_11_orig{ii}(:,101:end);
end
% Now we'll save it: (only if you haven't got it already
% save ('Processed_data\data_Stim_11_cutoff.mat','data_Stim_11_cutoff');

