function [good_both, good_electrodes_dat, bad_electrodes, bad_times_per_elec] = ...
    find_good_electrodes(elec_dat, window_len, eta, error_threshold, ...
                                                   save_it, show_it, name )
% Finds and returns the data of the good electrodes, as well as a list of
% the bad ones.

%%  Input variables:
% % elec_dat:   data of all electrodes, in time. Taken to be sampled at 
%               1kHz, and beginning at t=0.
% % window_len: scalar double -  length of window in which we take the std
%               and the median.
% % eta         double - deviation threshold above we we sign it as a bad spot.
% % allowed_error: double - number of bad spots we allow per electrode.
% % save_it:    boolian - whether to save it or not
% % name:       string - name in which we'll save it.
% % good_electrodes: list of good electrodes.
% %  bad_electrodes: list of bad electrodes.
% % bad_times_per_elec: returns the bad areas 

%% local std:
[good_loc, bad_loc, bad_times_per_elec] = ...
    local_std( elec_dat, window_len, eta, error_threshold, save_it, show_it, name );

%% total std:
[good_all, bad_all] = total_std( elec_dat, eta, error_threshold );

%% joining together:
good_both = intersect(good_loc, good_all);
good_electrodes_dat = elec_dat(good_both,:);
% bad:
because_loc = zeros(size(elec_dat,1),1);
because_all = zeros(size(elec_dat,1),1);
because_loc(bad_loc) = 1;
because_all(bad_all) = 1;
because_bad          = because_loc + because_all;

bad_electrodes      = table(because_bad, because_loc, because_all, ...
    'VariableNames', {'Bad_Electrodes', 'Bad_from_Local_Std', 'Bad_from_Total_Std'});

end

