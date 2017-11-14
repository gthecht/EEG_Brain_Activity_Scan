function [leftout, sick_indicator, diff_mat, pca_mat, type_vec, stim_num] = ...
    choose_learning_aspects(data_struct)
% Choose number of dimensions to learn on, and also how many subjects to
% leave out each time.
% Also makes a matrix of which the rows are the subjects to be left out each
% time, by taking all the different options of leaving the sick people out,
% and adding random healthy people.

%% Build feature matrix (with labels at the end - both the sick/healthy
% label, and the type label:
diff_features = data_struct.diffusion_matrix(:,2:1001);
pca_features  = data_struct.PCA_matrix(:,1:200);
type_vec   = data_struct.type_labels';
sick_vec   = data_struct.labels';
diff_mat   = [diff_features, type_vec, sick_vec'];
pca_mat    = [ pca_features, type_vec, sick_vec'];
%% leave out sick and healthy subjects for testing
sick_indicator       = contains(num2cell(data_struct.subjects(:,1)), 'S');  % indicator for sick subjects
% prompt     = {'number of sick to leave out:'; 'number of healthy to leave out:'};
% dir_title  = 'Leave out';
% leave_cell = inputdlg(prompt, dir_title);
s_out      = 1; % str2double(leave_cell{1});
h_out      = 1; % str2double(leave_cell{2});

s_index    = find(sick_indicator);
h_index    = find(~sick_indicator);
% pick the ones left out:
s_leftout = nchoosek(s_index, s_out);
h_leftout = zeros(size(s_leftout,1), h_out);
for ii = 1:size(s_leftout, 1)
    h_leftout(ii, :) = h_index(randperm(numel(h_index), h_out));
end

leftout  = [s_leftout, h_leftout];
stim_num = size(data_struct.stimulations,1);
end