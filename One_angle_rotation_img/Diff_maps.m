%%  Diffusion maps 23/04/2017

%   Gilad Hecht and Ronen Rahamim
%   Trying Diffusion maps on set of pictures that the difference between 
%   them is the angle (Theta).
%   The images are pictures of Equation we were taken and rotated.

clear;
close all;
clc;



%% Loading the images
angles = 0:5:355;
images_cell = cell(length(angles));
%images       = struct(length(angles)^2,1);
vImageSize = [400, 400];
for ii = angles / 5 + 1 
    curr_filename   = sprintf('img%d.png',(ii-1) * 5);
    fileName        = ['img', num2str(5*ii - 5), '.png']; 
    curr_file       = rgb2gray(imread(curr_filename));
    [dx, dy]        = size(curr_file);
    vPadSize        = vImageSize - size(curr_file);
    dx_pad          = 281-dx;
    dy_pad          = 316-dy;
    curr_file       = padarray(curr_file, [floor(dx_pad/2), dy_pad], 255);
    if(size(curr_file,1)==280)
        curr_file=[curr_file;(255*ones(1,316))];
    end;
    %curr_file       = imresize(curr_file,[281 948]);
    images_cell{ii} = double(curr_file);
    %images(:,:,ii*10+jj+1)   = rgb2gray(imread(curr_filename));
end
 figure();
 imshow(images_cell{1}, []);

%we'll resize the images so that all of them are the same size, with the
%writing in the middle.
% resized_images = order_images( images_cell );

%%
%images_cell=imresize(cell2mat(images_cell),[281 316]);
% figure()
% imshow(rgb2gray(imread('img90.png')));
% [dx dy]=size(rgb2gray(imread('img90.png')));
%% Organizing the images
images_in_cols = zeros(316*281,72);
for ii=1:length(angles)
    images_in_cols(:,ii)  = images_cell{ii}(:);
%     images_in_cols(:,ii)  = reshape(cell2mat(images_cell(ii)),1,316*281);
end;
%images_in_cols  = reshape(vertcat(images_cell{:}),[],72);
[lRow, lCol]    = size(images_in_cols);

%% The Code

% Calculating the Kernel for each dimention in the images
norm_squared = squareform(pdist(images_in_cols'));
eps          = .3 * median(norm_squared(:));
mK           = exp(-(norm_squared.^2)/(2*eps^2));

% Calculating the diagonal matrix D
mD = diag( sum(mK, 2) );
% mD           = zeros(size(mK));
% for ii=1:size(mK)
%    mD(ii,ii) = sum(mK(ii,:),2);
% end;

% Calculating A, it's eigenvalues and eigenvectors for the diffusion
mA            = mD \ mK;
[mV , mE]     = eig(mA);


%% Plotting/Scattering the map after diffusion
figure()
scatter3(mV(:,2),mV(:,3),mV(:,4), 50, 1:lCol, 'Fill');
colorbar();
%view(90,0);
xlabel('\psi_2');
ylabel('\psi_3');
zlabel('\psi_4');
view(0,90);

%% Scattering the pictures in the relevant places

figure();
for ii=1:lCol
%    if( abs(mV(ii,3))<0.01 || abs(mV(ii,2))<0.01)
        xImage = [mV(ii,2)-0.005 mV(ii,2)-0.005; mV(ii,2)+0.005 mV(ii,2)+0.005];
        yImage = [mV(ii,3)+0.005 mV(ii,3)-0.005; mV(ii,3)+0.005 mV(ii,3)-0.005];
        zImage = [mV(ii,4) mV(ii,4); mV(ii,4) mV(ii,4)];
        surf(xImage,yImage,zImage,'CData',(images_cell{ii}),...
          'FaceColor','texturemap');
        hold on;
%   end
end
view(0,90);
hold off;
xlabel('\psi_2');
ylabel('\psi_3');
zlabel('\psi_4');




