clear; close all; clc;
%%
updateAll("Y");
%%
load System.mat
load cstrMat.mat
load CostMat.mat

x0 = [-0.5;0;0.2;-1];

[T,S] = predmodgen(sys,dim,x0);

if any(cstr.X_cstr1*x0 >= cstr.X_cstr_b1)
    error("Initial state is outside of state set")
end

yRef = 0.1;
[xRef,uRef] = getRef(yRef, sys, cstr)
uRefN = repmat(uRef, dim.N, 1);

%%
figure('Name', "Projected states"); hold on
n = 20; x = [x0, zeros(4,n-1)]; u = zeros(2, n); % init
if n < dim.N; error("Simulation time too short"); end
u(:,1) = MPCgetInput(T, S, cstr, R_scld, Q_scld, P, dim, xRef,uRefN, x0, sys, 1);
for t = 2:n
    t
    x(:,t) = sys.A*x(:, t-1) + sys.B*u(:, t-1);
    [T,S] = predmodgen(sys,dim,x(:,t));
    u(:,t) = MPCgetInput(T, S, cstr, R_scld, Q_scld, P, dim, xRef,uRefN, x(:,t), sys, t);
end

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
