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
% we'll load the mean:
load('mean_Stim1_C04.mat');
load('mean_Stim1_C06.mat');
load('mean_Stim1_C08.mat');

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
cov_Stim1_C06 = cellfun(cov_of_rows,data_Stim_1_C06_good,'UniformOutput', false);
cov_Stim1_C08 = cellfun(cov_of_rows,data_Stim_1_C08_good,'UniformOutput', false);

%% Riemannian metrics:
% finding the eigenvals
deltaP04   = zeros(len_dat,len_dat);
deltaP06   = zeros(len_dat,len_dat);
deltaP08   = zeros(len_dat,len_dat);
deltaP0406 = zeros(len_dat,len_dat);
deltaP0408 = zeros(len_dat,len_dat);
deltaP0608 = zeros(len_dat,len_dat);


Riemann_dist = @(X,Y) sqrt(sum((log(eig(inv(X) * Y))).^2));
for ii = 1:max(size_dat)
    deltaP04(:,ii)     = cell2mat(cellfun(Riemann_dist, cov_Stim1_C04, circshift(cov_Stim1_C04,-ii+1), 'UniformOutput', false));
    deltaP06(:,ii)     = cell2mat(cellfun(Riemann_dist, cov_Stim1_C06, circshift(cov_Stim1_C06,-ii+1), 'UniformOutput', false));
    deltaP08(:,ii)     = cell2mat(cellfun(Riemann_dist, cov_Stim1_C08, circshift(cov_Stim1_C08,-ii+1), 'UniformOutput', false));
    
    deltaP0406(:,ii)   = cell2mat(cellfun(Riemann_dist, cov_Stim1_C04, circshift(cov_Stim1_C06,-ii+1), 'UniformOutput', false));
    deltaP0408(:,ii)   = cell2mat(cellfun(Riemann_dist, cov_Stim1_C04, circshift(cov_Stim1_C08,-ii+1), 'UniformOutput', false));
    deltaP0608(:,ii)   = cell2mat(cellfun(Riemann_dist, cov_Stim1_C06, circshift(cov_Stim1_C08,-ii+1), 'UniformOutput', false));
end

%% reordering the matrices so that they look nice
delta_M04   = zeros(len_dat);
delta_M06   = zeros(len_dat);
delta_M08   = zeros(len_dat);
delta_M0406 = zeros(len_dat);
delta_M0408 = zeros(len_dat);
delta_M0608 = zeros(len_dat);

for ii = 1:len_dat      %rows
    for jj = 1:len_dat  %cols
        delta_M04(mod(ii + jj-1 -1,len_dat)+1, ii)   = deltaP04(ii,jj);
        delta_M06(mod(ii + jj-1 -1,len_dat)+1, ii)   = deltaP06(ii,jj);
        delta_M08(mod(ii + jj-1 -1,len_dat)+1, ii)   = deltaP08(ii,jj);
        delta_M0406(mod(ii + jj-1 -1,len_dat)+1, ii) = deltaP0406(ii,jj);
        delta_M0408(mod(ii + jj-1 -1,len_dat)+1, ii) = deltaP0408(ii,jj);
        delta_M0608(mod(ii + jj-1 -1,len_dat)+1, ii) = deltaP0608(ii,jj);
    end
end

%% distance from the mean of 04, 06 and 08:
% picking good electrodes:
mean4_good = mean_Stim1_C04(good_elect);
mean6_good = mean_Stim1_C06(good_elect);
mean8_good = mean_Stim1_C08(good_elect);
%finding the cov:
cov_mean4 = cov_of_rows(mean4_good);
cov_mean6 = cov_of_rows(mean6_good);
cov_mean8 = cov_of_rows(mean8_good);
% initializing delta
delta_from_mean4 = zeros(len_dat,3);
delta_from_mean6 = zeros(len_dat,3);
delta_from_mean8 = zeros(len_dat,3);

for ii = 1:len_dat
    delta_from_mean4(ii,1) = Riemann_dist(cell2mat(cov_Stim1_C04(ii)), cov_mean4);
    delta_from_mean4(ii,2) = Riemann_dist(cell2mat(cov_Stim1_C06(ii)), cov_mean4);
    delta_from_mean4(ii,3) = Riemann_dist(cell2mat(cov_Stim1_C08(ii)), cov_mean4);
    
    delta_from_mean6(ii,1) = Riemann_dist(cell2mat(cov_Stim1_C04(ii)), cov_mean6);
    delta_from_mean6(ii,2) = Riemann_dist(cell2mat(cov_Stim1_C06(ii)), cov_mean6);
    delta_from_mean6(ii,3) = Riemann_dist(cell2mat(cov_Stim1_C08(ii)), cov_mean6);
    
    delta_from_mean8(ii,1) = Riemann_dist(cell2mat(cov_Stim1_C04(ii)), cov_mean8);
    delta_from_mean8(ii,1) = Riemann_dist(cell2mat(cov_Stim1_C06(ii)), cov_mean8);
    delta_from_mean8(ii,1) = Riemann_dist(cell2mat(cov_Stim1_C08(ii)), cov_mean8);
end

% and now we scatter:
colors = ([0,1,2] .* ones(len_dat,1));
figure(50);
scatter3(delta_from_mean4(:), delta_from_mean6(:), delta_from_mean8(:), 36, colors(:));
title('distances from the means of each person'); colorbar;
xlabel('dist from 04'); ylabel('dist from 06'); zlabel('dist from 08');

%% plotting distance between each trial and every other trial:
[meshX,meshY] = meshgrid(1:max(size_dat));
figure(1); surf(meshX, meshY, real(delta_M04));
title('delta_M04');
colorbar; view(0,90);
figure(2); surf(meshX, meshY, real(delta_M06));
title('delta_M06');
colorbar; view(0,90);
figure(3); surf(meshX, meshY, real(delta_M08));
title('delta_M08');
colorbar; view(0,90);
figure(4); surf(meshX, meshY, real(delta_M0406));
title('delta_M0406');
colorbar; view(0,90);
figure(5); surf(meshX, meshY, real(delta_M0408));
title('delta_M0408');
colorbar; view(0,90);
figure(6); surf(meshX, meshY, real(delta_M0608));
title('delta_M0608');
colorbar; view(0,90);
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





