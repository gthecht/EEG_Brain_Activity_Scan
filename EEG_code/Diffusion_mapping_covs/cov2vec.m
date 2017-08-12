function [ cov_mat, dat_lengths ] = cov2vec( data_cell, directories)
% Recives the directories that contain all the cov matrices
%% orderering all the covs
cov_cell = [];
if isempty(data_cell) %loads them from the selected directories
    dat_lengths = zeros(length(directories),1);
    for ii = 1:length(directories)
        cd(directories{ii});
        allfiles = dir(directories{ii});
        allnames = {allfiles.name}.';
        N = length(allnames);
        good_str = zeros(N,1);

        temp_cov_cell = cell(N,1);
        name_str = 'cov';
        for jj = 1:N
            good_str(jj) = ~isempty(strfind(allnames{jj},name_str));
            if good_str(jj)
                temp  = load(allnames{jj});
                field = fieldnames(temp);
                temp_cov_cell{jj} =  getfield(temp, field{1});
            end
        end
        temp_cov_cell = temp_cov_cell(find(good_str));
                        % All the covs of the trials are in the cell.
        dat_lengths(ii) = length(temp_cov_cell);

        cov_cell      = [cov_cell;temp_cov_cell];
    end
else        % orders them from the given cell
    dat_lengths = zeros(size(data_cell));
    for ii = 1:length(data_cell(:))
        dat_lengths(ii) = length(data_cell{ii});
        cov_cell        = [cov_cell ; data_cell{ii}];
    end    
end

%% Now we calculate the Riemannian mean iteratively
M      = length(cov_cell);
[rows, cols] = size(cov_cell{1});
cov_3Dmat = zeros(rows, cols,M);
for jj = 1: M
    cov_3Dmat(:, :, jj) =  cov_cell{jj};
end
cov_mat = CovsToVecs(cov_3Dmat);
end

