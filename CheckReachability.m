tic
%% Update all of the saved .mat files
updateAll("Y");
load System
%% Set hyperprism shape and initial boundaries
dir = [0.2;0.1;2;1];
k = repmat([0.1 5], dim.nx^2, 1);
maxIter = 10; Iter=0;
Err = 5e-2;
maxFound = false; lastFailed = true;

%% Get hyperprism vertices multiplier
v = [ones(1, 4), -1*ones(1, 4)];
C = unique(nchoosek(v,4), 'rows');
for idx = 1:size(C, 1)
    C = [C; unique(perms(C(idx,:)), 'rows')];
end
C = unique(C, 'rows');

%% Perform bisection optimisation
for idx = 1:dim.nx^2
    while ~maxFound && Iter<=maxIter
        X_0 = zeros(dim.nx+dim.nd, dim.N, dim.nx^2); % reset vertices evolutions
        x0 = mean(k(idx,:))*C(idx, :)'.*dir; % Get scaled vertices
        try
            X_0(:,:,idx) = funcDoMPC(x0, dim.N); % try to run MPC
            k(idx,1) = mean(k(idx,:)); % if MPC is succesful, update region
            if k(idx,2)-k(idx,1)<Err % if largest gain is found
                maxFound = true;
            end
        catch ME % if MPC fails, update region
            k(idx,2) = mean(k(idx,:));
            if k(idx,2)-k(idx,1)<Err % if largest gain is found
                maxFound = true;
            end
        end
        Iter = Iter+1;
    end
end

vertX0 = k(:, 1).*C.*dir';

save X_0.mat X_0 vertX0

SignalConstraints()
toc