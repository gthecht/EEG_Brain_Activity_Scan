% Gilad & Ronen, 28.5.17
% calculating the cov matrices of the signals

clear;
clc;

% data_direct  = inputdlg('Where do you want to take the files from?\n','data directory');        % the place we'll take our data from
% clean_direct = inputdlg('Where do you want to place the clean files?\n','cleanup directory');   % the place we'll save our cleaned data

prompt={'Enter "edited_EEG_data" directory:'};
title  = 'Directories';
directories      = inputdlg(prompt,title);

%% Splitting directories

edited_EEG_data  = directories{1};
stims_vec        = {1; 2; 3; 11; 12; 13; 14; 15; 16};

%% Making the covs:
calculate_covs( edited_EEG_data_dir, stims_vec );
beep; pause(0.3); beep;