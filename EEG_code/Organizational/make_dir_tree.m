function [dir_stack] = make_dir_tree( root_dir, subjects, stims_vec)
% makes directory tree, for all the subjects within the root directory
cd(root_dir);
mkdir('edited_EEG_data');
cd('edited_EEG_data');
N         = length(subjects);

name_str  = [];
dir_stack = cell(N, length(stims_vec));
for ii = 1:N
    name_str = subjects{ii};
    if strlength(name_str) == 2
        name_str = insertBefore(name_str, 2, "0");
    end
    mkdir(name_str);
    for jj = stims_vec
        numstr = num2str(jj);
        if length(numstr) == 1
            numstr = ['0',numstr];
        end
        stim_str = [name_str, '\Stim_', numstr];
        dir_stack{ii,find(stims_vec == jj)} = [root_dir, '\edited_EEG_data\' stim_str];
        mkdir(name_str , ['Stim_', numstr]);
        mkdir(stim_str , 'clean');      % clean data with bad electrodes
        mkdir(stim_str , 'good_data');  % data with only good electrodes
        mkdir(stim_str , 'cov');        % cov matrices
        mkdir(stim_str , 'distances');  % distances from means
    end
end
        

end

