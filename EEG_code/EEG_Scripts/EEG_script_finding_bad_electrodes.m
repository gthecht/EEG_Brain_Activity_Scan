%% Gilad Hecht and Ronen Rahamim, May 16th 2017
% In this script we'll run find_good_electrodes function we created earlier
% to delete the bad electrodes from our data for each stim and each repeat
% of the experiment.

clear;
clc;

%% adding the path to the data and to the functions

prompt={'Enter the place you want to take the clean files from:',...
    'Enter the place you want to place the bad electrodes files:',...
    'Enter code folder:'};
title  = 'Directories';
directories      = inputdlg(prompt,title);

%% Splitting directories

clean_data_direct         = directories{1};
bad_electrodes_direct     = directories{2};
code_direct      = genpath(directories{3});
                            % adds all subfolders of code to path.
addpath(code_direct)
cellfun(@(x) addpath(x), directories);
cd (bad_electrodes_direct)

%% Finding the good and the bad electrodes

allfiles = dir(clean_data_direct);
allnames = {allfiles.name}.';
N = length(allnames);
window_len = 31;
eta = 3;
error_threshold = 3;
save_it = 1;
show_it = 1;
for ii=1:N
    good_str = ~isempty(strfind(allnames{ii},'trial'));
        if good_str == 1
            tmp_elec  = load(allnames{ii});
            tmp_elec  = tmp_elec.clean_data;
            str_split = strsplit(allnames{ii},'_');
            new_name  = [str_split{1:end-1}];
            find_good_electrodes(tmp_elec, window_len, eta, error_threshold, save_it, show_it, new_name );
%           eeg_cleanup(tmp_trial, 1, new_name );
        end        
end


