%% Gilad & Ronen 29.04.17
%  trying to find the bad electrodes
clear;
clc;
%% loading cells of signals:
load('data_Stim_1_C04.mat');
data_Stim_1_C04 = data_Stim_1_cutoff;
load('data_Stim_1_C06.mat');
data_Stim_1_C06 = data_Stim_1_cutoff;
load('data_Stim_1_C08.mat');
data_Stim_1_C08 = data_Stim_1_cutoff;
clear data_Stim_1_cutoff;

somatosensory_trials = (1:length(data_Stim_1_C04))';
%% Now we'll try and see if we can find the bad electrodes:

% we'll look at a few histograms:

% We'll also look at the variance of each electrode:
std04 = zeros(68,length(somatosensory_trials));
std06 = zeros(68,length(somatosensory_trials));
std08 = zeros(68,length(somatosensory_trials));
bad_std04  = cell(size(data_Stim_1_C04));
bad_std06  = cell(size(data_Stim_1_C06));
bad_std08  = cell(size(data_Stim_1_C08));
for ii = somatosensory_trials'
    std04(:,ii)   = std(data_Stim_1_C04{ii},0,2);
    std06(:,ii)   = std(data_Stim_1_C06{ii},0,2);
    std08(:,ii)   = std(data_Stim_1_C08{ii},0,2);
    bad_std04{ii} = find(log10(std04(:,ii))> -3.5);
    bad_std06{ii} = find(log10(std06(:,ii))> -3.5);
    bad_std08{ii} = find(log10(std08(:,ii))> -3.5);
end

% cov_data_1 = cov(data_Stim_1_C04{1}');

%% we'll look for the max values
max_data_1   = max(abs(data_Stim_1_C04{3}(:,30:end)),[],2);

bad_electrodes = zeros(68 , 1);
for ii = somatosensory_trials'
    for jj = somatosensory_trials'
        max_diff = max(data_Stim_1_C04{ii} ...
                                        - data_Stim_1_C04{jj},[],2);
        bad_electrodes = or(bad_electrodes, max_diff > 0.001);
    end
end

bad_elecs = find(bad_electrodes);

%% std on a small window:
std_window = ones(1,31);

std_wind04 = zeros([size(data_Stim_1_C04{1}),length(somatosensory_trials)]);
std_wind06 = zeros([size(data_Stim_1_C04{1}),length(somatosensory_trials)]);
std_wind08 = zeros([size(data_Stim_1_C04{1}),length(somatosensory_trials)]);
bad_loc04  = cell(size(data_Stim_1_C04));
bad_loc06  = cell(size(data_Stim_1_C06));
bad_loc08  = cell(size(data_Stim_1_C08));

for ii = somatosensory_trials'
    std_wind04(:,:,ii)   = stdfilt(data_Stim_1_C04{ii},std_window);
    std_wind06(:,:,ii)   = stdfilt(data_Stim_1_C06{ii},std_window);
    std_wind08(:,:,ii)   = stdfilt(data_Stim_1_C08{ii},std_window);
    bad_loc04{ii}        = find(log10(std_wind04(:,:,ii))>-3.5);
    bad_loc06{ii}        = find(log10(std_wind06(:,:,ii))>-3.5);
    bad_loc08{ii}        = find(log10(std_wind08(:,:,ii))>-3.5);
end
%% figures:
[meshX, meshY] = meshgrid(1:size(std_wind04(:,:,1),2), 1:size(std_wind04(:,:,1),1));
wind04_1 = std_wind04(:,:,1);
wind06_1 = std_wind06(:,:,1);
wind08_1 = std_wind08(:,:,1);
figure(1); scatter3(meshX(:),meshY(:), log10(wind08_1(:)),50,meshX(:));
title('local std of Stim 1');
xlabel('t'); ylabel('electrode'); zlabel('std value');
view([1,0,0]);

figure(2); scatter(1:68, log10(max(wind08_1')));
title('maximum local std of Stim 1 per elctrode');
xlabel('electrode'); ylabel('std value');
% ylim([-7, -1]);


