%% Gilad & Ronen, mapping using PCA, 17.06.17
% Insert the folders of the cov matrices you want to map out, and it
% applies PCA algorithm to these matrices.
clear;
clc;
%% adding the path to the data and to the functions

% example in Gilad's:   D:\Project\EEG_Data\Edited_Data\C04\1\cov
% example save Gilad's: 
% example in Ronen's:   C:\Users\Ronen\Documents\BrainStorm\brainstormdb\EEG_data\Edited_Data\C04\16\cov
% example save Ronen's: C:\Users\Ronen\Documents\BrainStorm\brainstormdb\EEG_data\Edited_Data\cov_mats_in_rows

prompt={'Enter the cov folder of first'...
        'Enter the cov folder of second'...
        'Enter the cov folder of third'};
dir_title  = 'Directories';
directories = inputdlg(prompt,dir_title);
direct_1   = directories{1};
direct_2   = directories{2};
direct_3   = directories{3};

%% add paths and creating labels
cellfun(@(x) addpath(x), directories);
labels = diff_maps_title( directories );

%% changeing covs to matrices around common mean
[cov_mat, dat_lengths] = cov2vec( directories );
                                % the matrix of cov-vectors

%% Now we'll run a diffusion map
coeff = pca(cov_mat);
color = [];
for ii = 1: length(dat_lengths)
    color = [color, ii * ones(1,dat_lengths(ii))];
end
figure(1)
scatter3(coeff(:,1), coeff(:,2), coeff(:,3), 50, color, 'Fill');
xlabel('\psi_1 (coeff 1)');
ylabel('\psi_2 (coeff 2)');
zlabel('\psi_3 (coeff 3)');
tmp_title = ['pca of Stims ',labels{1}(12:end-2),',',labels{2}(12:end-2),',',labels{3}(12:end-2),' of Sbj ',labels{1}(4:6),',',labels{2}(4:6),',',labels{3}(4:6)];
title(tmp_title);


% cd(dest);

%% saving the data
% name = ['Stim_',labels{1}(12:end-2),'_',labels{2}(12:end-2),'_',labels{3}(12:end-2),'_Sbj_',labels{1}(4:6),'_',labels{2}(4:6),'_',labels{3}(4:6)];
% save([name,'_cov_mat'], 'cov_mat');
% save([name,'_eigvec'], 'eigvec');
% save([name,'_color'], 'color');
