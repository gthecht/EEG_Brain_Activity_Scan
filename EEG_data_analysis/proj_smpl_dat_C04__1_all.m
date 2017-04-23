% Looking at the data of "EEG_data\Project_Sample_Data\data\C04\1"
% This time we look at ALL the data together:

clear;
close all;
clc;

%% loading trial 1 scans into one cell:
somatosensory_trials = (1:299)';
data_Stim_1_cell = cell(size(somatosensory_trials));

for ii = somatosensory_trials'
    data_Stim_1_str  = sprintf('data_Stim_1_trial%.3d.mat', ii);
    temp_struct      = load(data_Stim_1_str, 'F');
    data_Stim_1_cell{ii} = [temp_struct.F];
end

%% likewise for trial 2 and 3:
data_Stim_2_cell = cell(size(somatosensory_trials));

for ii = somatosensory_trials'
    data_Stim_2_str  = sprintf('data_Stim_2_trial%.3d.mat', ii);
    temp_struct      = load(data_Stim_2_str, 'F');
    data_Stim_2_cell{ii} = [temp_struct.F];
end

data_Stim_3_cell = cell(size(somatosensory_trials));

for ii = somatosensory_trials'
    data_Stim_3_str  = sprintf('data_Stim_3_trial%.3d.mat', ii);
    temp_struct      = load(data_Stim_1_str, 'F');
    data_Stim_3_cell{ii} = [temp_struct.F];
end

%% For trials of type 11 - 16:
load 'data_length.mat';
% Creating the cells for all the audio tests:
data_Aud_cell   = {cell(data_length(4),1); cell(data_length(5),1); ...
                   cell(data_length(6),1); cell(data_length(7),1); ...
                   cell(data_length(8),1); cell(data_length(9),1)};
              
for ii = 11:16
    for jj = 1: data_length(ii - 7)
        data_str      = sprintf('data_Stim_%d_trial%.3d_02.mat', ii, jj);
        temp_struct      = load(data_str, 'F');
        data_Aud_cell{ii - 10}{jj} = [temp_struct.F];
    end
end
%% Organizing the images
all_scans_cell = [data_Stim_1_cell; data_Stim_2_cell; data_Stim_3_cell; ...
                  data_Aud_cell{1}; data_Aud_cell{2}; data_Aud_cell{3}; ...
                  data_Aud_cell{4};data_Aud_cell{5};data_Aud_cell{6}];
images_in_cols = reshape(vertcat(all_scans_cell{:}),[],length(all_scans_cell));
[lRow, lCol]     = size(images_in_cols);

%% Finding eigenvalues and vectors

% Calculating the Kernel for each dimension in the images
norm_squared = squareform(pdist(images_in_cols'));
eps          = median(norm_squared(:));
mK           = exp(-norm_squared.^2/eps^2);

% Calculating the diagonal matrix D
mD = diag( sum(mK, 2) );
% mD           = zeros(size(mK));
% for ii=1:size(mK)
%    mD(ii,ii) = sum(mK(ii,:),2);
% end;

% Calculating A, it's eigenvalues and eigenvectors for the diffusion
mA            = mD \ mK;
[mV , mE]     = eig(mA);

%% Plotting/Scattering the map after diffusion
figure(1)
scatter3(mV(:,2),mV(:,3),mV(:,4), 50, 1:lCol, 'Fill');
colorbar();
%view(90,0);
xlabel('\psi_2');
ylabel('\psi_3');
zlabel('\psi_4');


%% we'll also scatter it with the labels of each angle, to see if we can
%  find any connection.

labels = cell(size(all_scans_cell));
for ii = somatosensory_trials' 
	labels{ii} = sprintf('1');
    labels{ii + length(somatosensory_trials)}   = sprintf('2');
    labels{ii + 2*length(somatosensory_trials)} = sprintf('3');
end

d = 0.000;

figure(2)
scatter3(mV(:,2),mV(:,3),mV(:,4), 5, 1:lCol);
text(mV(:,2)+d, mV(:,3)+d, mV(:,4)+d, labels(:));