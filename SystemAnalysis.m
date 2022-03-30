clear; clc; close all;
updateAll("Y")
load System.mat

%% Nyquist
L = series(eye(2), DTsys);
nq = eye(2) + L;
detnq = nq(1,1)*nq(2,2) - nq(2,1)*nq(1,2);
nyquistplot(-1*detnq)

%% Pole zero
figure()
pzmap(DTsys)
display(pole(DTsys))
display(tzero(DTsys))

%% Controllability
K = ctrb(CTsys);
rank(K) == 4;

%% Observability
W = obsv(CTsys);
rank(W) == 4;

%% Eigenspace
[V, D] = eig(CTsys.A);

%% Preemptive pole placement
SIMO1 = ss(DTsys.A, DTsys.B(:,1), DTsys.C, DTsys.D(:,1), DTsys.Ts);
K_simo1 = rank(ctrb(SIMO1));

P = eig(SIMO1.A);
K = place(SIMO1.A, SIMO1.B, [0.979, P(2), P(3), 0.98]);

%% Controllabillity of 1 channel state feedback controlled system
SIMO2 = ss(DTsys.A - DTsys.B(:,1)*K, DTsys.B(:,2), DTsys.C, DTsys.D(:,2), DTsys.Ts);

K_simo2 = rank(ctrb(SIMO2));

%% State set based on limited input magnitude
% x = [ z_dot;  theta_dot;  theta;  z]
lim = 0.25./K



