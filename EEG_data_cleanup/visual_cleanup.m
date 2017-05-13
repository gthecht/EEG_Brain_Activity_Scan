%% Gilad & Ronen 29.04.17
%  Clean up the data of stim3 - the visual signal.
%  This code isn't at all nifty. It uses only for-loops to do everything,
%  but that isn't important in this case as it is a one-time run-code and
%  isn't too long.

clear;
clc;
%% loading original signals:
visual_trials = (1:299)';
data_Stim_3_orig = cell(size(visual_trials));

for ii = visual_trials'
    data_Stim_3_str  = sprintf('data_Stim_3_trial%.3d.mat', ii);
    temp_struct      = load(data_Stim_3_str, 'F');
    data_Stim_3_orig{ii} = [temp_struct.F];
end

%% And finally we want to cut off the signal before t=0:
data_Stim_3_cutoff = cell(size(data_Stim_3_orig));
for ii = visual_trials'
    data_Stim_3_cutoff{ii} = data_Stim_3_orig{ii}(:,101:end);
end
% Now we'll save it: (only if you haven't got it already
% save ('Processed_data\data_Stim_3_cutoff_and_downsmpld.mat','data_Stim_3_cutoff');

