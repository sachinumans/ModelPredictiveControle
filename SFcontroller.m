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
for w = 1:1
    x0 = (rand(4,1)*2-1).*vertX0;
    yref = rand(2,1)*2-1.*[1;4];
    [xref, ~] = getRef(yref, 0, sys, dsys, cstr, dim)
    
    xMPC = funcDoMPC(x0, 2*dim.N, yref);
    
    xSF = [x0 zeros(dim.nx, 2*dim.N-1)];
    xLQR = xSF;
    for t=1:2*dim.N-1
        xSF(:,t+1) = sys.A*xSF(:,t) - sys.B*Ksf *xSF(:,t) + (eye(dim.nx) - sys.A + sys.B*Ksf)*xref; % *(1./FFsf*xref - xSF(:,t));
        xLQR(:,t+1) = sys.A*xLQR(:,t) - sys.B*K*xLQR(:,t) + (eye(dim.nx) - sys.A + sys.B*K)*xref;% xLQR(:,t+1) = sys.A*xLQR(:,t) + sys.B*K*(1./FFlqr*xref - xLQR(:,t)); 
    end
    StateNames = ["$\dot{z}$", "$\dot{\theta}$", "$\theta$", "z", "$d_1 error$"];
    
    
    figure()
    for idx = 1:4
        subplot(2,2,idx); hold on
        plot(0:sys.Ts:sys.Ts*(2*dim.N-1), xMPC(idx, :))
        plot(0:sys.Ts:sys.Ts*(2*dim.N-1), xSF(idx, :), 'r--', 'linewidth', 2)
        plot(0:sys.Ts:sys.Ts*(2*dim.N-1), xLQR(idx, :), 'm--')
        legend("MPC", "State Feedback", "LQR", 'Interpreter', 'latex')
        title(StateNames(idx), 'Interpreter', 'latex');
    end    
end

