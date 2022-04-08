%%%%%%%%%%%%%%%%%%%%%%
% General sandbox for system analysis
%%%%%%%%%%%%%%%%%%%%%%
clear; clc; close all;
updateAll("Y")
load System.mat
load cstrMat

%% Pole zero
figure()
pzmap(sys)
display(pole(sys))
display(tzero(sys))

%% Controllability
K = ctrb(CTsys);
rank(K) == 4;

%% Observability
W = obsv(CTsys);
rank(W) == 4;

%% Eigenspace
[V, D] = eig(CTsys.A);

%% Preemptive pole placement
SIMO1 = ss(sys.A, sys.B(:,1), sys.C, sys.D(:,1), sys.Ts);
K_simo1 = rank(ctrb(SIMO1));

P = eig(SIMO1.A);
K = place(SIMO1.A, SIMO1.B, [0.979, P(2), P(3), 0.98]);

%% Controllabillity of 1 channel state feedback controlled system
SIMO2 = ss(sys.A - sys.B(:,1)*K, sys.B(:,2), sys.C, sys.D(:,2), sys.Ts);

K_simo2 = rank(ctrb(SIMO2));

%% State set based on limited input magnitude
% x = [ z_dot;  theta_dot;  theta;  z]
lim = 0.25./K;

%% Stability (Terminal Constraint)
load CostMat
[set, c, Vs] = TerminalSet(K, P, cstr);

figure
subplot(2,2,1)
plot(set(1,:), set(2,:), 'x')
subplot(2,2,2)
plot(set(1,:), set(4,:), 'x')
subplot(2,2,3)
plot(set(3,:), set(4,:), 'x')
subplot(2,2,4)
plot(set(3,:), set(2,:), 'x')


%% Observabillity of system with constant disturbance
rank([eye(4)-sys.A, -dsys.B; sys.C, dsys.C])


