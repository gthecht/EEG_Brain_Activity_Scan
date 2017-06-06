%% Gilad Hecht and Ronen Rahamim, June 6th 2017
% In this script we'll cut each Stim to the same length because there are
% some Stims in which their data length's difference is one.

clear;
clc;
%% adding the path to the data and to the functions

prompt={'Enter the place of the data you want to cut:'};
title  = 'Directories';
directories      = inputdlg(prompt,title);

%% Splitting directories

source_direct         = directories{1};
addpath(source_direct)
cd (source_direct)

%% Finding the good and the bad electrodes

allfiles = dir(source_direct);
allnames = {allfiles.name}.';
N = length(allnames);
min = 2000;
flag = 0;
flag_out = 0;

for ii=1:N
    good_str = ~isempty(strfind(allnames{ii},'trial'));
        if good_str == 1
            data  = load(allnames{ii});
            field = fieldnames(data);
            tmp_data =  getfield(data, field{1});
            data_len = length(tmp_data);
            if (data_len < min)
                min = data_len;
                flag = flag + 1;
            end
            if (or(and(flag ~= 0, data_len > min), flag == 2))
                flag_out = 1;
                break;
            end
        end
    if (flag_out == 1)
        break;
    end
end

for ii=1:N
    good_str = ~isempty(strfind(allnames{ii},'trial'));
        if good_str == 1
            data  = load(allnames{ii});
            field = fieldnames(data);
            tmp_data =  getfield(data, field{1});
            name  = allnames{ii};
            data_good = tmp_data(:,1:min);
            save(name, 'data_good');
        end        
end

beep

