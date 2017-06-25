function [] = covs_of_stims(stim, subj_dir)
% calculates and saves the cov matrices for stim, in subj_dir:
src_dir  = [subj_dir, '\Stim_',num2str(stim), '\good_data'];
dest_dir = [subj_dir, '\Stim_',num2str(stim), '\cov'];

%% Making the covs:

allfiles = dir(src_dir);
allnames = {allfiles.name}.';
N = length(allnames);


for ii=1:N
    good_str = ~isempty(strfind(allnames{ii},'trial'));
    if good_str == 1
        cd(src_dir);
        tmp_trial   = load(allnames{ii});
        str_split   = strsplit(allnames{ii},'_good_data');
        new_name    = [str_split{1}, '_cov.mat'];
        tmp_row_cov = cov_of_rows(tmp_trial.good_data);
        cd(dest_dir);
        save(new_name,'tmp_row_cov');
    end
end

end

