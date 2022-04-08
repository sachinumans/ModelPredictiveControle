clear; close all; clc;
load System.mat
load cstrMat.mat
n = 50;

idx1 = 1; idx2 = 1;
X = linspace(-8, 8, n);
Y = linspace(-3, 3, n);
Z = zeros(n,n,4);


for z=X
    idx2=1;
    for theta=Y
        uref = sdpvar(dim.nu,1);
        xref = sdpvar(dim.nx,1);

        N = [2.5, 20, 4, 0.1]; % State normalising vector
        Nu = [4, 4]; % Input normalising vector

        Objective = norm(N*xref + Nu*uref, 1);
        Constraints = [ (eye(size(sys.A))-sys.A)*xref - sys.B*uref == 0 ,...
                        sys.C(1:2, :)*xref == [z; theta] ,...
                        cstr.X_cstr1 * xref <= cstr.X_cstr_b1 ,...
                        cstr.U_cstr1 * uref <= cstr.U_cstr_b1 ...
                        ];

        f = optimize(Constraints, Objective);
        
        Z(idx1, idx2, :) = [value(xref(1)), value(xref(2)), value(uref')];
        idx2 = idx2+1;
    end
    idx1 = idx1 +1;
end
save SSset.mat X Y Z
%%

Z(Z==0) = NaN;

figure('Name', "Steady state solutions", "WindowState", "maximized")
subplot(2,2,1)
mesh(X, Y, Z(:,:,1))
title("zdot"); xlabel("z"); ylabel("theta");
subplot(2,2,2)
mesh(X, Y, Z(:,:,1))
title("thetadot"); xlabel("z"); ylabel("theta");
subplot(2,2,3)
mesh(X, Y, Z(:,:,2))
title("delta s"); xlabel("z"); ylabel("theta");
subplot(2,2,4)
mesh(X, Y, Z(:,:,3))
title("delta b"); xlabel("z"); ylabel("theta");
