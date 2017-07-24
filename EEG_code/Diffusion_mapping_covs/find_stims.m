function [ stims ] = find_stims( src_dir, subjs )
% given the directory containing subjects ('edited_EEG_data'), and the
% subjects we use, gives back all the Stims that at least one subjects has.

l = length(subjs);
stims = [];
for ii = 1:l
    subj_dir = [src_dir, '\', subjs{ii}];
    cd(subj_dir)
    % Finds the stims of the subject
    all_source_files = dir(subj_dir);
    stims_temp = {all_source_files.name}.';
    stims_temp = stims_temp(contains(stims_temp, ["Stim"]));
    % join to known stims
    stims = union(stims,stims_temp);
end
end

