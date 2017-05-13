%% Gilad & Ronen 29.04.17
%  Compare between the subjects using stim1 and stim2 - the somatosensory signals.
%  delete the bad electrodes first.
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


%% Delete electrodes 33, 43, 66, 38, 52
good_elect = [1:32, 34:37, 39:42, 44:51, 53:65, 67, 68];
data_Stim_1_C04_good = cell(299,1);
data_Stim_1_C06_good = cell(299,1);
data_Stim_1_C08_good = cell(299,1);

for ii = 1:299
    data_Stim_1_C04_good{ii} = data_Stim_1_C04{ii}(good_elect,:);
    data_Stim_1_C06_good{ii} = data_Stim_1_C06{ii}(good_elect,:);
    data_Stim_1_C08_good{ii} = data_Stim_1_C08{ii}(good_elect,:);
end


%% From diffusion maps:
images_in_cols = zeros(63*501,299*3);
for ii=1:299
    images_in_cols(:,          ii)  = data_Stim_1_C04_good{ii}(:);
    images_in_cols(:,299     + ii)  = data_Stim_1_C06_good{ii}(:);
    images_in_cols(:,299 * 2 + ii)  = data_Stim_1_C08_good{ii}(:);
end
%images_in_cols  = reshape(vertcat(images_cell{:}),[],72);
[lRow, lCol]    = size(images_in_cols);

%% The Code

% Calculating the Kernel for each dimention in the images
norm_squared = squareform(pdist(images_in_cols'));
eps          = median(norm_squared(:));
mK           = exp(-(norm_squared.^2)/(2*eps^2));

% Calculating the diagonal matrix D
mD = diag( sum(mK, 2) );
% mD           = zeros(size(mK));
% for ii=1:size(mK)
%    mD(ii,ii) = sum(mK(ii,:),2);
% end;

% Calculating A, it's eigenvalues and eigenvectors for the diffusion
mA            = mD \ mK;
[mV , mE]     = eig(mA);



%% Plotting/Scattering the map after diffusion - for all three subjects
color = [zeros(299,1) ; ones(299,1) ; 2 * ones(299,1)];
figure(10)
scatter3(mV(:,2),mV(:,3),mV(:,4), 15, color, 'Fill');
colorbar();
title('Stim_1 for all three subjects');
xlabel('\psi_2');
ylabel('\psi_3');
zlabel('\psi_4');
% view(0,90);

%% Plotting/Scattering the map after diffusion
color = [zeros(299,1) ; ones(299,1) ; 2 * ones(299,1)];
figure(11)
scatter3(mV(300:end,2),mV(300:end,3),mV(300:end,4), 15, color(300:end), 'Fill');
colorbar();
title('Stim_1 only for subjects 6 & 8');
xlabel('\psi_2');
ylabel('\psi_3');
zlabel('\psi_4');
% view(0,90);





