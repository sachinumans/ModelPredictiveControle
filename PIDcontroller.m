clc; clear; close all;
load System

SISO1 = ss(sys.A, sys.B(:, 1), sys.C(1, :), sys.D(1, 1), sys.Ts);
SISO2 = ss(sys.A, sys.B(:, 2), sys.C(2, :), sys.D(2, 2), sys.Ts);

pid1 = ss(pid(-2.873629470823379, -0.006469809153533, 0));
pid2 = ss(pid(9.323369375093955e-08, 1.999329780919283e-12, 0.001086929315531));
pid1.Ts = sys.Ts; pid2.Ts = sys.Ts;

pid1.u = 'z(1)'; pid1.y = 'zBar';
pid2.u = 'z(2)'; pid2.y = 'thetaBar';

S1 = sumblk('del_s = r(1) - zBar');
S2 = sumblk('del_b = r(2) - thetaBar');
S1.Ts = sys.Ts; S2.Ts = sys.Ts; 

FB = connect(S1, S2, sys, pid1, pid2, {'r(1)', 'r(2)'}, {'z(1)', 'z(2)'});

[f, FB1] = isproper(FB);

r = zeros(dim.N, dim.nu);
t = (0:dim.N-1)*sys.Ts;
x0 = [-0.5;-0.5;-1;-0.9];

dat = lsim(FB1, r, t, x0);
