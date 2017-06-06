%% Gilad Hecht and Ronen Rahamim, June 5th 2017
% In this script we'll run remove_bad_elec function we created earlier
% to delete the bad electrodes from our data for each stim and each repeat
% of the experiment.

clear;
clc;

%% adding the path to the data and to the functions

prompt={'Enter the place you want to take the clean files from:',...
    'Enter the place of the total good electrodes:',...
    'Enter the place you want to place the files after removing bad electrodes:',...
    'Enter code folder:'};
title  = 'Directories';
directories      = inputdlg(prompt,title);

%% Splitting directories

source_direct         = directories{1};
total_direct          = directories{2};
dest_direct           = directories{3};
code_direct           = genpath(directories{4});
                            % adds all subfolders of code to path.
addpath(code_direct)
cellfun(@(x) addpath(x), directories);
cd (dest_direct)

%% Finding the good and the bad electrodes

allfiles = dir(source_direct);
allnames = {allfiles.name}.';
N = length(allnames);
allfiles_total = dir(total_direct);
allnames_total = {allfiles_total.name}.';
N_total = length(allnames_total);
c = 0;
num_of_electrodes = 68;
good_electrodes = zeros(num_of_electrodes,N-2);    
[row_good, col_good] = size(good_electrodes);

for ii=1:N_total
    good_str = ~isempty(strfind(allnames_total{ii},'total'));
        if good_str == 1
            tmp  = load(allnames_total{ii});
            total_good_electrodes  = tmp.total_good_electrodes;
        end        
end

% Removing the bad electrodes of all repeats
save_it = 1;
for ii=1:N
    good_str = ~isempty(strfind(allnames{ii},'trial'));
        if good_str == 1
            tmp_elec  = load(allnames{ii});
            tmp_elec  = tmp_elec.clean_data;
            str_split = strsplit(allnames{ii},'_');
            new_name  = [str_split{1:end-1},'_remove_bad.mat'];
            remove_bad_elec(tmp_elec, total_good_electrodes, save_it, new_name )
        end        
end



