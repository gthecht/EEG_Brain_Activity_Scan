clc;
n = 80;
type_vec    = pca_mat(:,4);
types_num   = max(type_vec);
train_mat   = zeros(n*types_num, 5);
test_mat    = zeros(n*types_num, 5);
for jj = 1:types_num
    curr_type = find(type_vec == jj);
    test_train = pca_mat(curr_type(randperm(length(curr_type),2*n)),:);
    train_mat((jj-1)*n+1 : jj*n,:) = test_train(1:n,:);
    test_mat((jj-1)*n+1 : jj*n,:) = test_train(n+1:2*n,:);
end
[all_classifier, validationAccuracy] = train_all_classifier(train_mat);
%%
test_labels  = all_classifier.predictFcn(test_mat(:,1:3));
confmat_all  = confusionmat(test_labels, test_mat(:, end-1));
%%
figure();
imshow(confmat_all, 'InitialMagnification',100);
colormap(summer);
caxis([0,max(confmat_all(:))]);
%%
stim_confusion = zeros(9);
for jj = 1:16
    stim_confusion = stim_confusion + confmat_all(9*(jj-1) + 1:9*jj, 9*(jj-1) + 1:9*jj);
end
figure();
imshow(stim_confusion, 'InitialMagnification',10000);
colormap(summer);
caxis([0,max(confmat_all(:))]);

