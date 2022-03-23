clear; close all; clc;
%%
updateAll("Y");
%%
load System.mat
load cstrMat.mat
load CostMat.mat

x0 = [0.1;0;0;0.04];

[T,S] = predmodgen(sys,dim,x0);

if any(cstr.X_cstr1*x0 >= cstr.X_cstr_b1)
    error("Initial state is outside of state set")
end



%%
n = 100; x = [x0, zeros(4,n)]; u = zeros(2, n); % init
if n < dim.N; error("Simulation time too short"); end
u(:,1) = MPCgetInput(T, S, cstr, R_scld, Q_scld, P, dim, x0);
for t = 2:n
    x(:,t) = sys.A*x(:, t-1) + sys.B*u(:, t-1);
    u(:,t) = MPCgetInput(T, S, cstr, R_scld, Q_scld, P, dim, x(:,t));
end

%%
figure('Name', "State evolution")
plot(x')
legend("$\dot{z}$", "$\dot{\theta}$", "$\theta$", "z", 'Interpreter', 'latex')
figure('Name', "Inputs")
plot(u')
legend("$\delta_s$", "$\delta_b$", 'Interpreter', 'latex')
