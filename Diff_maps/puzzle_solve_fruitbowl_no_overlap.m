% Gilad & Ronen
%working with diffusion maps.
%We'll take an image, and cut it up into little smaples like a puzzle, then
%we'll run the diffusion algorithm on it, in the hope of identifying
%images close to each other.

clc; close all; clear;

%% loading image and cropping into puzzle
fruit_orig = imread('Fruit_bowl_orig.jpg'); % original image
fruit_gray = rgb2gray(fruit_orig);          % grayscale image
nice_fruit_gray = [fruit_gray;249 * ones(1,615)];

figure(1);
imshow(nice_fruit_gray);

%We'll start without overlapping images
n = 50;                                    % number of pieces (divides by 3)
piece_size = [41,123];
puzzle_pieces = zeros(41,123,n);

figure(2);
title('puzzle pieces (10x5)');
for ii = 1:10
    for jj = 1:5
        current_puzzle_piece = nice_fruit_gray((ii-1) * piece_size(1)+1: ii * piece_size(1), ...
                                       (jj-1) * piece_size(2)+1 : jj * piece_size(2));
        puzzle_pieces(:,:, (ii-1) * 5 + jj) = current_puzzle_piece;
        subplot(10, 5, (ii-1) * 5 + jj);      % Showing puzzle pieces
        %imshow(uint8(current_puzzle_piece));
        imshow(uint8(puzzle_pieces(:,:, (ii-1) * 5 + jj))); % checking to see that all's ok
    end;
end;

%% Overlapping puzzle pieces:
% m = 36;
% overlapping_pieces =  zeros(41 * 2,123 * 2,m);
% figure(3);
% title('overlapping pieces (9x4)');
% for ii = 1:9
%     for jj = 1:4
%         overlapping_pieces(:,:, (ii-1) * 4 + jj) = ...
%                 [puzzle_pieces(:,:, (ii-1) * 5 + jj), puzzle_pieces(:,:, (ii-1) * 5 + jj+1); ...
%                 puzzle_pieces(:,:, (ii-1) * 5 + jj+5), puzzle_pieces(:,:, (ii-1) * 5 + jj+6)];
%         subplot(9, 4, (ii-1) * 4 + jj);      % Showing puzzle pieces
%         %imshow(uint8(current_puzzle_piece));
%         imshow(uint8(overlapping_pieces(:,:, (ii-1) * 4 + jj))); % checking to see that all's ok
%     end;
% end;


%% Now the real fun begins:
eps = 10^8;        %1 for now
[X,Y] = meshgrid(1:n);
mK = reshape(exp(-sum(sum((puzzle_pieces(:,:,X)-puzzle_pieces(:,:,Y)).^2,1)) / eps),50, 50); 
                                    %the distance between each two images
            % NOTE: probably won't look good, since the photos aren't
            % similar in similar areas.

[~,normK] = meshgrid(sum(mK,2));
mA = mK ./ normK;
[mV,mD] = eig(mA);

mpsi = mD * mV';

mdiff_dist = reshape(sum(( mpsi(X,:) - mpsi(Y,:) ).^2,2),50, 50);

%[~,ind] = sort(mV(:,4));
[~,ind] = sort(mdiff_dist(:,1));
figure(4)
for ii = 1:50
    subplot(10, 5, ii);      
    imshow(uint8(puzzle_pieces(:,:, ind(ii))));
end;












































