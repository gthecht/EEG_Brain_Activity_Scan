function [ good_electrodes , bad_electrodes] = total_std( elec_dat, eta, error_threshold )
%Calculates the std of the whole signal, and returns the electrodes that
% have a corr beneath eta Summary of this function goes here

%%  Input variables:
% % elec_dat:   data of all electrodes, in time. Taken to be sampled at 
%               1kHz, and beginning at t=0.
% % eta         double - deviation threshold above we we sign it as a bad spot.

%% check if input is correct:
try
    validateattributes(elec_dat, {'double'},{'2d'});
    validateattributes(error_threshold, {'double'},{'scalar'});
catch
    err_msg  = ('Error: Input isn''t of right type!');
    err_name = ('Input Error');
    errordlg(err_msg, err_name);
    good_electrodes    = [];
    return;
end
% checking eta
if size(eta,1) == 0
    eta = 3;
    disp('using defualt eta := 3');
end

%% calculating std:
[elec_num, time_len] = size(elec_dat);
std_all = std(elec_dat,0,2);
median_all = repmat(median(abs(elec_dat),1), elec_num, 1);
% % % med_all = median(elec_dat,2);
mean_all = mean(elec_dat,2);
% finding the 'correlation':
% % % data_corr  = (elec_dat - repmat(med_all,1,size(elec_dat,2))) ./ repmat(std_all,1,size(elec_dat,2));
data_corr  = (elec_dat - repmat(mean_all,1,size(elec_dat,2))) ./ repmat(std_all,1,size(elec_dat,2));
% The places where we diverge from the wanted eta:
bad_places = abs(data_corr) > eta;

bad_by_median = abs(elec_dat) > 150*median_all;
local_bad_elec = sum(and(bad_by_median,bad_places), 2);
good_electrodes = find(local_bad_elec == 0);
bad_electrodes = find(local_bad_elec > 0);
% % % % Good electrodes
% % % good_indx       = (sum(bad_places,2) < error_threshold);
% % % good_electrodes = find(good_indx);
% % % bad_electrodes  = find(~good_indx);
end

