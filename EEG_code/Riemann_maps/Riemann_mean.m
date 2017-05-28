function [ Riem_mean ] = Riemann_mean( dir_name,  name_str, iter)
%Finds the mean of all  objects in folder "dir_name", that have "name_str" in their name.
% assuming that the distances
% are short and therefore, we can use the transform to a local tangent plain,
% there the mean is calculated using the Euclidean distance metric.

%% loading all the trials
cd(dir_name);
allfiles = dir(dir_name);
allnames = {allfiles.name}.';
N = length(allnames);
good_str = zeros(N,1);

cov_mats = cell(N,1);
for ii = 1:N
    good_str(ii) = ~isempty(strfind(allnames{ii},name_str));
    if good_str(ii)
        temp  = load(allnames{ii});
        field = fieldnames(temp);
        cov_mats{ii} =  getfield(temp, field{1});
    end
end
cov_mats = cov_mats(find(good_str));      % All the covs of the trials are in the cell.
N      = length(cov_mats);
%% Now we calculate the Riemannian mean iteratively
[rows, cols] = size(cov_mats{1});
cov_3Dmat = zeros(N,rows, cols);
for ii = 1: N
    cov_3Dmat(ii, :, :) =  cov_mats{ii};
end
curr_mean = squeeze(mean(cov_3Dmat,1));
si = zeros(N,rows, cols);
% Now for the iterative loop:
for kk = 1:iter
    for ii = 1:N
        si(ii,:,:) = tangent_map(squeeze(cov_3Dmat(ii,:,:)),curr_mean); 
                        % the point on the tangent that fits the i'th trial
    end
    euc_mean  = squeeze(mean(si,1)); % The euclidean mean for current si's.
    curr_mean = real(euc_mean);
end

Riem_mean = curr_mean;
end

