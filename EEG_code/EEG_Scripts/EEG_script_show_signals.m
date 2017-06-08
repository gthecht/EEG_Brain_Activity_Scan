%% Gilad Hecht and Ronen Rahamim, June 6th 2017
% In this script we'll run the plots of the signals like a motion movie

clear;
clc;
%% adding the path to the data and to the functions

<<<<<<< e658425407a98697ae08e7783fe3443972027ee9
prompt={'Enter the place of the data you want to show:'};
title  = 'Directories';
directories      = inputdlg(prompt,title);
=======
prompt     = {'Enter the place of the data you want to show:'};
dir_title  = 'Directories';
directories      = inputdlg(prompt,dir_title);
>>>>>>> 34f02a3a82be01d93aafa99b535023fb9887067f

%% Splitting directories

source_direct         = directories{1};
addpath(source_direct)

%% Finding the good and the bad electrodes

allfiles = dir(source_direct);
allnames = {allfiles.name}.';
N = length(allnames);

for ii=1:N
    good_str = ~isempty(strfind(allnames{ii},'trial'));
        if good_str == 1
            data  = load(allnames{ii});
            field = fieldnames(data);
            show_data =  getfield(data, field{1});
%             show_data  = data.data_good;
            figure(1);
            plot(show_data');
<<<<<<< e658425407a98697ae08e7783fe3443972027ee9
=======
            title(allnames{ii});
>>>>>>> 34f02a3a82be01d93aafa99b535023fb9887067f
            ylabel('Amplitude');
            xlabel('Time');
            pause(0.1);
        end        
end




