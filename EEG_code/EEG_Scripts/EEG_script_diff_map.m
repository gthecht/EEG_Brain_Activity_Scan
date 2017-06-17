%% Gilad & Ronen, mapping using diffusion maps
% Insert the folders of the cov matrices you want to map out, and it
% applies diffusion maps to these matrices.
clear;
clc;
%% adding the path to the data and to the functions

% example in Gilad's:   D:\Project\EEG_Data\Edited_Data\C04\1\cov
% example save Gilad's: 
% example in Ronen's:   C:\Users\Ronen\Documents\BrainStorm\brainstormdb\EEG_data\Edited_Data\C04\16\cov
% example save Ronen's: C:\Users\Ronen\Documents\BrainStorm\brainstormdb\EEG_data\Edited_Data\cov_mats_in_rows

prompt={'Enter the cov folder of first'...
        'Enter the cov folder of second'...
        'Enter the cov folder of third'...
        'Enter the folder you want to save the data in'};
dir_title  = 'Directories';
directories = inputdlg(prompt,dir_title);
direct_1   = directories{1};
direct_2   = directories{2};
direct_3   = directories{3};
dest       = directories{4};

%% add paths and creating labels
cellfun(@(x) addpath(x), directories);
labels = diff_maps_title( directories(1:3) );

%% changeing covs to matrices around common mean
[cov_mat, dat_lengths] = cov2vec( directories(1:3));
                                % the matrix of cov-vectors

%% Now we'll run a diffusion map
[ eigvec, color ] = Diff_map( cov_mat, dat_lengths, labels);
cd(dest);

%% saving the data
name = ['Stim_',labels{1}(12:end-2),'_',labels{2}(12:end-2),'_',labels{3}(12:end-2),'_Sbj_',labels{1}(4:6),'_',labels{2}(4:6),'_',labels{3}(4:6)];
save([name,'_cov_mat'], 'cov_mat');
save([name,'_eigvec'], 'eigvec');
save([name,'_color'], 'color');
