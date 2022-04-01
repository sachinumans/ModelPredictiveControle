function [xRef,uRef] = getRef(yRef, sys, cstr)
% Get the best estimates for the steady state x and u such that yRef is
% outputted

uref = sdpvar(2,1);
xref = sdpvar(4,1);

N = [2.5, 20, 4, 0.1]; % State normalising vector
Nu = [4, 4]; % Input normalising vector

Objective = norm(N*xref + Nu*uref, 1);
Constraints = [ (eye(size(sys.A))-sys.A)*xref - sys.B*uref == 0 ,...
                sys.C*xref == yRef ,...
                cstr.X_cstr1 * xref <= cstr.X_cstr_b1 ,...
                cstr.U_cstr1 * uref <= cstr.U_cstr_b1 ...
                ];
            
f = optimize(Constraints, Objective);

if f.problem > 0
    error("No feasible input to obtain steady state with given reference, attempting to find a feasible point nearby."); 
%     [xRef,uRef] = approxRef(yRef, sys, cstr);
%     return
end

xRef = value(xref);
uRef = value(uref);

end

