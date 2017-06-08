function [ Riem_point ] = inv_tang_map(X, T)
%takes the X in the tangent space and returns it to the Riemannian space
%around T
[VT, DT]  = eig(T);
T_sqrt    = VT * diag(sqrt(diag(DT))) * VT.';
T_invsqrt = inv(T_sqrt);
[VX, DX]  = eig(X);
expX      = VX * diag(exp(diag(DX))) * VX.';
Riem_point = T_sqrt * expX * T_sqrt;
end

