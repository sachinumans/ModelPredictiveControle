load System
%% Set hyperprism shape and initial boundaries
shape = [0.25;0.25;0.75;1];
k = [0 5];
maxIter = 10; Iter=0;
Err = 1e-1;
maxFound = false;

%% Get hyperprism vertices multiplier
v = [ones(1, 4), -1*ones(1, 4)];
C = unique(nchoosek(v,4), 'rows');
for idx = 1:size(C, 1)
    C = [C; unique(perms(C(idx,:)), 'rows')];
end
C = unique(C, 'rows');

%% Perform bisection optimisation
while ~maxFound && Iter<=maxIter
    X_0 = zeros(dim.nx+dim.nd, dim.N, dim.nx^2); % reset vertices evolutions
    x0 = mean(k)*C'.*shape; % Get scaled vertices

    try
        parfor idx = 1:dim.nx^2
            X_0(:,:,idx) = funcDoMPC(x0(:,idx), dim.N); % try to run MPC
        end
    catch ME % if MPC fails, update region
        k(2) = mean(k);
        if k(2)-k(1)<Err % if largest prism is found
            maxFound = true;
        end
    end
end



save X_0.mat X_0