%% Gilad Hecht and Ronen Rahamim, June 5th 2017
% In this script we'll intersect all the good electrodes of each stim and
% find the relevant electrodes in all stims together

clear;
clc;

%% adding the path to the good electrodes

prompt={'Enter the place you want to take the good electrodes files from:'};
title  = 'Directories';
directories      = inputdlg(prompt,title);

%% Splitting directories

source_direct         = directories{1};
                            % adds all subfolders of code to path.
addpath(source_direct)
cd (source_direct)

%% Finding the good and the bad electrodes

allfiles = dir(source_direct);
allnames = {allfiles.name}.';
N = length(allnames);
c = 0;
num_of_electrodes = 68;
all_good_electrodes = zeros(num_of_electrodes,N-2);    
[row_good, col_good] = size(all_good_electrodes);

for ii=1:N
    good_str = ~isempty(strfind(allnames{ii},'good'));
        if good_str == 1
            c = c + 1;
            tmp_elec  = load(allnames{ii});
            tmp_elec  = tmp_elec.real_good_electrodes;
            size_tmp = length(tmp_elec);
            all_good_electrodes(:, c) = [tmp_elec;zeros(row_good-size_tmp, 1)];
        end        
end

intersect_elec = intersect(all_good_electrodes(:, 1),all_good_electrodes(:, 2));
for jj=3:col_good
    intersect_elec = intersect(intersect_elec,all_good_electrodes(:, jj));
end

total_good_electrodes = intersect_elec(intersect_elec>0);
save('total_good_electrodes_of_C04', 'total_good_electrodes');




