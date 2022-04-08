tic
%% Update all of the saved .mat files
updateAll("Y");
load System
load cstrMat
%% Set hyperprism shape and initial boundaries
dir = cstr.verts_f;
k = repmat([0.1 10], dim.nx^2, 1);
maxIter = 20; Iter=0;
Err = 1e-2;
maxFound = false; lastFailed = true;
db = -1; %debug var
%% Get hyperprism vertices multiplier 
% v = [ones(1, 4), -1*ones(1, 4)];
% C = unique(nchoosek(v,4), 'rows');
% for idx = 1:size(C, 1)
%     C = [C; unique(perms(C(idx,:)), 'rows')];
% end
% C = unique(C, 'rows');

%% Perform bisection optimisation
for idx = 1:size(cstr.verts_f, 2)
    maxFound = false; Iter = 0;
    while ~maxFound && Iter<=maxIter
        x0 = mean(k(idx,:))*dir(:, idx); % Get scaled vertices
        try
            x = funcDoMPC(x0, 6, [0;0]); % try to run MPC
            k(idx,1) = mean(k(idx,:)); % if MPC is succesful, update region
            db = 0;
            if k(idx,2)-k(idx,1)<Err % if largest gain is found
                maxFound = true;
            end
        catch ME % if MPC fails, update region
            k(idx,2) = mean(k(idx,:));
            db = 1;
            if k(idx,2)-k(idx,1)<Err % if largest gain is found
                maxFound = true;
            end
        end
        Iter = Iter+1;
    end
end

vertX0 = k(:, 1).*dir';
kFin = k(:, 1);

%%
X_0 = zeros(dim.nx+dim.nd, dim.N, dim.nx^2); % reset vertices evolutions
parfor a = 1:dim.nx^2
    X_0(:,:,a) = funcDoMPC(vertX0(a, :)', dim.N, [0;0]);
end

%%
save X_0.mat X_0 vertX0 kFin

SignalConstraints()
toc