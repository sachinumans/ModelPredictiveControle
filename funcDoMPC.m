function [x] = funcDoMPC(x0, n, yRef)
%% Offline
load System.mat
load cstrMat.mat
load CostMat.mat

% yRef = [0; 0]; %z, theta

x0hat = x0;%[0;0;0;0];
d = 0;
d0hat = 0;

[T,S] = predmodgen(sys,dim);
L = getObserverGain(sys, dsys, dim);

if any(cstr.X_cstr1*x0 >= cstr.X_cstr_b1)
    error("Initial state is outside of state set")
end


%% Initialisation

xRef = zeros(dim.nx,n);
uRef = zeros(dim.nu,n);

x = [[x0; d], zeros(dim.nx+dim.nd,n-1)]; % init x including d
xhat = [[x0hat; d0hat], zeros(dim.nx+dim.nd,n-1)];
u = zeros(dim.nu, n); 

[xRef(:,1),uRef(:,1)] = getRef(yRef, x(dim.nx+1:end,1), sys, dsys, cstr, dim); % Reference signals excluding d
uRefN = repmat(uRef(:,1), dim.N, 1);

% if n < dim.N; error("Simulation time too short"); end

%% Online
u(:,1) = MPCgetInput(T, S, cstr, R_scld, Q_scld, P, dim, xRef(:,1),uRefN, x0hat, sys, 1, "N");
for t = 2:n
    t
    x(:,t) = [sys.A, dsys.B; zeros(dim.nd, dim.nx), dsys.A]*x(:, t-1) + [sys.B; zeros(dim.nd, dim.nu)]*u(:, t-1);
    [xhat(:,t), xRef(:,t), uRef(:,t)] = Observer(L, xhat(:,t-1), x(:,t-1), u(:,t-1), yRef, sys, dsys, cstr, dim);
    uRefN = repmat(uRef(:,t), dim.N, 1);
    u(:,t) = MPCgetInput(T, S, cstr, R_scld, Q_scld, P, dim, xRef(:,t),uRefN, xhat(1:dim.nx,t), sys, t, "N");
end
end

