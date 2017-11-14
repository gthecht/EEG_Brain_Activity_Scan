function [] = plot_decision_space(SVM_model, diff_mat, description)
%plot_decision_space sketches the decision space in the first 3D for the
%given SVM model.
given_points = diff_mat(:,1:3);
labels       = diff_mat(:,end-1:end);

n = 30;
xlimits = [min(given_points(:,1)), max(given_points(:,1))];
ylimits = [min(given_points(:,2)), max(given_points(:,2))];
zlimits = [min(given_points(:,3)), max(given_points(:,3))];
vx = linspace(xlimits(1), xlimits(2), n);
vy = linspace(ylimits(1), ylimits(2), n);
vz = linspace(zlimits(1), zlimits(2), n);
[X, Y, Z] = meshgrid(vx, vy, vz);
decision_area = [X(:), Y(:), Z(:), zeros(numel(X),size(diff_mat,2)-5)];
decision  = SVM_model.predictFcn(decision_area);
figure(); hold on
scatter3(X(:), Y(:), Z(:), 1, decision(:));
scatter3(given_points(:,1), given_points(:,2),...
  given_points(:,3), 50, 2+diff_mat(:,end));
colormap('cool');
title(description);
end

