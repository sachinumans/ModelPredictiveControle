function [xRef,uRef] = getRef(yRef, dhat, sys, dsys, cstr, dim)
% Get the best estimates for the steady state x and u such that yRef is
% outputted

uref = sdpvar(dim.nu,1);
xref = sdpvar(dim.nx,1);

N = [2.5, 20, 4, 0.1]; % State normalising vector
Nu = [4, 4]; % Input normalising vector

Objective = norm(N*xref + Nu*uref, 1);
Constraints = [ (eye(size(sys.A))-sys.A)*xref - sys.B*uref == dsys.B*dhat ,...
                sys.C*xref == yRef - dsys.C*dhat ,...
                cstr.X_cstr1 * xref <= cstr.X_cstr_b1 ,...
                cstr.U_cstr1 * uref <= cstr.U_cstr_b1 ...
                ];
            
f = optimize(Constraints, Objective);

if f.problem > 0
    warning("No feasible input to obtain steady state with given reference and disturbance estimate, ignoring disturbance estimate."); 
    Constraints = [ (eye(size(sys.A))-sys.A)*xref - sys.B*uref == 0 ,...
                    sys.C*xref == yRef ,...
                    cstr.X_cstr1 * xref <= cstr.X_cstr_b1 ,...
                    cstr.U_cstr1 * uref <= cstr.U_cstr_b1 ...
                    ];
    f = optimize(Constraints, Objective);
    xRef = value(xref);
    uRef = value(uref);
    return
end

xRef = value(xref);
uRef = value(uref);

end

