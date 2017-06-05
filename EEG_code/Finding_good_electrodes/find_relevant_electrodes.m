function [ good_elec ] = find_relevant_electrodes( elec_dat, threshold )
% This function find the good electrodes which do not runs out of the
% median value by "threshold" times of it

med_by_time   = median(abs(elec_dat));
[row, ~]      = size(elec_dat); 
% median_of_dat = median(med_by_time);
out_of_bound  = (abs(elec_dat) > threshold * abs(repmat(med_by_time,row,1)));
bad_elec      = sum(out_of_bound, 2);
good_elec     = find(bad_elec == 0);


end

