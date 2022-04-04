clear; close all; clc;
%% Update all of the saved .mat files
updateAll("Y");
%% Offline
load System.mat
load cstrMat.mat
load CostMat.mat

n = 40; 
yRef = [2; 0]; %z, theta

x0 = [3;0.5;1;-1];
x0hat = [0;0;0;0];
d = 1;
d0hat = 0;

[T,S] = predmodgen(sys,dim);
L = getObserverGain(sys, dsys, dim);

if any(cstr.X_cstr1*x0 >= cstr.X_cstr_b1)
    error("Initial state is outside of state set")
end


%% Initialisation
figure('Name', "Projected states"); hold on


xRef = zeros(dim.nx,n);
uRef = zeros(dim.nu,n);

x = [[x0; d], zeros(dim.nx+dim.nd,n-1)]; % init x including d
xhat = [[x0hat; d0hat], zeros(dim.nx+dim.nd,n-1)];
u = zeros(dim.nu, n); 

[xRef(:,1),uRef(:,1)] = getRef(yRef, x(dim.nx+1:end,1), sys, dsys, cstr, dim); % Reference signals excluding d
uRefN = repmat(uRef(:,1), dim.N, 1);

if n < dim.N; error("Simulation time too short"); end

%% Online
u(:,1) = MPCgetInput(T, S, cstr, R_scld, Q_scld, P, dim, xRef(:,1),uRefN, x0hat, sys, 1);
for t = 2:n
    t
    x(:,t) = [sys.A, dsys.B; zeros(dim.nd, dim.nx), dsys.A]*x(:, t-1) + [sys.B; zeros(dim.nd, dim.nu)]*u(:, t-1);
    [xhat(:,t), xRef(:,t), uRef(:,t)] = Observer(L, xhat(:,t-1), x(:,t-1), u(:,t-1), yRef, sys, dsys, cstr, dim);
%     xhat(end,t) = 0;
    uRefN = repmat(uRef(:,t), dim.N, 1);
%     [T,S] = predmodgen(sys,dim);
    u(:,t) = MPCgetInput(T, S, cstr, R_scld, Q_scld, P, dim, xRef(:,t),uRefN, xhat(1:dim.nx,t), sys, t);
end

%% Plotting
subplot(2,2,1)
title("$\dot{z}$", 'Interpreter', 'latex')
hold on
plot(sys.Ts*(0:n-1), x(1, :))

subplot(2,2,2)
title("$\dot{\theta}$", 'Interpreter', 'latex')
hold on
plot(sys.Ts*(0:n-1), x(2, :))
subplot(2,2,3)
title("$\theta$", 'Interpreter', 'latex')
hold on
plot(sys.Ts*(0:n-1), x(3, :))
subplot(2,2,4)
title("z", 'Interpreter', 'latex')
hold on
plot(sys.Ts*(0:n-1), x(4, :))
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

%% Plot estimates versus real states
StateNames = ["$\dot{z}$", "$\dot{\theta}$", "$\theta$", "z", "$d_1 error$"];
figure('Name', "Estimates", 'windowState', 'maximized')
for idx = 1:5
    subplot(3,2,idx); hold on
    plot(0:sys.Ts:sys.Ts*(n-1), x(idx, :))
    plot(0:sys.Ts:sys.Ts*(n-1), xhat(idx, :), 'r--')
    legend(StateNames(idx), strjoin([StateNames(idx) " estimate"]), 'Interpreter', 'latex')
    title(StateNames(idx), 'Interpreter', 'latex');
end

% subplot(3,2,5); hold on
% yline(d(1, :));
% % plot(0:sys.Ts:sys.Ts*(n-1), d(1, :))
% plot(0:sys.Ts:sys.Ts*(n-1), dhat(1, :), 'r--')
% legend("d_1", "d_1 Estimate", 'Interpreter', 'latex')
% title("d_1", 'Interpreter', 'latex');
% 
% subplot(3,2,6); hold on
% yline(d(2, :));
% % plot(0:sys.Ts:sys.Ts*(n-1), d(2, :))
% plot(0:sys.Ts:sys.Ts*(n-1), dhat(2, :), 'r--')
% legend("d_2", "d_2 Estimate", 'Interpreter', 'latex')
% title("d_2", 'Interpreter', 'latex');

