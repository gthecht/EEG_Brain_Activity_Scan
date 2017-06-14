%% Gilad & Ronen, mapping using diffusion maps
% Insert the folders of the cov matrices you want to map out, and it
% applies diffusion maps to these matrices.
%% adding the path to the data and to the functions

% example in Gilad's: D:\Project\EEG_Data\Edited_Data\C04\1\cov
prompt={'Enter the cov folder of first'...
        'Enter the cov folder of second'...
        'Enter the cov folder of third'};
dir_title  = 'Directories';
directories = inputdlg(prompt,dir_title);
direct_1   = directories{1};
direct_2   = directories{2};
direct_3   = directories{3};
%%
cellfun(@(x) addpath(x), directories);
labels = diff_maps_title( directories );
%% changeing covs to matrices around common mean.
[cov_mat, dat_lengths] = cov2vec( directories); % the matrix of cov-vectors

%% Now we'll run a diffusion map
Diff_map( cov_mat, dat_lengths, labels);