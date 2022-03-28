clear; close all; clc;
%%
updateAll("Y");
%%
load System.mat
load cstrMat.mat
load CostMat.mat

x0 = [0;0;0.2;0.2];

[T,S] = predmodgen(sys,dim,x0);

if any(cstr.X_cstr1*x0 >= cstr.X_cstr_b1); error("Initial state is outside of state set"); end

yRef = [-0.05; 0.05];

if any(yRef >= cstr.ymax); error("Reference won't yield a reference state for which a steadying input existst"); end

[xRef,uRef] = getRef(yRef, sys, cstr, dim)
uRefN = repmat(uRef, dim.N, 1);

%%
n = 20; x = [x0, zeros(4,n-1)]; u = zeros(2, n); % init
if n < dim.N; error("Simulation time too short"); end
u(:,1) = MPCgetInput(T, S, cstr, R_scld, Q_scld, P, dim, xRef,uRefN, x0);
for t = 2:n
    x(:,t) = sys.A*x(:, t-1) + sys.B*u(:, t-1);
    [T,S] = predmodgen(sys,dim,x(:,t));
    u(:,t) = MPCgetInput(T, S, cstr, R_scld, Q_scld, P, dim, xRef,uRefN, x(:,t));
end

%%
figure('Name', "State evolution")
plot(0:sys.Ts:sys.Ts*(n-1), x')
legend("$\dot{z}$", "$\dot{\theta}$", "$\theta$", "z", 'Interpreter', 'latex')
figure('Name', "Inputs")
plot(0:sys.Ts:sys.Ts*(n-1), u')
legend("$\delta_s$", "$\delta_b$", 'Interpreter', 'latex')
