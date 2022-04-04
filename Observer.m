function [xhatP, xRef, uRef] = Observer(L, xhat, x, u, yRef, sys, dsys, cstr, dim)
% Estimates the state xhat and constant disturbance dhat, also updates the
% reference signals based on dhat
xhatP = [sys.A, dsys.B; zeros(dim.nd, dim.nx), dsys.A]*xhat ...
        + [sys.B; zeros(dim.nd, dim.nu)]*u ...
        + L*(sys.C*x(1:dim.nx) - [sys.C, dsys.C]*xhat);
dhat = xhatP(dim.nx+1:end);
[xRef,uRef] = getRef(yRef, dhat, sys, dsys, cstr, dim);
end

