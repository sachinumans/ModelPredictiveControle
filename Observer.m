function [xhatP, dhatP, xRef, uRef] = Observer(L, Ld, xhat, dhat, x, u, yRef, sys, dsys, cstr, dim)
% Estimates the state xhat and constant disturbance dhat, also updates the
% reference signals based on dhat
xhatP = sys.A*xhat + dsys.B*dhat + sys.B*u + L*(sys.C*x - sys.C*xhat - dsys.C*dhat);
dhatP = dsys.A*dhat + Ld*(sys.C*x - sys.C*xhat - dsys.C*dhat);

[xRef,uRef] = getRef(yRef, dhat, sys, dsys, cstr, dim);
end

