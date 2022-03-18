clear; clc; close all;

%% Input set
figure('Name', "Input set")
hold on
grid on
ang = 0.25; % ~=deg2rad(15);
patch([ang, -ang, -ang, ang], [ang, ang, -ang, -ang], 'green', 'FaceAlpha', 0.2)
xlabel("\delta_b")
ylabel("\delta_s")
text(0,0,"$\mathcal{U}$", 'Interpreter', 'latex')
hold off

%% State set
figure('Name', "State set")
hold on
grid on
patch([ang, 0, -ang, -ang, 0, ang], [0.025, 0.05, 0.025, -0.025, -0.05, -0.025], 'red', 'FaceAlpha', 0.2)
xlabel("\theta")
ylabel("$\dot{\theta}$", 'Interpreter', 'latex')
text(0,0,"$\mathcal{X}$", 'Interpreter', 'latex')
hold off

%% Terminal set

% z = +- 0.2
% z_dot = +- 0.1
% theta = +- 0.02 rad
% theta_dot = +- 0.005 rad
