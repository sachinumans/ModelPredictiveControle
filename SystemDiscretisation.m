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
C = [0, 0, 1, 0; 0, 0, 0, 1];
D = zeros(2);

CTsys = ss(A, B, C, D);
    CTsys.u = {'del_s', 'del_b'};
    CTsys.y = {'theta', 'z'};
    CTsys.StateName = {'z_dot', 'theta_dot', 'theta', 'z'};

DTsys = c2d(CTsys, 1);

sys = DTsys;

save System.mat sys CTsys

