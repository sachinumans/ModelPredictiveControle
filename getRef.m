function [xRef,uRef] = getRef(yRef, sys, cstr)
% Get the best estimates for the steady state x and u such that yRef is
% outputted

u = sdpvar(2,1);
x = sdpvar(4,1);

N = [2.5, 20, 4, 0.1]; % State normalising vector
Nu = [4, 4]; % Input normalising vector

Objective = N*x + Nu*u;
Constraints = [ (eye(size(sys.A))-sys.A)*x - sys.B*u == 0 ,...
                sys.C*x == yRef ,...
                cstr.X_cstr1 * x <= cstr.X_cstr_b1 ,...
                cstr.U_cstr1 * u <= cstr.U_cstr_b1 ];
            
optimize(Constraints, Objective)

xRef = value(x);
uRef = value(u);

end

