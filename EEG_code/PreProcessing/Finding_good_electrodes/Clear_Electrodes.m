function [] = Clear_Electrodes( direct, subj_names, stims_vec )
% This function will take the clean data we managed to save earlier and
% then find out whether there are bad electrodes in the data. If there are
% ones who are bad, it will be removed from all data. Finally we will save
% the clear data in a folder called 'good_data'.

%% several constants:
electrodes_num = 68;
eta = 5;
window_len = 31;
threshold = 100;
percent_trial = 0.03;
percent_stim = 0.05;
bad_trial = 0.3;

%% Initializing variables:
N = length(subj_names);
stim_src_str  = [];
stim_dest_str = [];

good_electrodes = 1:electrodes_num; % finding the good electrodes by 
                                    % intersecting this array
                                    
% First loop for pulling out the good electrodes of each trial
for ii = 1:N
    for jj = stims_vec
        stim_src_str  = [direct, '\', subj_names{ii},...
                                        '\Stim_', num2str(jj), '\clean'];
        tmp_good_elec = Classify_Electrodes(stim_src_str, threshold,...
                                      eta, window_len,electrodes_num,...
                                      percent_trial, percent_stim,...
                                      bad_trial);
        good_electrodes = intersect(good_electrodes, tmp_good_elec);
    end
end

bad_electrodes = setdiff(1:electrodes_num, good_electrodes);

% second loop for saving the data of the good electrodes only
disp('    --Saving the data with the good electrodes...');
for ii = 1:N
    for jj = stims_vec
        stim_src_str  = [direct, '\', subj_names{ii},...
                                    '\Stim_', num2str(jj), '\clean'];
        stim_dest_str = [direct, '\', subj_names{ii},...
                                    '\Stim_', num2str(jj), '\good_data'];
        
        allfiles = dir(stim_src_str);
        allnames = {allfiles.name}.';
        M = length(allnames);
        
        good_str   = contains(allnames,'trial');
        for kk=1:M
            if good_str(kk) == 1
                cd(stim_src_str)
                tmp_trial = load(allnames{kk});
                str_split = strsplit(allnames{kk},'_clean');
                new_name  = [str_split{1},'_good_data.mat'];
                field      = fieldnames(tmp_trial);
                tmp_trial  = getfield(tmp_trial, field{1});
                good_data = tmp_trial(good_electrodes, :);
                cd(stim_dest_str);
                save(new_name, 'good_data');
            end
        end
    end
end


mkdir(direct, 'good_elecs');
cd([direct,'\good_elecs']);
save('good_electrodes','good_electrodes');
save('bad_electrodes','bad_electrodes');
end
