% Gilad & Ronen
%working with diffusion maps.
%We'll take an image, and cut it up into little strips like a puzzle, then
%we'll run the diffusion algorithm on it, in the hope of identifying
%images close to each other.

clc;
%close all;
clear;

%% loading image and cropping into puzzle
fruit_orig = imread('Fruit_bowl_orig.jpg'); % original image
fruit_gray = rgb2gray(fruit_orig);          % grayscale image
nice_fruit_gray = [fruit_gray ;249 * ones(1,615)];

 figure(1);
 imshow(nice_fruit_gray);

%We'll start without overlapping images
n = 15;                                    % number of pieces (divides by 3)
piece_size = [410,41];
puzzle_pieces = zeros(410,41,n);

figure(2);
title('puzzle pieces 15');
for ii = 1:n
    current_puzzle_piece = nice_fruit_gray(1:410,(ii-1) * piece_size(2)+1: ii * piece_size(2));
	puzzle_pieces(:,:, ii) = current_puzzle_piece;
    subplot(1,n, ii);      % Showing puzzle pieces
	%imshow(uint8(current_puzzle_piece));
	imshow(uint8(puzzle_pieces(:,:, ii))); % checking to see that all's ok
end;

%% Overlapping puzzle pieces:
m = n-3;
overlapping_pieces =  zeros(410 , 41 * 4,m);
figure(3);
title('overlapping pieces');
for ii = 1:m
	overlapping_pieces(:,:, ii) = [puzzle_pieces(:,:, ii), puzzle_pieces(:,:, ii+1),...
                                puzzle_pieces(:,:, ii+2), puzzle_pieces(:,:, ii+3)];
    subplot(1,m, ii);      % Showing puzzle pieces
	%imshow(uint8(current_puzzle_piece));
	imshow(uint8(overlapping_pieces(:,:, ii))); % checking to see that all's ok
end;


%% Now the real fun begins:
eps = 10^8;        %1 for now
[X,Y] = meshgrid(1:m);
mK = reshape(exp(-sum(sum((overlapping_pieces(:,:,X)-overlapping_pieces(:,:,Y)).^2,1)) / eps),m,m); 
                                    %the distance between each two images
            % NOTE: probably won't look good, since the photos aren't
            % similar in similar areas.

[~,normK] = meshgrid(sum(mK,2));
mA = mK ./ normK;
[mV,mD] = eig(mA);

mpsi = mD * mV';

mdiff_dist = reshape(sum(( mpsi(X,:) - mpsi(Y,:) ).^2,2),m,m);

indices = zeros(m,m);
for kk = 1:m
    [~,ind_temp]  = sort(mV(:,kk));
    indices(:,kk) = ind_temp;
end;

%[~,ind] = sort(mdiff_dist(2,:));
figure(4)
for ii = 1:m
        subplot(1,m, m+1-ii);      
        imshow(uint8(overlapping_pieces(:,:, indices(ii,4))));
end;

% for dim_i = 1:5
%     for ii = 1:m
%         figure(dim_i+3)
%         subplot(1,m, m+1-ii);      
%         imshow(uint8(overlapping_pieces(:,:, indices(ii,dim_i))));
%     end;
% end;















