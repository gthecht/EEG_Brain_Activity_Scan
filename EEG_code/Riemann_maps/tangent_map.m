function [ tang_point ] = tangent_map( X, T )
%finds the equivalent point of X, in the space tangent to T.
% Formula is: upper(T^-1/2 * Log_T(X) * T^-1/2)

% T^-1/2 = U*D^-1/2 * inv(U) where D is the diagonal matrix of T
[VT, DT]  = eig(T);
T_invsqrt = VT * diag(1./(sqrt(diag(DT)))) * inv(VT);

[VX, DX]  = eig(T_invsqrt*X*T_invsqrt);
logX      = VX * diag(log(diag(DX))) * inv(VX);

point     = T_invsqrt * logX * T_invsqrt;
[meshX, meshY] = meshgrid(1:size(T));
tang_point = point;
% tang_point = [diag(point) ; sqrt(2) * point(meshX > meshY)];
end

