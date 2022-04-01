clear all;
% Inertias
I_yy  = 4370*10^7;
m     = 1993*10^3;
% Buoyancy Force
B     = 1955*10^7;
% Added Mass
Z_dw  = -1655*10^6;
Z_dq  = -1.574*10^5;
M_dw  = -4.302*10^5;
M_dq  = -4.062*10^8;
% Damping Coefficients
Z_w   = -4.746*10^4;
Z_q   = -5024*10^5;
M_w   = 5484*10^5;
M_q   = -2430*10^7;
% Center of Buoyancy
Z_B   = 0.1815;
% Control Input Coefficients
Z_dels= -6850*10^3;
M_dels= -1992*10^5;
Z_delb= -6850*10^3;
M_delb= 1992*10^4;
% Velocity
u0 = 5;

save param