function make_dir_tree( root_dir, subjects )
% makes directory tree, for all the subjects within the root directory
cd(root_dir);
mkdir('edited_EEG_data');
cd('edited_EEG_data');
N         = length(subjects);
stims_vec = [1 2 3 11 12 13 14 15 16];
name_str  = [];
for ii = 1:N
    name_str = subjects{ii};
    mkdir(name_str);
    for jj = stims_vec
        stim_str = [name_str, '\Stim_', num2str(jj)];
        mkdir(name_str , ['Stim_', num2str(jj)]);
        mkdir(stim_str , 'clean');      % clean data with bad electrodes
        mkdir(stim_str , 'good_data');  % data with only good electrodes
        mkdir(stim_str , 'cov');        % cov matrices
        mkdir(stim_str , 'distances');  % distances from means
    end
end
        

end

