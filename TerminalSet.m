function [term_set, sqrtc, V_scld] = TerminalSet(K, P, cstr)
[V, D] = eig(P);

norm1 = norm(V(:,1));
norm2 = norm(V(:,2));
norm3 = norm(V(:,3));
norm4 = norm(V(:,4));

cost1 = 1/2 * V(:,1).' * P * V(:,1);
cost2 = 1/2 * V(:,2).' * P * V(:,2);
cost3 = 1/2 * V(:,3).' * P * V(:,3);
cost4 = 1/2 * V(:,4).' * P * V(:,4);

scl2 = sqrt(cost1/cost2);
scl3 = sqrt(cost1/cost3);
scl4 = sqrt(cost1/cost4);

V_scld = [V(:,1), scl2*V(:,2), scl3*V(:,3), scl4*V(:,4)];

% V = eye(4)
Xs = [];
sgn = [-1,1];
for i = 1:2
for j = 1:2
for k = 1:2
for l = 1:2
Xs =  [Xs, V_scld(:,1).*sgn(i) + V_scld(:,2).*sgn(j) + V_scld(:,3).*sgn(k) + V_scld(:,4).*sgn(l)]; 
end
end
end
end

A_opt = reshape(K*Xs, [32,1]);
b_opt = 15*ones(size(A_opt));
A_opt = [A_opt; -A_opt];
b_opt = [b_opt;  b_opt];

A_opt = [A_opt; reshape(cstr.X_cstr1*Xs, [10*16, 1])];
b_opt = [b_opt; repmat(cstr.X_cstr_b1, 16,1)];
sqrtc = linprog(-1, A_opt, b_opt);

term_set = sqrtc*Xs;

c = sqrtc^2

end