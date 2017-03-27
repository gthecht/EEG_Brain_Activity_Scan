%Gilad & Ronen 24/03/17
%Description:
%SVM, normal distribution of three/four classes with means around
%different points.

close all;
clear all;
clc;
disp(' SVM, using normal distribution of three/four classes with');
disp('means around different points.');
disp('-----------------------------------------------------');

%% two normally distributed groups around different points

%number of points for each class:
n1=1000;
%class A:
m_a= [5,-5];    %mean of A
s_a= 1;     %variance of A
A_class= s_a*randn(n1,2)+ones(n1,1)*m_a;  %vector of class A

%class B:
m_b= [-5,-5];    %mean of B
s_b= 1;     %variance of B
B_class= s_b*randn(n1,2)+ones(n1,1)*m_b;  %vector of class B

%class C:
m_c= [5,5];    %mean of B
s_c= 1;     %variance of B
C_class= s_c*randn(n1,2)+ones(n1,1)*m_c;  %vector of class C

% %class D:
% m_d= [3,-2];    %mean of D
% s_d= 1;     %variance of D
% D_class= s_d*randn(n1,2)+ones(n1,1)*m_d;  %vector of class D

%plot A, B and C (and D on xy graph:
figure()
scatter(A_class(:,1),A_class(:,2),15,'b','filled');
%scatter(A_class(:,1),A_class(:,2),20,'+');
hold on;
scatter(B_class(:,1),B_class(:,2),15,'r','filled');
scatter(C_class(:,1),C_class(:,2),15,'y','filled');
%scatter(D_class(:,1),D_class(:,2),15,'r','filled');
title('classes A, B, C over XY');
xlabel('x');
ylabel('y');
legend('A','B','C');

%% Training the SVM with two classes AB and C:

train_ABandC = [A_class;B_class;C_class];
label_ABandC = [ones(n1*2,1);-ones(n1,1)];  %1 = in A or B, -1 = in C
SVM_ABandC_model = fitcsvm(train_ABandC,label_ABandC);
figure();
svmtrain_ABandC = svmtrain(train_ABandC,label_ABandC,'ShowPlot',true);


%find the areas of each class
max_x = max(abs(train_ABandC(:,1)));
max_y = max(abs(train_ABandC(:,2)));
k= 1000; %number of points in mesh
mesh_x = linspace(-max_x,max_x,k);
mesh_y = linspace(-max_y,max_y,k);
[X,~] = meshgrid(mesh_x);
[~,Y] = meshgrid(mesh_y);
[~,score_of_AB] = predict(SVM_ABandC_model,[X(:),Y(:)]);
normalized_score_of_AB = score_of_AB/(2*max(max(abs(score_of_AB))))+0.5*ones(size(score_of_AB));
reshaped_score_of_AB = reshape(normalized_score_of_AB(:,2),size(X));

%% Plotting SVM and AB and C:
% plot line dividing between classes.
%figure()
% % contour(X,Y,reshaped_score_of_AB,1);
% % title('classes with dividing line');
% % xlabel('x');
% % ylabel('y');
% % hold on;
% % scatter(A_class(:,1),A_class(:,2),15,'b','filled');
% % %scatter(A_class(:,1),A_class(:,2),20,'+');
% % hold on;
% % scatter(B_class(:,1),B_class(:,2),15,'r','filled');
% % scatter(C_class(:,1),C_class(:,2),15,'y','filled');
% % %scatter(D_class(:,1),D_class(:,2),15,'r','filled');
% % legend('SVM','A','B','C');


%Classifier in mesh:
figure()
mesh(X,Y,reshaped_score_of_AB);
view(0,90);
colorbar;
title('SVM prediction function AB against C');
xlabel('x');
ylabel('y');
zlabel('SVM prediction');
xlim([min(min(X)),max(max(X))]);
ylim([min(min(Y)),max(max(Y))]);
hold on;
scatter3(A_class(:,1),A_class(:,2),ones(length(A_class),1)*100,15,'b','filled');
%scatter(A_class(:,1),A_class(:,2),20,'+');
scatter3(B_class(:,1),B_class(:,2),ones(length(B_class),1)*100,15,'r','filled');
scatter3(C_class(:,1),C_class(:,2),ones(length(B_class),1)*100,15,'y','filled');
%scatter(D_class(:,1),D_class(:,2),15,'r','filled');
legend('SVM','A','B','C');

%% Training the SVM with two classes A and BC:
train_AandBC = [A_class;B_class;C_class];
label_AandBC = [2*ones(n1,1);-2*ones(2*n1,1)];  %2 = in A , -2 = in B or C
SVM_AandBC_model = fitcsvm(train_AandBC,label_AandBC);
figure();
svmtrain_AandBC = svmtrain(train_AandBC,label_AandBC,'ShowPlot',true);


%find the areas of each class

[~,score_of_A] = predict(SVM_AandBC_model,[X(:),Y(:)]);
normalized_score_of_A = score_of_A/(2*max(max(abs(score_of_A))))+0.5*ones(size(score_of_AB));
reshaped_score_of_A = reshape(normalized_score_of_A(:,2),size(X));

%% Plotting SVM and A and BC:
%Classifier in mesh:
figure()
mesh(X,Y,reshaped_score_of_A);
view(0,90);
colorbar;
title('SVM prediction function A against BC');
xlabel('x');
ylabel('y');
zlabel('SVM prediction');
xlim([min(min(X)),max(max(X))]);
ylim([min(min(Y)),max(max(Y))]);
hold on;
scatter3(A_class(:,1),A_class(:,2),ones(length(A_class),1)*100,15,'b','filled');
%scatter(A_class(:,1),A_class(:,2),20,'+');
scatter3(B_class(:,1),B_class(:,2),ones(length(B_class),1)*100,15,'r','filled');
scatter3(C_class(:,1),C_class(:,2),ones(length(B_class),1)*100,15,'y','filled');
%scatter(D_class(:,1),D_class(:,2),15,'r','filled');
legend('SVM','A','B','C');

%% and printing the combination of both predictions:
figure()
mesh(X,Y,(1-reshaped_score_of_A).*reshaped_score_of_AB);
view(0,90);
colorbar;
title('probability of being in B');
xlabel('x');
ylabel('y');
zlabel('SVM prediction');
xlim([min(min(X)),max(max(X))]);
ylim([min(min(Y)),max(max(Y))]);
hold on;
scatter3(A_class(:,1),A_class(:,2),ones(length(A_class),1)*100,15,'b','filled');
%scatter(A_class(:,1),A_class(:,2),20,'+');
scatter3(B_class(:,1),B_class(:,2),ones(length(B_class),1)*100,15,'r','filled');
scatter3(C_class(:,1),C_class(:,2),ones(length(B_class),1)*100,15,'y','filled');
%scatter(D_class(:,1),D_class(:,2),15,'r','filled');
legend('SVM','A','B','C');

%prob of being A
figure()
mesh(X,Y,(reshaped_score_of_A).*reshaped_score_of_AB);
view(0,90);
colorbar;
title('probability of being in A');
xlabel('x');
ylabel('y');
zlabel('SVM prediction');
xlim([min(min(X)),max(max(X))]);
ylim([min(min(Y)),max(max(Y))]);
hold on;
scatter3(A_class(:,1),A_class(:,2),ones(length(A_class),1)*100,15,'b','filled');
%scatter(A_class(:,1),A_class(:,2),20,'+');
scatter3(B_class(:,1),B_class(:,2),ones(length(B_class),1)*100,15,'r','filled');
scatter3(C_class(:,1),C_class(:,2),ones(length(B_class),1)*100,15,'y','filled');
%scatter(D_class(:,1),D_class(:,2),15,'r','filled');
legend('SVM','A','B','C');

%prob of being C
figure()
mesh(X,Y,(1-reshaped_score_of_A).*(1-reshaped_score_of_AB));
view(0,90);
colorbar;
title('probability of being in C');
xlabel('x');
ylabel('y');
zlabel('SVM prediction');
xlim([min(min(X)),max(max(X))]);
ylim([min(min(Y)),max(max(Y))]);
hold on;
scatter3(A_class(:,1),A_class(:,2),ones(length(A_class),1)*100,15,'b','filled');
%scatter(A_class(:,1),A_class(:,2),20,'+');
scatter3(B_class(:,1),B_class(:,2),ones(length(B_class),1)*100,15,'r','filled');
scatter3(C_class(:,1),C_class(:,2),ones(length(B_class),1)*100,15,'y','filled');
%scatter(D_class(:,1),D_class(:,2),15,'r','filled');
legend('SVM','A','B','C');

%% Creating the decision tree:
label_num = predict(SVM_ABandC_model,x,y) + predict(SVM_AandBC_model,x,y); %3 = A, -3 = C, -1 = B, 1 = ?

%% Cross validation:


%% Test:
%Question: is there a nifty way to check how good the model is?

A_test= s_a*randn(n1,2)+ones(n1,1)*m_a;  %vector of class A
B_test= s_b*randn(n1,2)+ones(n1,1)*m_b;  %vector of class B

A_test_outcome = predict(SVM_ABandC_model,A_test);
B_test_outcome = predict(SVM_ABandC_model,B_test);
A_test_grade = 100*(sum(A_test_outcome)+length(A_test))/(2*length(A_test));
B_test_grade = -100*(sum(B_test_outcome)-length(B_test))/(2*length(B_test));

A_str = sprintf('Success percantage for A class: %2.1f%%',A_test_grade);
B_str = sprintf('Success percantage for B class: %2.1f%%',B_test_grade);

disp(A_str);
disp(B_str);
















