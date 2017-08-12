%% Gilad & Ronen, mapping using diffusion maps
% Insert the folders of the cov matrices you want to map out, and it
% applies diffusion maps to these matrices.
clear;
clc;
%% entering the 'edited_EEG_data' directory

% example in Gilad's:   D:\Project\EEG_Data\Edited_Data\C04\1\cov
% example in Ronen's:   C:\Users\Ronen\Documents\BrainStorm\brainstormdb\EEG_data\Edited_Data\C04\16\cov
% example save Ronen's: C:\Users\Ronen\Documents\BrainStorm\brainstormdb\EEG_data\Edited_Data\cov_mats_in_rows

prompt={'Enter data directory'};
dir_title  = 'Directories';
src_cell   = inputdlg(prompt,dir_title);
src_dir    = src_cell{1};
cd(src_dir);

%% choosing subjects
subjs      = find_subject_names(src_dir);
pick_subj  = listdlg('PromptString', 'Select subjects;', 'SelectionMode',...
    'multiple', 'ListString', subjs);
subj_names = subjs(pick_subj);

%% choosing stims
stims      = find_stims( src_dir, subj_names );
pick_stims = listdlg('PromptString', 'Select stimulations;', 'SelectionMode',...
    'multiple', 'ListString', stims);

%% Adding trials from chosen subjects and stims into cells
data_cell   = cell(length(pick_stims), length(pick_subj));   % cell that will hold all cov mats of every stim and subject
legend_cell = data_cell;    % holds the names of the stims and subjs
legend_str  = zeros(length(pick_subj) * length(pick_stims), 1);
for ind_subj = 1:length(pick_subj)
    for ind_stim = 1:length(pick_stims)
        temp_dir    = [src_dir, '\', subjs{pick_subj(ind_subj)}, '\',...
                                          stims{pick_stims(ind_stim)}, '\cov'];
        cd(temp_dir);
        temp_files  = dir(temp_dir);
        temp_names  = {temp_files.name}.';
        temp_trials = temp_names(contains(temp_names, 'trial'));
        load_struct = cellfun(@(X) load(X, 'tmp_row_cov'), temp_trials);
        data_cell{ind_stim,ind_subj}   = struct2cell(load_struct).';
        legend_cell{ind_stim,ind_subj} = [subjs{pick_subj(ind_subj)}, ' - ', stims{pick_stims(ind_stim)}];
%         legend_str(ind_subj*ind_stim, 1) = [subjs{pick_subj(ind_subj)}, ' - ', stims{pick_stims(ind_stim)}];
    end
end


%% changeing covs to matrices around common mean
[cov_mat, dat_lengths] = cov2vec( data_cell, []);
                                % the matrix of cov-vectors
%% Now we'll run a diffusion map
[ eigvec, color ] = Diff_map( cov_mat, dat_lengths, legend_cell);

%% saving the data
% name = ['Stim_',labels{1}(12:end-2),'_',labels{2}(12:end-2),'_',labels{3}(12:end-2),'_Sbj_',labels{1}(4:6),'_',labels{2}(4:6),'_',labels{3}(4:6)];
% save([name,'_cov_mat'], 'cov_mat');
% save([name,'_eigvec'], 'eigvec');
% save([name,'_color'], 'color');
