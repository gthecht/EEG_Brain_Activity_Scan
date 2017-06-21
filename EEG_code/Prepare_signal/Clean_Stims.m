function [ output_args ] = Clean_Stims( source_direct, dest_direct, subj_names )
% Recieves the Source and destination cirectories, and the subject names,
% and cleans out the data, saving it in the appropriate direc. in the
% destination. Also downsamples and cuts in special manner for
% somatosensory.

%% Regular cleanup:
N         = length(subj_names);
stims_vec = [1 2 3 11 12 13 14 15 16];
stim_src_str  = [];
stim_dest_str = [];
% Loading the band pass filter:
load('BPF.mat');
for ii = 1:N
    for jj = stims_vec
        stim_src_str  = [source_direct, '\', subj_names{ii}, '\Stim_', num2str(jj)];
        stim_dest_str = [dest_direct, '\edited_EEG_data\', subj_names{ii}, '\Stim_', ...
                                                num2str(jj), '\clean'];
        % Cleaning the data and downsampling it

        allfiles = dir(stim_src_str);
        allnames = {allfiles.name}.';
        M = length(allnames);
        % beginning time:
        if jj < 3
            time_begin = 0.07;
        else
            time_begin = 0;
        end
        
        good_str   = contains(allnames,'trial');
        for kk=1:M
            if good_str(kk) == 1
                cd(stim_src_str)
                tmp_trial   = load(allnames{kk});
                % Convolute the data with the BPF:
                tmp_trial.F = conv2(tmp_trial.F, BPF', 'same');
                str_split   = strsplit(allnames{kk},'.');
                if contains(str_split{1}, '_cutstim')   % for new data names
                    str_split = strsplit(allnames{kk},'_cutstim');
                elseif contains(str_split{1}, '_ditrend')   % for new data names
                    str_split = strsplit(allnames{kk},'_ditrend');
                end
                
                new_name  = [str_split{1}, '_clean.mat'];
                cd(stim_dest_str)
                eeg_cleanup(tmp_trial, time_begin, 1, new_name );
            end

        end
    end
end

end

