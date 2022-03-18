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

