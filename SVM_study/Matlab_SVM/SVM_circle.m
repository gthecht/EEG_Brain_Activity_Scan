%Gilad & Ronen 25/03/17
%Description:
%trying out SVM, using normal distribution of two classes with means around
%different radi. And uniform distribution for the angle.

close all;
clear all;
clc;
disp(' SVM, using normal distribution of two classes with');
disp('means around different radi. And uniform distribution')
disp('for the angle.');
disp('-----------------------------------------------------');

%% training examples:
n2=1000; %number of points for each class:
%class C:
m_c= 0.5;    %mean radius of C
s_c= 0.5;     %sigma of radius of C
theta_c = 2*pi*rand(n2,1);
r_c = exp(s_c*randn(n2,1)+ones(n2,1)*m_c);
C_class= [r_c.*cos(theta_c),r_c.*sin(theta_c)];  %vector of class C

%class D:
m_d= 2;    %mean radius of D
s_d= 0.2;     %sigma of radius D
theta_d = 2*pi*rand(n2,1);
r_d = exp(s_d*randn(n2,1)+ones(n2,1)*m_d);
D_class= [r_d.*cos(theta_d),r_d.*sin(theta_d)];   %vector of class B

%plot C and D on xy graph:
figure(1)
scatter(C_class(:,1),C_class(:,2),15,'b','filled');
hold on;
scatter(D_class(:,1),D_class(:,2),15,'r','filled');
title('classes C&D over XY');
xlabel('x');
ylabel('y');
legend('C','D');

%% Training the SVM with two classes C and D:
train_CD = [C_class;D_class];
label_CD = [ones(n2,1);-ones(n2,1)];
SVM_CD_model = fitcsvm(train_CD,label_CD,'KernelFunction','rbf');

%find the areas of each class
max_x2 = max(abs(train_CD(:,1)));
max_y2 = max(abs(train_CD(:,2)));
k= 1000; %number of points in mesh
mesh_x2 = linspace(-max_x2,max_x2,k);
mesh_y2 = linspace(-max_y2,max_y2,k);
[X2,~] = meshgrid(mesh_x2);
[~,Y2] = meshgrid(mesh_y2);
[~,score_CD] = predict(SVM_CD_model,[X2(:),Y2(:)]);
reshaped_score_CD = reshape(score_CD(:,2),size(X2));

%% Plotting SVM and C and D:
% plot line dividing between classes.
figure(2)
contour(X2,Y2,reshaped_score_CD,1);
title('classes with dividing line');
xlabel('x');
ylabel('y');
hold on;
scatter(C_class(:,1),C_class(:,2),15,'b','filled');
hold on;
scatter(D_class(:,1),D_class(:,2),15,'r','filled');
legend('SVM','C','D');


%Classifier in mesh:
figure(3)
mesh(X2,Y2,reshaped_score_CD);
view(0,90);
colorbar;
title('SVM prediction function');
xlabel('x');
ylabel('y');
zlabel('SVM prediction');
xlim([min(min(X2)),max(max(X2))]);
ylim([min(min(Y2)),max(max(Y2))]);
hold on;
scatter3(C_class(:,1),C_class(:,2),ones(length(C_class),1)*100,15,'b','filled');
scatter3(D_class(:,1),D_class(:,2),ones(length(D_class),1)*100,15,'r','filled');


%% Test:
%Question: is there a nifty way to check how good the model is?

theta_c_test = 2*pi*rand(n2,1);
r_c_test = exp(s_c*randn(n2,1)+ones(n2,1)*m_c);
C_test= [r_c_test.*cos(theta_c_test),r_c_test.*sin(theta_c_test)];  %vector of class C

theta_d_test = 2*pi*rand(n2,1);
r_d_test = exp(s_d*randn(n2,1)+ones(n2,1)*m_d);
D_test= [r_d_test.*cos(theta_d_test),r_d_test.*sin(theta_d_test)];  %vector of class D

C_test_outcome = predict(SVM_CD_model,C_test);
D_test_outcome = predict(SVM_CD_model,D_test);
C_test_grade = 100*(sum(C_test_outcome)+length(C_test))/(2*length(C_test));
D_test_grade = -100*(sum(D_test_outcome)-length(D_test))/(2*length(D_test));

C_str = sprintf('Success percantage for C class: %2.1f%%',C_test_grade);
D_str = sprintf('Success percantage for D class: %2.1f%%',D_test_grade);

disp(C_str);
disp(D_str);
