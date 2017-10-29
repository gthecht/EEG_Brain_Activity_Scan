%% Gilad & Ronen, mapping using diffusion maps
% Insert the folders of the cov matrices you want to map out, and it
% applies diffusion maps to these matrices.
clear;
clc;
%% entering the 'edited_EEG_data' directory

% example in Gilad's:   E:\Gilad\Psagot\Technion\Semester6\Project1\EEG_data_files\EEG_data_edited\edited_EEG_data
% example in Ronen's:   C:\Users\Ronen\Documents\BrainStorm\brainstormdb\EEG_data\Edited_Data\C04\16\cov
% example save Ronen's: C:\Users\Ronen\Documents\BrainStorm\brainstormdb\EEG_data\Edited_Data\cov_mats_in_rows

prompt={'Enter data directory'};
dir_title  = 'data';
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
stim_names = stims(pick_stims);

%% Adding trials from chosen subjects and stims into cells
tic
data_cell   = cell(length(pick_stims), length(pick_subj));   % cell that will hold all cov mats of every stim and subject
legend_cell = data_cell;    % holds the names of the stims and subjs
legend_str  = zeros(length(pick_subj) * length(pick_stims), 1);     % the legend size - will plug in subject and stim later
label       = zeros(length(pick_subj) * length(pick_stims), 1);      % the label for the SVM - sick = 1, healthy = 0
for ind_subj = 1:length(pick_subj)
    for ind_stim = 1:length(pick_stims)
        % Gives a label of sick/not sick (1=sick):
        label((ind_subj-1) * length(pick_stims) + ind_stim) = contains(subjs{pick_subj(ind_subj)}, "S");
        
        % finding cov directory of temporary subject-stim:
        temp_dir    = [src_dir, '\', subjs{pick_subj(ind_subj)}, '\',...
                                          stims{pick_stims(ind_stim)}, '\cov'];
        cd(temp_dir);   % moving to cov directory for current subject and stimulation
        temp_files  = dir(temp_dir);
        temp_names  = {temp_files.name}.';
        temp_trials = temp_names(contains(temp_names, 'trial')); % all trials
        load_struct = cellfun(@(X) load(X, 'tmp_row_cov'), temp_trials);
        data_cell{ind_stim,ind_subj}   = struct2cell(load_struct).';    % loading into cell
        legend_cell{ind_stim,ind_subj} = [subjs{pick_subj(ind_subj)}, ' - ', stims{pick_stims(ind_stim)}];  % updating legend
%         legend_str(ind_subj*ind_stim, 1) = [subjs{pick_subj(ind_subj)}, ' - ', stims{pick_stims(ind_stim)}];
    end
end

disp('    --finished loading all trials');
toc
%% changing covs to matrices around common mean
[cov_mat, dat_lengths] = cov2vec( data_cell, []);
                                % the matrix of cov-vectors

label_vec = [];
for ii = 1: length(dat_lengths(:))
    label_vec = [label_vec; label(ii) * ones(dat_lengths(ii),1)];
end

disp('    --found Riemanien mean');
toc

%% Running PCA on the Riemannian vectors
[PCA_matrix, type_label] = PCA_map( cov_mat, dat_lengths, legend_cell, label);
%% Now we'll run a diffusion map
[ diffusion_matrix, diffusion_eig_vals, type_label ] = Diff_map( cov_mat, dat_lengths, legend_cell, label);
disp('    --wrote down diffusion maps');
toc
%% saving the data
data_struct = struct('subjects', cell2mat(subj_names), 'stimulations', cell2mat(stim_names), ...
    'diffusion_matrix', diffusion_matrix, 'labels', label_vec, 'type_labels', type_label);

prompt={'Enter save destination directory:', 'Choose filename:'};
dir_title  = 'save';
dest_cell   = inputdlg(prompt,dir_title);
dest_dir    = dest_cell{1};
filename    = [dest_cell{2},'.mat'];
cd(dest_dir);
save(filename, 'data_struct');
% name = ['Stim_',labels{1}(12:end-2),'_',labels{2}(12:end-2),'_',labels{3}(12:end-2),'_Sbj_',labels{1}(4:6),'_',labels{2}(4:6),'_',labels{3}(4:6)];
% save([name,'_cov_mat'], 'cov_mat');
% save([name,'_eigvec'], 'eigvec');
% save([name,'_color'], 'color');
