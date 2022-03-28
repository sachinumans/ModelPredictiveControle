function [u] = MPCgetInput(T, S, cstr, R_scld, Q_scld, P, dim, xRef, uRef, x0)
% This is the place where the current state is used to perform the constrained MPC optimisation

[H,h]=costgen(T, S, R_scld, Q_scld, P, dim, x0); 

uN = sdpvar(dim.nu*dim.N,1);

states = (T*x0 + S*uN);

Objective = 0.5*(uN-uRef)'*H*(uN-uRef) + h'*(uN-uRef);
Constraints = [cstr.X_cstr*states                                           <= cstr.X_cstr_b,...
               cstr.U_cstr*uN                                               <= cstr.U_cstr_b,...
               cstr.Xf_cstr*(states(end-2*dim.nx:end-dim.nx-1)-xRef)        <= cstr.Xf_cstr_b];

optimize(Constraints, Objective);

u = value(uN(1:2));

end

