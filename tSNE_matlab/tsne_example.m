% Load data of 100 images and the images after resizing
load('imagesG.mat');
load('resized_images.mat');
% creating train_X and train_labels
temp=double(images_in_cols');
train_X = temp(1:100,:);
train_labels = [ones(1,10),2*ones(1,10),3*ones(1,10),4*ones(1,10),...
                5*ones(1,10),6*ones(1,10),7*ones(1,10),8*ones(1,10),...
                9*ones(1,10),10*ones(1,10)];
% Set parameters
no_dims = 2;
initial_dims = 2;
perplexity = 5;
% Run t-SNE
mappedX = tsne(train_X, train_labels, no_dims, initial_dims, perplexity);
% Plot results
gscatter(mappedX(:,1), mappedX(:,2),train_labels);
%%
figure();
for ii=1:100
%    if( abs(mV(ii,3))<0.01 || abs(mV(ii,2))<0.01)
        xImage = [mappedX(ii,1)/100-0.1 mappedX(ii,1)/100-0.1; mappedX(ii,1)/100+0.1 mappedX(ii,1)/100+0.1];
        yImage = [mappedX(ii,2)/100+0.1 mappedX(ii,2)/100-0.1; mappedX(ii,2)/100+0.1 mappedX(ii,2)/100-0.1];
        zImage = [1 1; 1 1];
        surf(xImage,yImage,zImage,'CData',(resized_images{ii}),... %(vec2mat(train_X(ii,:),1290,[])),...
          'FaceColor','texturemap');
        hold on;
%   end
end
view(0,90);









% % Load data
% load('mnist_train.mat');
% ind = randperm(size(train_X, 1));
% train_X = train_X(ind(1:500),:);
% train_labels = train_labels(ind(1:500));
% % Set parameters
% no_dims = 2;
% initial_dims = 50;
% perplexity = 30;
% % Run t?SNE
% mappedX = tsne(train_X, train_labels, no_dims, initial_dims, perplexity);
% % Plot results
% gscatter(mappedX(:,1), mappedX(:,2), train_labels);