%% Showing the distances together
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

%%
figure(1);
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
        scatter3(dist_mat(1),dist_mat(2),dist_mat(3),50,1);
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
        scatter3(dist_mat(1),dist_mat(2),dist_mat(3),50,2);
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
        scatter3(dist_mat(1),dist_mat(2),dist_mat(3),50,3);
        hold on;
    end
end
%%
str_split1 = strsplit(direct_1,'\');
str_split2 = strsplit(direct_2,'\');
str_split3 = strsplit(direct_3,'\');
label1     = [str_split1{end-2},' Stim',str_split1{end-1}];
label2     = [str_split2{end-2},' Stim',str_split2{end-1}];
label3     = [str_split3{end-2},' Stim',str_split3{end-1}];

title('distances of points from typical covs');
xlabel(['distance from mean of: ', label1]);
ylabel(['distance from mean of: ', label2]);
zlabel(['distance from mean of: ', label3]);