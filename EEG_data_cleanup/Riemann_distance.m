function [ riemann_delta ] = Riemann_distance( X, Y )
% Takes 2 cov matrices, and calculates the Riemannian geodesic distance


riemann_delta = sqrt(sum((log(eig(inv(X) * Y)))^2));
end

