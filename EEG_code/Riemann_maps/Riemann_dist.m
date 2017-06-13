function [ R_dist ] = Riemann_dist( X, Y )
%Calculates the Riemannian distance between X and Y
log_eig = log(eig(inv(X) * Y));
R_dist = sqrt(sum(log_eig.^2));
end

