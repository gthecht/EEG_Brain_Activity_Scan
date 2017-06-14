% Gilad & Ronen, 28.5.17
% calculating the Riemannian mean out of a set of cov matrices

clear;
clc;

% data_direct  = inputdlg('Where do you want to take the files from?\n','data directory');        % the place we'll take our data from
% clean_direct = inputdlg('Where do you want to place the clean files?\n','cleanup directory');   % the place we'll save our cleaned data

prompt={'Enter the subject directory:'; ...
        'Enter mean destination directory:'};
title  = 'Directories';
directories      = inputdlg(prompt,title);

%% Splitting directories

source_direct      = directories{1};
dest_direct        = directories{2};
cellfun(@(x) addpath(x), directories);
cd(dest_direct);

%% Calculating the mean for all stims within the source folder
stims = {'\1', '\2', '\3', '\11', '\12', '\13', '\14', '\15', '\16'};

for ii = 1 : length(stims)
    direct = [source_direct, stims{ii}, '\cov'];
    addpath(direct);
    allfiles  = dir(direct);
    allnames  = {allfiles.name}.';
    N = length(allnames);
    Riem_mean = Riemann_mean(direct,  'cov', 100);
    % creating name:
    str_split = strsplit(direct,'\');
    dirac_name  = [str_split{end}];
    new_name  = ['Riemannian_mean_of_',upper(dirac_name),'_',str_split{end-2},'_',str_split{end-1}];
    % saving:
    cd(dest_direct);
    save(new_name, 'Riem_mean');
end
beep; pause(0.5); beep;