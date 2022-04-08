tic
%% Update all of the saved .mat files
updateAll("Y");
load System
%% Set hyperprism shape and initial boundaries
shape = [0.25;0.1;0.75;1];
k = repmat([0 5], dim.nx, 1);
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
while ~maxFound && Iter<=maxIter
    for s=1:dim.nx
        X_0 = zeros(dim.nx+dim.nd, dim.N, dim.nx^2); % reset vertices evolutions
        scale = k(:, 1); scale(s) = mean(k(s, :));
        x0 = scale.*C'.*shape; % Get scaled vertices
        x0 = unique(x0', 'rows')';

        try
            parfor idx = 1:size(x0, 2)
                X_0(:,:,idx) = funcDoMPC(x0(:,idx), dim.N); % try to run MPC
            end
            k(s, 1) = mean(k(s, :)); % if MPC is succesful, update region
            if all(k(:, 2)-k(:, 1)<Err) % if largest prism is found
                maxFound = true;
                lastFailed = false;
            end
        catch ME % if MPC fails, update region
            k(s, 2) = mean(k(s, :));
            if all(k(:, 2)-k(:, 1)<Err) % if largest prism is found
                maxFound = true;
                lastFailed = true;
            end
        end
    end
    Iter = Iter+1;
end

if lastFailed
    X_0 = zeros(dim.nx+dim.nd, dim.N, dim.nx^2); % reset vertices evolutions
    x0 = k(1)*C'.*shape; % Get scaled vertices
    parfor idx = 1:dim.nx^2
            X_0(:,:,idx) = funcDoMPC(x0(:,idx), dim.N); % try to run MPC
    end
end

vertX0 = x0(:,end);

save X_0.mat X_0 vertX0

SignalConstraints()
toc