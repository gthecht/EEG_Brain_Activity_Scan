function [ subj_names ] = find_subj_names( source_direct )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

all_source_files = dir(source_direct);
subj_names = {all_source_files.name}.';
subj_names = subj_names(contains(subj_names, ["C","S"]));
end

