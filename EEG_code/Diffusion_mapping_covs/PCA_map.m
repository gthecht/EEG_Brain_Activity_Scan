function [ pca_vec, type_label ] = PCA_map( vecs_in_cols, dat_lengths, legend_cell, label )
% Runs PCA on the input which is the data vector, in columns as a mtrix.
% dat_lengths is a vector containing the number of trials per experiment

pca_vec = pca(vecs_in_cols);

%% Plotting/Scattering the map after PCA
% We'll create a marker-shape vector:
mkr_shape = {'o','v','d','s','^','p','>','h','<'};
stim_num  = size(legend_cell,1);
figure(); hold on;
for ii = 1: length(dat_lengths(:))
    indices = (sum(dat_lengths(1:ii-1))+1):sum(dat_lengths(1:ii));
    scatter3(pca_vec(indices,1),pca_vec(indices,2),pca_vec(indices,3), 50, ...
        label(ii) * ones(1,dat_lengths(ii)), mkr_shape{mod(ii-1,stim_num)+1});
end
% colormap hsv;
xlabel('coef_1');
ylabel('coef_2');
zlabel('coef_3');
legend(legend_cell(:), 'Interpreter', 'none');
title('PCA map, colored according to sick and healthy')
title('PCA map');
type_label = [];
figure(); hold on;
for ii = 1: length(dat_lengths(:))
    indices = (sum(dat_lengths(1:ii-1))+1):sum(dat_lengths(1:ii));
    scatter3(pca_vec(indices,1),pca_vec(indices,2),pca_vec(indices,3), 50,...
        ii * ones(1,dat_lengths(ii)), mkr_shape{mod(ii-1,stim_num)+1});
    type_label = [type_label,ii * ones(1,dat_lengths(ii))];
end
colormap hsv;
xlabel('coef_1');
ylabel('coef_2');
zlabel('coef_3');
legend(legend_cell(:), 'Interpreter', 'none');
title('PCA map, colored per subject and stimulation')
end

