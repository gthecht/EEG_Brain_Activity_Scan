function [ subj_names ] = find_subject_names( source_direct)
% Finds the names of subjects within source_directory
all_source_files = dir(source_direct);
subj_names = {all_source_files.name}.';
subj_names = subj_names(contains(subj_names, ["C","S"]));
end

