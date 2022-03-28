function [xRef,uRef] = approxRef(yRef, sys, cstr, dim, Q, R)
H=blkdiag(Q,R);
h=[-Q*xstar; -R*ustar];
%equality constraints, to impose that xs,us is an equilibium
Aeq=[A-eye(n) B];  
beq=zeros(n,1);

setpoint = quadprog(H,h,[],[],Aeq,beq,[],[],[],options);
xs=setpoint(1:n);
us=setpoint(n+1:end);
end

