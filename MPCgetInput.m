function [u1] = MPCgetInput(T, S, R_scld, Q_scld, P, dim, x0)
% This is the place where the current state is used to perform the constrained MPC optimisation

[H,h]=costgen(T, S, R_scld, Q_scld, P, dim, x0); 

uN = sdpvar(dim.N, dim.nu);

Objective = 0.5*


end

