%Gilad & Ronen 24/03/17
%Description:
%trying out SVM, using normal distribution of two classes with means around
%different points.

close all;
clear all;
clc;
disp(' SVM, using normal distribution of two classes with');
disp('means around different points.');
disp('-----------------------------------------------------');

%% two normally distributed groups around different points

%number of points for each class:
n1=1000;
%class A:
m_a= [-2,1];    %mean of A
s_a= 2;     %sigma of A
A_class= s_a*randn(n1,2)+ones(n1,1)*m_a;  %vector of class A

%class B:
m_b= [3,-2];    %mean of B
s_b= 1;     %sigma of B
B_class= s_b*randn(n1,2)+ones(n1,1)*m_b;  %vector of class B

%plot A and B on xy graph:
figure(1)
scatter(A_class(:,1),A_class(:,2),15,'b','filled');
%scatter(A_class(:,1),A_class(:,2),20,'+');
hold on;
scatter(B_class(:,1),B_class(:,2),15,'r','filled');
title('classes A B over XY');
xlabel('x');
ylabel('y');
legend('A','B');

%% Training the SVM with two classes A and B:
train_AB = [A_class;B_class];
label_AB = [ones(n1,1);-ones(n1,1)];
SVM_AB_model = fitcsvm(train_AB,label_AB);

%find the areas of each class
max_x = max(abs(train_AB(:,1)));
max_y = max(abs(train_AB(:,2)));
k= 1000; %number of points in mesh
mesh_x = linspace(-max_x,max_x,k);
mesh_y = linspace(-max_y,max_y,k);
[X,~] = meshgrid(mesh_x);
[~,Y] = meshgrid(mesh_y);
[~,score_AB] = predict(SVM_AB_model,[X(:),Y(:)]);
reshaped_score_AB = reshape(score_AB(:,2),size(X));

%% Plotting SVM and A and B:
% plot line dividing between classes.
figure(2)
contour(X,Y,reshaped_score_AB,1);
title('classes with dividing line');
xlabel('x');
ylabel('y');
hold on;
scatter(A_class(:,1),A_class(:,2),15,'b','filled');
%scatter(A_class(:,1),A_class(:,2),20,'+');
hold on;
scatter(B_class(:,1),B_class(:,2),15,'r','filled');
legend('SVM','A','B');


%Classifier in mesh:
figure(3)
mesh(X,Y,reshaped_score_AB);
view(0,90);
colorbar;
title('SVM prediction function');
xlabel('x');
ylabel('y');
zlabel('SVM prediction');
xlim([min(min(X)),max(max(X))]);
ylim([min(min(Y)),max(max(Y))]);
hold on;
scatter3(A_class(:,1),A_class(:,2),ones(length(A_class),1)*100,15,'b','filled');
%scatter(A_class(:,1),A_class(:,2),20,'+');
scatter3(B_class(:,1),B_class(:,2),ones(length(B_class),1)*100,15,'r','filled');

%% Test:
%Question: is there a nifty way to check how good the model is?

A_test= s_a*randn(n1,2)+ones(n1,1)*m_a;  %vector of class A
B_test= s_b*randn(n1,2)+ones(n1,1)*m_b;  %vector of class B

A_test_outcome = predict(SVM_AB_model,A_test);
B_test_outcome = predict(SVM_AB_model,B_test);
A_test_grade = 100*(sum(A_test_outcome)+length(A_test))/(2*length(A_test));
B_test_grade = -100*(sum(B_test_outcome)-length(B_test))/(2*length(B_test));

A_str = sprintf('Success percantage for A class: %2.1f%%',A_test_grade);
B_str = sprintf('Success percantage for B class: %2.1f%%',B_test_grade);

disp(A_str);
disp(B_str);
















