function [data_cell] = load_SVMdata()
% Helps load data matrices on which we want to use the SVM.
% Asks for directory, and then allows to pick multiple files from there.

% Ask for filename:
prompt={'Enter file path for loading:'};
dir_title  = 'load';
source_cell   = inputdlg(prompt,dir_title);
source_direct    = source_cell{1};
cd(source_direct);
% Taking all files in directory:
all_files = dir(source_direct);
file_names = {all_files.name}.';
% opening list dialogue for picking files:
pick_files  = listdlg('PromptString', 'Select subjects;', 'SelectionMode',...
    'multiple', 'ListString', file_names);
picked_files = file_names(pick_files);
% Loading:
data_cell = cell(length(picked_files),1);
for ii = 1 : length(picked_files)
    data_cell{ii} = load(picked_files{ii});     % loading data_struct
end

% returns data_cell

