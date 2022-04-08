clear
load System.mat
%% Set control design matrices
N = diag([0.6, 1.1, 0.25, 0.9]);
Q = diag([1, 1, 10, 10]);
Q_scld = N.'*Q*N;

R = diag([2, 1]);
Nu = diag([0.25, 0.25]);
R_scld = Nu.'*R*Nu;

%% Determine LQR optimal control law
[P, K, L] = idare(sys.A, sys.B, Q_scld, R_scld);

%% Get evolution and convolution matrices
[T,S]=predmodgen(sys,dim);                 


save CostMat.mat Q_scld R_scld P T S K

