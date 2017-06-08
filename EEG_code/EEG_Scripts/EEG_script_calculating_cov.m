% Gilad & Ronen, 28.5.17
% calculating the cov matrices of the signals

clear;
clc;

% data_direct  = inputdlg('Where do you want to take the files from?\n','data directory');        % the place we'll take our data from
% clean_direct = inputdlg('Where do you want to place the clean files?\n','cleanup directory');   % the place we'll save our cleaned data

prompt={'Enter the place you want to take the files from:',...
    'Enter the place you want to place the correlation matrices in:'};
title  = 'Directories';
directories      = inputdlg(prompt,title);

%% Splitting directories

source_direct      = directories{1};
dest_direct     = directories{2};

cellfun(@(x) addpath(x), directories);
cd(dest_direct);
%% Cleaning the data and downsampling it

allfiles = dir(source_direct);
allnames = {allfiles.name}.';
N = length(allnames);
for ii=1:N
    good_str = ~isempty(strfind(allnames{ii},'trial'));
    if good_str == 1
        tmp_trial   = load(allnames{ii});
        str_split   = strsplit(allnames{ii},'_');
        new_name    = [str_split{1}, '_cov.mat'];
        tmp_row_cov = cov_of_rows(tmp_trial.data_good);
        save(new_name,'tmp_row_cov');
    end
        
end

beep; pause(0.3); beep;