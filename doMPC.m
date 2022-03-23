clear;
%%
updateAll("Y");
%%
load System.mat
load cstrMat.mat
load CostMat.mat

x0 = [0.25;-0.5;0.4;10];

[T,S] = predmodgen(sys,dim,x0);


%%
u = MPCgetInput(T, S, cstr, R_scld, Q_scld, P, dim, x0)