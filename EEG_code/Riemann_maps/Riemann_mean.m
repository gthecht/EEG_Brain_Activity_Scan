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
cov_3Dmat = zeros(rows, cols,N);
for ii = 1: N
    cov_3Dmat(:, :, ii) =  cov_mats{ii};
end
Riem_mean = RiemannianMean(cov_3Dmat);
end

