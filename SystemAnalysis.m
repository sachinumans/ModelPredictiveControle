clear; clc; close all;
updateAll("Y")
load System.mat

%% Nyquist
L = series(eye(2), sys);
nq = eye(2) + L;
detnq = nq(1,1)*nq(2,2) - nq(2,1)*nq(1,2);
nyquistplot(-1*detnq)

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
lim = 0.25./K



