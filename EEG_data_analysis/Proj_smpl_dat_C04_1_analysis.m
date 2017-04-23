% Looking at the data of "EEG_data\Project_Sample_Data\data\C04\1"

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

%% Organizing the images
all_scans_cell = [data_Stim_1_cell; data_Stim_2_cell; data_Stim_3_cell];
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
colour        = [ones(299,1); 50 * ones(299,1); 100 * ones(299,1)];
figure(1)
scatter3(mV(:,2),mV(:,3),mV(:,4), 50, colour, 'Fill');
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
scatter3(mV(:,5),mV(:,3),mV(:,4), 5, 1:lCol);
text(mV(:,5)+d, mV(:,3)+d, mV(:,4)+d, labels(:));