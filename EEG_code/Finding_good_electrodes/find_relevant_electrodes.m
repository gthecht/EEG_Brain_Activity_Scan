function [ good_elec ] = find_relevant_electrodes( elec_dat, threshold )
% This function find the good electrodes which do not runs out of the
% median value by "threshold" times of it

med_by_row    = median(elec_dat);
median_of_dat = median(med_by_row);
out_of_bound  = (abs(elec_dat) > threshold * abs(median_of_dat));
bad_elec      = sum(out_of_bound, 2);
good_elec     = find(bad_elec == 0);


end

