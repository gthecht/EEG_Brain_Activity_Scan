function [] = covs_of_stims(stim, subj_dir)
% calculates and saves the cov matrices for stim, in subj_dir:
src_dir  = [subj_dir, '\Stim_',stim, '\good_data'];
dest_dir = [subj_dir, '\Stim_',stim, '\cov'];

%% Making the covs:

allfiles = dir(edited_EEG_data);
allnames = {allfiles.name}.';
N = length(allnames);
for ii=1:N
    good_str = ~isempty(strfind(allnames{ii},'trial'));
    if good_str == 1
        tmp_trial   = load(allnames{ii});
        str_split   = strsplit(allnames{ii},'_');
        new_name    = [str_split{1}, '_cov.mat'];
        tmp_row_cov = cov_of_rows(tmp_trial.data_good);
        save(new_name,'tmp_row_cov');
    end
end

end

