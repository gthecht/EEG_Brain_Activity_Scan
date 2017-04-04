% Gilad & Ronen
%working with diffusion maps.
%We'll take an image, and cut it up into little smaples like a puzzle, then
%we'll run the diffusion algorithm on it, in the hope of identifying
%imagjes close to each other.

fruit_orig = imread('Bowl_fruit_orig.jpg'); % original image
fruit_gray = rgb2gray(fruit_orig);          % grayscale image



