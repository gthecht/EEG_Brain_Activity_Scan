%% Gilad Hecht and Ronen Rahamim, June 6th 2017
% In this script we'll run the plots of the signals like a motion movie

clear;
clc;
%% adding the path to the data and to the functions

prompt={'Enter the place of the data you want to show:'};
title  = 'Directories';
directories      = inputdlg(prompt,title);

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
            ylabel('Amplitude');
            xlabel('Time');
            pause(0.1);
        end        
end




