%% Gilad & Ronen 29.04.17
%  Clean up the data of stim1 and stim2 - the somatosensory signals.
%  This code isn't at all nifty. It uses only for-loops to do everything,
%  but that isn't important in this case as it is a one-time run-code and
%  isn't too long.

clear;
clc;
%% loading original signals:
somatosensory_trials = (1:299)';
data_Stim_1_orig = cell(size(somatosensory_trials));

for ii = somatosensory_trials'
    data_Stim_1_str  = sprintf('data_Stim_1_trial%.3d.mat', ii);
    temp_struct      = load(data_Stim_1_str, 'F');
    data_Stim_1_orig{ii} = [temp_struct.F];
end

data_Stim_2_orig = cell(size(somatosensory_trials));

for ii = somatosensory_trials'
    data_Stim_2_str  = sprintf('data_Stim_2_trial%.3d.mat', ii);
    temp_struct      = load(data_Stim_2_str, 'F');
    data_Stim_2_orig{ii} = [temp_struct.F];
end

%% now we want to down-sample to 1kHz:
data_Stim_1_downsmpl = cell(size(data_Stim_1_orig));
data_Stim_2_downsmpl = cell(size(data_Stim_2_orig));
for ii = somatosensory_trials'
    data_Stim_1_downsmpl{ii} = downsample(data_Stim_1_orig{ii}',5)';
    data_Stim_2_downsmpl{ii} = downsample(data_Stim_2_orig{ii}',5)';
end

%% And finally we want to cut off the signa; before t=0:
data_Stim_1_cutoff = cell(size(data_Stim_1_orig));
data_Stim_2_cutoff = cell(size(data_Stim_2_orig));
for ii = somatosensory_trials'
    data_Stim_1_cutoff{ii} = data_Stim_1_downsmpl{ii}(:,101:end);
    data_Stim_2_cutoff{ii} = data_Stim_2_downsmpl{ii}(:,101:end);
end
% Now we'll save it: (only if you haven't got it already
% save ('Processed_data\data_Stim_1_cutoff_and_downsmpld.mat','data_Stim_1_cutoff');

%% Now we'll try and see if we can find the bad electrodes:

% we'll look at a few histograms:

% We'll also look at the variance of each electrode:
var_data_1   = var(data_Stim_1_cutoff{1},0,2);
cov_data_1 = cov(data_Stim_1_cutoff{1}');

max_data_1   = max(abs(data_Stim_1_cutoff{3}(:,30:end)),[],2);

bad_electrodes = zeros(68 , 1);
for ii = somatosensory_trials'
    for jj = somatosensory_trials'
        max_diff = max(data_Stim_1_cutoff{ii} ...
                                        - data_Stim_1_cutoff{jj},[],2);
        bad_electrodes = or(bad_electrodes, max_diff > 0.01);
    end
end

bad_elecs = find(bad_electrodes)










