function [ clean_data ] = eeg_cleanup( data, time, save_it, name )
% eeg_cleanup: Recieves a struct of the type given by the EEG, takes the
% signals, and the time, and cuts it so that the time is from 0 to 0.5.
% Downsamples the data so that the frequency is 1KHz.
% The function also recives a logical 'save_it' which decides whether to
% save the clean data, or not. If it does, it gives names it 'name'.

%% Check if the input data is the right one:
try
    data_F = data.F;
    data_t = data.Time;
catch
    err_msg  = ('Error: Input isn''t of right type. make sure to use struct');
    err_name = ('Input Error');
    errordlg(err_msg, err_name);
    clean_data = 0;
    return;
end
%% now we want to down-sample to 1kHz:
dt         = median(data_t(2:end) - data_t(1:end-1));
dnsmpl     = round(0.001/dt);

dnsmpl_dat = downsample(data_F',dnsmpl)';
dnsmpl_t   = downsample(data_t',dnsmpl)';

%% And finally we want to cut off the signa; before t=0:

clean_data = dnsmpl_dat(:,dnsmpl_t >= time);

% We'll save it only if 'save= true'
if save_it == true
    save(name,'clean_data');     %saves it in the current directory,
                                % or rather, the one written in 'name'
end
end

