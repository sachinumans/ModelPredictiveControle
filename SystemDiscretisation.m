load param

M = [m-Z_dw, -Z_dq, 0, 0;...
     -M_dw, I_yy - M_dq, 0, 0;...
     0, 0, 1, 0;...
     0, 0, 0, 1];
A_Z = [Z_w*u0, (m + Z_q)*u0, 0, 0;...
       M_w*u0, M_q*u0, 0, B*Z_B;...
       1, 0, 0, -u0;...
       0, 1, 0, 0];

B_Z = [Z_dels*u0^2, Z_delb*u0^2;...
       M_dels*u0^2, M_delb*u0^2;...
       zeros(2)];
   
A = M\A_Z;
B = M\B_Z;
C = [0, 0, 0, 1];
D = zeros(1, 2);

CTsys = ss(A, B, C, D);
    CTsys.u = {'del_s', 'del_b'};
    CTsys.y = {'z'};
    CTsys.StateName = {'z_dot', 'theta_dot', 'theta', 'z'};

DTsys = c2d(CTsys, 30);

sys = DTsys;

%% Dimensions and horizon
dim.N=10;

dim.nx=size(sys.A,1);
dim.ny=size(sys.C,1);
dim.nu=size(sys.B,2);

save System.mat sys CTsys dim

