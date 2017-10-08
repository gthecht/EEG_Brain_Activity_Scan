function [ tmp_good_elec ] = Classify_Electrodes( stim_src_str, threshold,...
                                                    eta, window_len,...
                                                    percent_trial, percent_stim )
% This function checks what are the good electrodes for each stim when
% based on checking each trial.

counter = 0;            % counts the number of trials in the specific stim.
bad_electrodes = [];
allfiles = dir(stim_src_str);
allnames = {allfiles.name}.';
M = length(allnames);
        
good_str   = contains(allnames,'trial');
        
for kk=1:M
    if good_str(kk) == 1
        counter = counter + 1;
        cd(stim_src_str)
        tmp_trial  = load(allnames{kk});
        field      = fieldnames(tmp_trial);
        tmp_trial  = getfield(tmp_trial, field{1});
        
        [electrodes_num, trial_len] = size(tmp_trial); 
        out_of_bound = (abs(tmp_trial) > threshold);
        tmp_bad_electrodes = sum(out_of_bound, 2);


        ones_window = ones(1,window_len);
        local_std_filted = stdfilt(tmp_trial,ones_window);
        local_mean_filted = imfilter(tmp_trial, ones_window) / window_len;
        local_data_corr  = (tmp_trial - local_mean_filted) ./ local_std_filted;
        local_bad_elec = local_data_corr > eta;
        tmp_bad_electrodes = tmp_bad_electrodes + sum(local_bad_elec, 2);


        std_all = std(tmp_trial,0,1);
        mean_all = mean(tmp_trial,1);
        data_corr_all  = (tmp_trial - repmat(mean_all,electrodes_num,1)) ./ repmat(std_all,electrodes_num,1);
        total_bad_elec = data_corr_all > eta;
        tmp_bad_electrodes = tmp_bad_electrodes + sum(total_bad_elec, 2);

        bad_electrodes = bad_electrodes + (tmp_bad_electrodes >= floor(percent_trial * trial_len));


    end
end

tmp_good_elec = find(bad_electrodes <= floor(percent_stim * counter));

end






% function [ tmp_good_elec ] = Classify_Electrodes( tmp_trial, threshold,...
%                                                     eta, window_len, percent )
% % This function checks what are the good electrodes.
% 
% % med_by_time   = median(abs(tmp_trial));
% [row, col]      = size(tmp_trial); 
% % out_of_bound  = (abs(tmp_trial) > threshold * repmat(med_by_time,row,1));
% % bad_elec      = sum(out_of_bound, 2);
% out_of_bound  = (abs(tmp_trial) > threshold);
% bad_elec      = sum(out_of_bound, 2);
% 
% 
% ones_window = ones(1,window_len);
% local_std_filted = stdfilt(tmp_trial,ones_window);
% local_mean_filted = imfilter(tmp_trial, ones_window) / window_len;
% local_data_corr  = (tmp_trial - local_mean_filted) ./ local_std_filted;
% local_bad_elec = local_data_corr > eta;
% bad_elec = bad_elec + sum(local_bad_elec, 2);
% % bad_elec = sum(local_bad_elec, 2);
% 
% 
% std_all = std(tmp_trial,0,1);
% mean_all = mean(tmp_trial,1);
% data_corr_all  = (tmp_trial - repmat(mean_all,row,1)) ./ repmat(std_all,row,1);
% total_bad_elec = data_corr_all > eta;
% bad_elec = bad_elec + sum(total_bad_elec, 2);
% 
% bad_elec = bad_elec >= floor(percent * col);
% 
% tmp_good_elec   = find(bad_elec == 0);
% 
% end

