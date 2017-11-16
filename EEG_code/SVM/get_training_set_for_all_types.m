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
test_labels  = all_classifier.predictFcn(test_mat(:,1:3));
confmat_all  = confusionmat(test_labels, test_mat(:, end));