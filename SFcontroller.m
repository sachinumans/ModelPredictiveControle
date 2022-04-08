clear; close all; clc;
%% Update all of the saved .mat files
updateAll("Y");
load System
load cstrMat
load X_0
load CostMat

%% Define SF system
Ksf = place(sys.A, sys.B, [0.3, 0.4, 0.5, 0.6]);
% g = dcgain(sys);
% FFsf = ((eye(dim.nx) - sys.A + sys.B*Ksf));%[1./g(1,:); g(1,:); g(1,:); 1./g(1,:) ];
% FFlqr = ((eye(dim.nx) - sys.A - sys.B*K));%[1./g(1,:); g(1,:); g(1,:); 1./g(1,:) ]; 
for w = 1:2
    x0 = vertX0(randi(size(vertX0,1)), :)';
    yref = rand(2,1)*2-1.*[1;2];
    [xref, ~] = getRef(yref, 0, sys, dsys, cstr, dim);
    
    xMPC = funcDoMPC(x0, dim.N, yref);
    
    xSF = [x0 zeros(dim.nx, dim.N-1)];
    xLQR = xSF;
    for t=1:dim.N-1
        uSF = min(15, max(-15, Ksf *xSF(:,t)));
        uLQR = min(15, max(-15, K *xLQR(:,t)));
        xSF(:,t+1) = sys.A*xSF(:,t) - sys.B*uSF + (eye(dim.nx) - sys.A + sys.B*Ksf)*xref; % *(1./FFsf*xref - xSF(:,t));
        xLQR(:,t+1) = sys.A*xLQR(:,t) - sys.B*uLQR + (eye(dim.nx) - sys.A + sys.B*K)*xref;% xLQR(:,t+1) = sys.A*xLQR(:,t) + sys.B*K*(1./FFlqr*xref - xLQR(:,t)); 
    end
    StateNames = ["$\dot{z}$", "$\dot{\theta}$", "$\theta$", "z", "$d_1 error$"];
    
    
    figure()
    for idx = 1:4
        subplot(2,2,idx); hold on
        plot(0:sys.Ts:sys.Ts*(dim.N-1), xMPC(idx, :))
        plot(0:sys.Ts:sys.Ts*(dim.N-1), xSF(idx, :), 'r:', 'linewidth', 1.3)
        plot(0:sys.Ts:sys.Ts*(dim.N-1), xLQR(idx, :), 'm--')
        yline(xref(idx), 'k--');
        title(StateNames(idx), 'Interpreter', 'latex');
    end    
    legend("MPC", "State Feedback", "LQR", "Reference", 'Interpreter', 'latex')
end

