% Gilad & Ronen 6.04.17
% finding the distance of trials from different means, and drawing them on
% a 3D scatter_plot
clear;
clc;

%% adding the path to the data and to the functions
prompt={'Enter the place you want to take the cov mats from:',...
    'Enter the place you want to take the typicial matrices from:',...
    'Enter the place you want to place the distance in files:'};
dir_title  = 'Directories';
directories      = inputdlg(prompt,dir_title);

% Mean should be in mean folder within the cov folder.
%% Splitting directories

source_direct      = directories{1};
typic_direct       = directories{2};
dest_direct        = directories{3};

cellfun(@(x) addpath(x), directories);
cd(dest_direct);
%% Cleaning the data and downsampling it

allfiles = dir(source_direct);
allnames = {allfiles.name}.';
N = length(allnames);
%% making the typical matrix cell:
meanfiles = dir(typic_direct);
mean_names = {meanfiles.name}.';
K = length(mean_names)-2;
typic_cell = cell(K,1);
for ii = 1:K+2
    good_str = ~isempty(strfind(mean_names{ii},'mean'));
    if good_str == 1
        tmp            = load(mean_names{ii});
        typic_cell{ii} = tmp.Riem_mean;
    end
end
typic_cell = typic_cell(cellfun(@(X) ~isempty(X), typic_cell));
%% distances from typical matrices
distances = zeros(K,N-2);
% this is a matrix containing all the distance for the files in the source
% folder.
cnt = 0;
for ii=1:N
    good_str = ~isempty(strfind(allnames{ii},'cov'));
    if good_str == 1
        cnt = cnt+1;
        tmp_cov_mat = load(allnames{ii});
        str_split = strsplit(allnames{ii},'.');
        new_name  = [str_split{1}, '_dist.mat'];
        field     = fieldnames(tmp_cov_mat);
        cov_mat   = getfield(tmp_cov_mat, field{1});
        dist_vec  = dist_from_typical_mats( cov_mat , typic_cell );
        distances(:,cnt) = dist_vec;
        save(new_name, 'dist_vec');
    end    
end
%%  Now we can map them out:
% if K == 2
%     figure(1); scatter(distances(1,:), distances(2,:));
%     title('scatter according to distance from given means');
%     xlabel('distance from mean1'); ylabel('distance from mean2');
% elseif K > 2
%     figure(1); scatter3(distances(1,:), distances(2,:), distances(3,:));
%     title('scatter according to distance from given means');
%     xlabel('distance from mean1'); ylabel('distance from mean2'); 
%     zlabel('distance from mean3');
% end

beep; pause(0.5); beep;





