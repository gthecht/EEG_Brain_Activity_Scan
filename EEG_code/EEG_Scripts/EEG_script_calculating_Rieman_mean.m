% Gilad & Ronen, 28.5.17
% calculating the Riemannian mean out of a set of cov matrices

clear;
clc;

% data_direct  = inputdlg('Where do you want to take the files from?\n','data directory');        % the place we'll take our data from
% clean_direct = inputdlg('Where do you want to place the clean files?\n','cleanup directory');   % the place we'll save our cleaned data

prompt={'Enter the place you want to take the files from:'};
title  = 'Directories';
directories      = inputdlg(prompt,title);

%% Splitting directories

source_direct      = directories{1};
cellfun(@(x) addpath(x), directories);

%% Cleaning the data and downsampling it

allfiles  = dir(source_direct);
allnames  = {allfiles.name}.';
N = length(allnames);
Riem_mean = Riemann_mean(source_direct,  'cov', 100);
% creating name:
str_split = strsplit(source_direct,'\');
dirac_name  = [str_split{end}];
new_name  = ['Riemannian_mean_of_',upper(dirac_name),'_',str_split{end-2},'_',str_split{end-1}];
cd(source_direct);
mkdir('mean');
cd('mean');
save(new_name, 'Riem_mean');

beep; pause(0.5); beep;