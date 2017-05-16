%% Gilad Hecht and Ronen Rahamim, May 16th 2017
% In this script we'll run the eeg_cleanup function we created earlier to 
% cut the data between the relevant times.

clear;
clc;

%% adding the path to the data and to the functions

% data_direct  = inputdlg('Where do you want to take the files from?\n','data directory');        % the place we'll take our data from
% clean_direct = inputdlg('Where do you want to place the clean files?\n','cleanup directory');   % the place we'll save our cleaned data

prompt={'Enter the place you want to take the files from:',...
    'Enter the place you want to place the clean files:',...
    'Enter the place you want to take EEG_cleanup function from:'};
title  = 'Directories';
directories      = inputdlg(prompt,title);

%% Splitting directories

data_direct      = directories{1};
clean_direct     = directories{2};
cleanfunc_direct = directories{3};

cellfun(@(x) addpath(x), directories);
cd (clean_direct)
%% Cleaning the data and downsampling it

allfiles = dir(data_direct);
allnames = {allfiles.name}.';
N = length(allnames);
for ii=1:N
    good_str = ~isempty(strfind(allnames{ii},'trial'));
    if good_str == 1
        tmp_trial = load(allnames{ii});
        str_split = strsplit(allnames{ii},'.');
        new_name  = [str_split{1}, '_clean.mat'];
        eeg_cleanup(tmp_trial, 1, new_name );
    end
        
end



