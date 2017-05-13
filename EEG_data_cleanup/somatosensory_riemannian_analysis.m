%% Gilad & Ronen 29.04.17
%  Compare between the subjects with stim1 and stim2 - the somatosensory signals.
%  delete the bad electrodes first.
%  Using Riemannian metrics
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
size_dat = size(data_Stim_1_C04);
len_dat  = max(size_dat);
%% Delete electrodes 33, 43, 66, 38, 52
good_elect = [1:32, 34:37, 39:42, 44:51, 53:65, 67, 68];
data_Stim_1_C04_good = cell(size_dat);
data_Stim_1_C06_good = cell(size_dat);
data_Stim_1_C08_good = cell(size_dat);

for ii = 1:299
    data_Stim_1_C04_good{ii} = data_Stim_1_C04{ii}(good_elect,:);
    data_Stim_1_C06_good{ii} = data_Stim_1_C06{ii}(good_elect,:);
    data_Stim_1_C08_good{ii} = data_Stim_1_C08{ii}(good_elect,:);
end


%% Covariance between electrodes:
cov_of_rows = @(X) cov(X');
cov_Stim1_C04 = cellfun(cov_of_rows,data_Stim_1_C04_good,'UniformOutput', false);
cov_Stim1_C06 = cellfun(cov_of_rows,data_Stim_1_C04_good,'UniformOutput', false);
cov_Stim1_C08 = cellfun(cov_of_rows,data_Stim_1_C04_good,'UniformOutput', false);

%% Riemannian metrics:
% finding the eigenvals
deltaP04 = cell(1,len_dat);
deltaP0406 = cell(1,len_dat);
deltaP0408 = cell(1,len_dat);
deltaP0608 = cell(1,len_dat);
deltaP06 = cell(1,len_dat);
deltaP08 = cell(1,len_dat);

Riemann_dist = @(X,Y) sqrt(sum((log(eig(inv(X) * Y))).^2));
% Now we calculate the distances:
for ii = 1: len_dat
    deltaP04{1,ii}     = cellfun(Riemann_dist, cov_Stim1_C04, circshift(cov_Stim1_C04,ii-1), 'UniformOutput', false);
    deltaP06{1,ii}     = cellfun(Riemann_dist, cov_Stim1_C06, circshift(cov_Stim1_C06,ii-1), 'UniformOutput', false);
    deltaP08{1,ii}     = cellfun(Riemann_dist, cov_Stim1_C08, circshift(cov_Stim1_C08,ii-1), 'UniformOutput', false);
    
    deltaP0406{1,ii}   = cellfun(Riemann_dist, cov_Stim1_C04, circshift(cov_Stim1_C06,ii-1), 'UniformOutput', false);
    deltaP0408{1,ii}   = cellfun(Riemann_dist, cov_Stim1_C04, circshift(cov_Stim1_C08,ii-1), 'UniformOutput', false);
    deltaP0608{1,ii}   = cellfun(Riemann_dist, cov_Stim1_C06, circshift(cov_Stim1_C08,ii-1), 'UniformOutput', false);
end

%% distance from the mean of 04, 06 and 08:
% we'll load the mean:
load('mean_Stim1_C04.mat');


%% plotting distance between each trial and every other trial:
[meshX,meshY] = meshgrid(1:max(size_dat));
figure(1); surf(meshX, meshY, cell2mat(cellfun(@(X) cell2mat(X),deltaP04,'UniformOutput', false)));
title('deltaP04');

%% Plotting/Scattering the map after diffusion - for all three subjects
color = [zeros(299,1) ; ones(299,1) ; 2 * ones(299,1)];
figure(10)
scatter3(mV04(:,2),mV04(:,3),mV04(:,4), 15, color, 'Fill');
colorbar();
title('Stim_1 for all three subjects');
xlabel('\psi_2');
ylabel('\psi_3');
zlabel('\psi_4');
% view(0,90);

%% Plotting/Scattering the map after diffusion
color = [zeros(299,1) ; ones(299,1) ; 2 * ones(299,1)];
figure(11)
scatter3(mV04(300:end,2),mV04(300:end,3),mV04(300:end,4), 15, color(300:end), 'Fill');
colorbar();
title('Stim_1 only for subjects 6 & 8');
xlabel('\psi_2');
ylabel('\psi_3');
zlabel('\psi_4');
% view(0,90);





