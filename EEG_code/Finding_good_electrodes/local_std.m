function [ good_electrodes, bad_electrodes, bad_times_per_elec ] = ...
    local_std( elec_dat, window_len, eta, error_threshold, save_it, show_it, name )
% local_std: checks the relative local std. returns which electrodes are
% good, using the formula: (x-mu)/sig^2 < eta, eta can be chosen, or if
% not, it is 3.

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

%% check if input is correct:
try
    validateattributes(elec_dat, {'double'},{'2d'});
    validateattributes(name, {'char'},{'scalartext','2d'});
    validateattributes(save_it, {'logical','double'},{'scalar'});
    validateattributes(error_threshold, {'double'},{'scalar'});

catch
    err_msg  = ('Error: Input isn''t of right type!');
    err_name = ('Input Error');
    errordlg(err_msg, err_name);
    good_electrodes    = [];
    bad_times_per_elec = [];
    return;
end
% checking eta
if isempty(eta)
    eta = 3;
    disp('using defualt eta := 3');
end
% checking window_len
if isempty(window_len) == 0
    window_len = 31;
    disp('using defualt window length := 31');
end
if mod(window_len,2) == 0
    disp('Error: window length must be odd!');
    disp('adding 1 to the length.');
    disp(['window length = ', num2str(window_len+1)]);
    window_len = window_len + 1;
end
%% calculating local std:

[elec_num, time_len] = size(elec_dat);
ones_window = ones(1,window_len);
std_filted = stdfilt(elec_dat,ones_window);

% finding local median:
med_filted = medfilt2(elec_dat, [1,window_len]);

% finding the 'correlation':
data_corr  = (elec_dat - med_filted) ./ std_filted;
% The places where we diverge from the wanted eta:
bad_places = abs(data_corr) > eta;

%% And now for returning the good electrodes, and writing down the bad ones
%  and the places they are bad in:

% Good electrodes
good_indx  = (sum(bad_places,2) < error_threshold);
good_electrodes = find(good_indx);

%% and info on bad ones
bad_electrodes  = find(~good_indx);
bad_elec_num   = size(bad_electrodes,1);
%  We want to find the time in which we have problems. Therefore, we'll
%  add up the sum of bad_places, and then find the peaks, which will be the
%  problematic times.
bad_conv        = conv2(bad_places(bad_electrodes,:), ones_window,'same');
bad_conv_trans  = bad_conv.'; % we transpose so that when we take the whole 
                             % mat as a vector, we will take it row by row.
if isempty(bad_electrodes)
    bad_times_per_elec = [];
    if save_it == true
        fileID = fopen(['bad_electrodes_dat_of_',name,'.txt'],'w');
        fprintf(fileID, 'No bad electrodes');
        fclose(fileID);
    end
    return;
end
[~,times_peaks] = findpeaks( (bad_conv_trans(:)));

elec_pks   = [floor(times_peaks/time_len)+1, 0.001 * (mod(times_peaks-1,time_len))];  
    % first row is the electrode for the peaks, and second is the index 
    % inside the electrode. Notice that there may be unwanted ones at the edges
bad_times_per_elec         = cell(bad_elec_num,2);

for ii = 1: bad_elec_num
    bad_times_per_elec{ii,2} = elec_pks(elec_pks(:,1) == ii,2);
    bad_times_per_elec{ii,1} = bad_electrodes(ii);
end

%% And finally we'll save the data

bad_elec_tbl = cell2table(bad_times_per_elec, 'VariableNames', ...
                                        {'Electrode', 'Problematic_times'});
% We'll save it only if 'save= true'
if save_it == true
    filename = ['bad_electrodes_dat_of_',name,'.txt'];
    writetable(bad_elec_tbl , filename, 'Delimiter', '\t');
end

%% figures:
if show_it
    bad_corr = data_corr(bad_electrodes,:);
    [meshX, meshY] = meshgrid((1:time_len)/1000, bad_electrodes);
    figure(100); scatter3(meshX(:),meshY(:), abs(bad_corr(:)),50,abs(bad_corr(:)));
    title(['local correlation of bad electrodes of ', name]);
    colorbar;
    xlabel('t(sec)'); ylabel('electrode no.'); zlabel('std value in log_{10}');
    savefig([name,'bad_local_corr']);
end

end
