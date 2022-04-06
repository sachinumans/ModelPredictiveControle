load System
X_0 = zeros(dim.nx+dim.nd, dim.N, dim.nx^2);

v = [ones(1, 4), -1*ones(1, 4)];
C = unique(nchoosek(v,4), 'rows');
for idx = 1:size(C, 1)
    C = [C; unique(perms(C(idx,:)), 'rows')];
end
C = unique(C, 'rows');

init = [0.5;0.5;1;0.9];
x0 = C'.*init;

parfor idx = 1:dim.nx^2
    X_0(:,:,idx) = funcDoMPC(x0(:,idx), dim.N);
end


save X_0.mat X_0