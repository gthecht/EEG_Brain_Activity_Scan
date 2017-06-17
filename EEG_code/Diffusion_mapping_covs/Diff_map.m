function [ eigvec, color ] = Diff_map( vecs_in_cols, dat_lengths, labels )
% Runs diffusion maps on the input which is the data vector, in columns as
% a mtrix.
% dat_lengths is a vector containing the number of trials per experiment

% Calculating the Kernel for each dimension in the images
norm_squared = squareform(pdist(vecs_in_cols'));
eps          = median(norm_squared(:));
mK           = exp(-(norm_squared.^2)/(2*eps^2));

% Calculating the diagonal matrix D
mD = diag( sum(mK, 2) );

% Calculating A, it's eigenvalues and eigenvectors for the diffusion
mA            = mD \ mK;
[mV , mE]     = eig(mA);
eigvec        = mV(:,2:4);

%% Plotting/Scattering the map after diffusion
color = [];
for ii = 1: length(dat_lengths)
    color = [color, ii * ones(1,dat_lengths(ii))];
end
figure()
scatter3(mV(:,2),mV(:,3),mV(:,4), 50, color, 'Fill');
% colorbar();
%view(90,0);
xlabel('\psi_2');
ylabel('\psi_3');
zlabel('\psi_4');
diff_title = ['Diffusion maps of: ', labels{:}];
title(diff_title);
% view(0,90);

end

