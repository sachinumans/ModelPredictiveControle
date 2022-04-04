function [u] = MPCgetInput(T, S, cstr, R_scld, Q_scld, P, dim, xRef, uRef, x0, sys, t)
% This is the place where the current state is used to perform the constrained MPC optimisation

[H,h]=costgen(T, S, R_scld, Q_scld, P, dim, x0-xRef); 

uN = sdpvar(dim.nu*dim.N,1);

states = (T*x0 + S*uN);

Objective = 0.5*(uN-uRef)'*H*(uN-uRef) + h'*(uN-uRef);
Constraints = [cstr.X_cstr*states                                           <= cstr.X_cstr_b,...
               cstr.U_cstr*uN                                               <= cstr.U_cstr_b,...
               cstr.Xf_cstr*(states(end-2*dim.nx+1:end-dim.nx)-xRef)        <= cstr.Xf_cstr_b... % Original cstr.Xf_cstr*(states(end-2*dim.nx:end-dim.nx-1)-xRef)        <= cstr.Xf_cstr_b...
               ];

optimize(Constraints, Objective);

u = value(uN(1:dim.nu));

proj_states = reshape(value(states), 4, dim.N+1);

% plot(sys.Ts*(t:t+dim.N), reshape(value(states), 4, dim.N+1), 'Color', [1/t^(1/4) 1-1/t^(1/4) 1/t^(1/4) 0.15])
subplot(2,2,1)
hold on
plot(sys.Ts*(t:t+dim.N), proj_states(1,:), 'Color', [1/t^(1/4) 1-1/t^(1/4) 1/t^(1/4) 0.2])
plot(sys.Ts*(t:t+dim.N), xRef(1)*ones(dim.N+1,1), 'Color', 'b')
hold off
subplot(2,2,2)
hold on
plot(sys.Ts*(t:t+dim.N), proj_states(2,:), 'Color', [1/t^(1/4) 1-1/t^(1/4) 1/t^(1/4) 0.2])
plot(sys.Ts*(t:t+dim.N), xRef(2)*ones(dim.N+1,1), 'Color', 'b')
hold off
subplot(2,2,3)
hold on
plot(sys.Ts*(t:t+dim.N), proj_states(3,:), 'Color', [1/t^(1/4) 1-1/t^(1/4) 1/t^(1/4) 0.2])
plot(sys.Ts*(t:t+dim.N), xRef(3)*ones(dim.N+1,1), 'Color', 'b')
hold off
subplot(2,2,4)
hold on
plot(sys.Ts*(t:t+dim.N), proj_states(4,:), 'Color', [1/t^(1/4) 1-1/t^(1/4) 1/t^(1/4) 0.2])
plot(sys.Ts*(t:t+dim.N), xRef(4)*ones(dim.N+1,1), 'Color', 'b')
hold off
end

