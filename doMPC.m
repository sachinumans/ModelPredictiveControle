clear; close all; clc;
%% Update all of the saved .mat files
updateAll("Y");
%% Offline
load System.mat
load cstrMat.mat
load CostMat.mat

n = 20; 
yRef = [2; 0; 0]; %z, theta, thetadot

x0 = [-0.5;0;0.2;-1];
x0hat = x0;%[0;0;0;0];
d = [0; 0; 0];

[T,S] = predmodgen(sys,dim,x0);
[L, Ld] = getObserverGain(sys, dsys);

if any(cstr.X_cstr1*x0 >= cstr.X_cstr_b1)
    error("Initial state is outside of state set")
end


%% Initialisation
figure('Name', "Projected states"); hold on


xRef = zeros(dim.nx,n);
uRef = zeros(dim.nu,n);

x = [x0, zeros(dim.nx,n-1)]; % init
xhat = [x0hat, zeros(dim.nx,n-1)]; 
u = zeros(dim.nu, n); 
dhat = zeros(dim.ny,n);

[xRef(:,1),uRef(:,1)] = getRef(yRef, dhat(:,1), sys, dsys, cstr, dim);
uRefN = repmat(uRef(:,1), dim.N, 1);

if n < dim.N; error("Simulation time too short"); end

%% Online
u(:,1) = MPCgetInput(T, S, cstr, R_scld, Q_scld, P, dim, xRef(:,1),uRefN, x0hat, sys, 1);
for t = 2:n
    t
    x(:,t) = sys.A*x(:, t-1) + sys.B*u(:, t-1) + dsys.B*d;
    [xhat(:,t), dhat(:,t), xRef(:,t), uRef(:,t)] = Observer(L, Ld, xhat(:,t-1), dhat(:,t-1), x(:,t), u(:,t-1), yRef, sys, dsys, cstr, dim);
    uRefN = repmat(uRef(:,t), dim.N, 1);
    [T,S] = predmodgen(sys,dim,xhat(:,t));
    u(:,t) = MPCgetInput(T, S, cstr, R_scld, Q_scld, P, dim, xRef(:,t),uRefN, xhat(:,t), sys, t);
end

%% Plotting
subplot(2,2,1)
title("$\dot{z}$", 'Interpreter', 'latex')
hold on

hold off
subplot(2,2,2)
title("$\dot{\theta}$", 'Interpreter', 'latex')
subplot(2,2,3)
title("$\theta$", 'Interpreter', 'latex')
subplot(2,2,4)
title("z", 'Interpreter', 'latex')
hold off

%%
figure('Name', "Evolution", 'windowState', 'maximized')
subplot(2,1,1)
plot(0:sys.Ts:sys.Ts*(n-1), x')
title("States")
legend("$\dot{z}$", "$\dot{\theta}$", "$\theta$", "z", 'Interpreter', 'latex')
subplot(2,1,2)
plot(0:sys.Ts:sys.Ts*(n-1), u')
title("Inputs")
legend("$\delta_s$", "$\delta_b$", 'Interpreter', 'latex')
