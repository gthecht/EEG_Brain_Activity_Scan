close all;
clear;

N = 4;
M = 500;
d = 10;

mMu      = rand(d, N);
mMu(:,2) = 10  * mMu(:,2);
mMu(:,3) = -1  * mMu(:,3);
mMu(:,4) = -10 * mMu(:,4);

mX = [];
vY = [];

for ii = 1 : N
    mXi = bsxfun(@plus, randn(d, M), mMu(:,ii));
    vYi = ii * ones(M, 1);
    mX = cat(2, mX, mXi);
    vY = cat(1, vY, vYi);
end

mData = [mX; vY'];

