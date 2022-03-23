clear; clc; close all;

load System.mat

display(["The sampling time is ", num2str(sys.Ts)])

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
rank(K) == 4

%% Observability
W = obsv(CTsys);
rank(W) == 4

%% Eigenspace
[V, D] = eig(CTsys.A)

%% Input magnitude analysis
SIMO = ss(sys.A, sys.B(:,1), sys.C, sys.D(:,1), 1);
K_simo = rank(ctrb(SIMO))

% K = sdpvar(1,4, 'full');
% obj = K*diag([0.4, 0.05, 0.25, 10])*K';
% cons = [abs(eig(SIMO.A - SIMO.B*K))<=1];
% optimize(cons, obj)
% value(K)

P = eig(SIMO.A);
K = place(SIMO.A, sys.B, [0.9, P(2), P(3), 0.9])
K'*pinv(K')