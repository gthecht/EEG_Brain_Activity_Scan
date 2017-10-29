function [ mV, mE, type_label ] = Diff_map( vecs_in_cols, dat_lengths, legend_cell, label )
% Runs diffusion maps on the input which is the data vector, in columns as
% a mtrix
% dat_lengths is a vector containing the number of trials per experiment

[lRow, lCol]    = size(vecs_in_cols);
% Calculating the Kernel for each dimension in the images
norm_squared = squareform(pdist(vecs_in_cols'));
eps          = median(norm_squared(:));
mK           = exp(-(norm_squared.^2)/(2*eps^2));

% Calculating the diagonal matrix D
mD = diag( sum(mK, 2) );
sparse_mD = sparse(mD);     % Here's where I changed!!

% Calculating A, it's eigenvalues and eigenvectors for the diffusion
mA            = sparse_mD \ mK;     % and here I changed as well!
[mV , mE]     = eig(mA);
eigvec        = mV(:,2:4);

%% Plotting/Scattering the map after diffusion
color = [];
figure(); hold on;
% if strcmp(use_label,'SVM')
    for ii = 1: length(dat_lengths(:))
        indices = (sum(dat_lengths(1:ii-1))+1):sum(dat_lengths(1:ii));
        scatter3(mV(indices,2),mV(indices,3),mV(indices,4), 50, label(ii) * ones(1,dat_lengths(ii)), 'Fill');
    end
%     colormap hsv;
    xlabel('\psi_2');
    ylabel('\psi_3');
    zlabel('\psi_4');
    legend(legend_cell(:), 'Interpreter', 'none');
    title('Diffusion map, colored according to sick and healthy')
% diff_title = ['Diffusion maps of: ', labels{:}];
title('Diffusion map');
% else
type_label = [];
figure(); hold on;
    for ii = 1: length(dat_lengths(:))
        indices = (sum(dat_lengths(1:ii-1))+1):sum(dat_lengths(1:ii));
        scatter3(mV(indices,2),mV(indices,3),mV(indices,4), 50, ii * ones(1,dat_lengths(ii)), 'Fill');
        type_label = [type_label,ii * ones(1,dat_lengths(ii))];
    end
    colormap hsv;
    xlabel('\psi_2');
    ylabel('\psi_3');
    zlabel('\psi_4');
    legend(legend_cell(:), 'Interpreter', 'none');
    title('Diffusion map, colored per subject and stimulation')

end

