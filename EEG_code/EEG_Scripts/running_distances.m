%% Showing the distances together

% typical branch on Gilad's disk_on_key:
% D:\Project\EEG_Data\Edited_Data\C04\1\distances
%% adding the path to the data and to the functions
prompt={'Enter the distances folder of first'...
        'Enter the distances folder of second'...
        'Enter the distances folder of third'};
dir_title  = 'Directories';
directories = inputdlg(prompt,dir_title);
direct_1   = directories{1};
direct_2   = directories{2};
direct_3   = directories{3};

cellfun(@(x) addpath(x), directories);

%% understanding which people and stimulations these are:
[ label1, index1 ] = find_typical( direct_1 );
[ label2, index2 ] = find_typical( direct_2 );
[ label3, index3 ] = find_typical( direct_3 );
%%
figure();
cd(direct_1);
allfiles = dir(direct_1);
allnames = {allfiles.name}.';
N = length(allnames);
for ii = 1:N
    good_str = ~isempty(strfind(allnames{ii},'cov'));
    if good_str == 1
        tmp_dist_mat = load(allnames{ii});
        field     = fieldnames(tmp_dist_mat);
        dist_mat   = getfield(tmp_dist_mat, field{1});
        scatter3(dist_mat(index1),dist_mat(index2),dist_mat(index3),50,1);
        hold on;
    end
end

cd(direct_2);
allfiles = dir(direct_2);
allnames = {allfiles.name}.';
N = length(allnames);
for ii = 1:N
    good_str = ~isempty(strfind(allnames{ii},'cov'));
    if good_str == 1
        tmp_dist_mat = load(allnames{ii});
        field     = fieldnames(tmp_dist_mat);
        dist_mat   = getfield(tmp_dist_mat, field{1});
        scatter3(dist_mat(index1),dist_mat(index2),dist_mat(index3),50,2);
        hold on;
    end
end

cd(direct_3);
allfiles = dir(direct_3);
allnames = {allfiles.name}.';
N = length(allnames);
for ii = 1:N
    good_str = ~isempty(strfind(allnames{ii},'cov'));
    if good_str == 1
        tmp_dist_mat = load(allnames{ii});
        field     = fieldnames(tmp_dist_mat);
        dist_mat   = getfield(tmp_dist_mat, field{1});
        scatter3(dist_mat(index1),dist_mat(index2),dist_mat(index3),50,3);
        hold on;
    end
end
%%

title('distances of points from typical covs');
xlabel(['distance from mean of: ', label1]);
ylabel(['distance from mean of: ', label2]);
zlabel(['distance from mean of: ', label3]);