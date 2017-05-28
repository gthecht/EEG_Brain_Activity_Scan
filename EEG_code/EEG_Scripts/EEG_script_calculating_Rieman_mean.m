% Gilad & Ronen, 28.5.17
% calculating the Riemannian mean out of a set of cov matrices

clear;
clc;

% data_direct  = inputdlg('Where do you want to take the files from?\n','data directory');        % the place we'll take our data from
% clean_direct = inputdlg('Where do you want to place the clean files?\n','cleanup directory');   % the place we'll save our cleaned data

prompt={'Enter the place you want to take the files from:',...
    'Enter the place you want to place the correlation matrices in:',...
    'Enter code folder:'};
title  = 'Directories';
directories      = inputdlg(prompt,title);

%% Splitting directories

source_direct      = directories{1};
dest_direct     = directories{2};
code_direct      = genpath(directories{3});
                            % adds all subfolders of code to path.
addpath(code_direct)
cellfun(@(x) addpath(x), directories);

%% Cleaning the data and downsampling it

allfiles  = dir(source_direct);
allnames  = {allfiles.name}.';
N = length(allnames);
Riem_mean = Riemann_mean(source_direct,  'cov', 10);
% creating name:
str_split = strsplit(source_direct,'\');
dirac_name  = [str_split{end}];
new_name  = ['Riemannian_mean_of_',upper(dirac_name)];
cd(dest_direct);
save(new_name, 'Riem_mean');

