function [ good_elec ] = find_relevant_electrodes( elec_dat, threshold, eta )
% This function find the good electrodes which do not runs out of the
% median value by "threshold" times of it

med_by_time   = median(abs(elec_dat));
[row, col]      = size(elec_dat); 
out_of_bound  = (abs(elec_dat) > threshold * abs(repmat(med_by_time,row,1)));
bad_elec      = sum(out_of_bound, 2);

% ones_window = ones(1,window_len);
% 
% local_std_filted = stdfilt(elec_dat,ones_window);
% local_mean_filted = imfilter(elec_dat, ones_window) / window_len;
% local_data_corr  = (elec_dat - local_mean_filted) ./ local_std_filted;
% local_bad_elec = local_data_corr > eta;
% bad_elec = bad_elec + sum(local_bad_elec, 2);

std_all = std(elec_dat,0,1);
mean_all = mean(elec_dat,1);
data_corr_all  = (elec_dat - repmat(mean_all,row,1)) ./ repmat(std_all,row,1);
total_bad_elec = data_corr_all > eta;
bad_elec = bad_elec + sum(total_bad_elec, 2);

good_elec     = find(bad_elec == 0);




end

