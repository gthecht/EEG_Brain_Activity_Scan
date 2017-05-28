function [ R_dist ] = Riemann_dist( X, Y )
%Calculates the Riemannian distance between X and Y

R_dist = sqrt(sum((log(eig(inv(X) * Y))).^2));
end

