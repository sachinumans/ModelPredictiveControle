clear
load System.mat

N = diag([2.5, 20, 4, 0.1]);
Q = diag([1, 1, 10, 10]);
Q_scld = N.'*Q*N;

R = diag([2, 1]);
Nu = diag([4, 4]);
R_scld = Nu.'*R*Nu;

[P, K, L] = idare(sys.A, sys.B, Q_scld, R_scld);

%%
[T,S]=predmodgen(sys,dim);                 


save CostMat.mat Q_scld R_scld P T S K

