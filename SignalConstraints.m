clear; clc; close all;

%% Input set
figure('Name', "Input set")
hold on
grid on
ang = 15; % ~=deg2rad(15);
patch([ang, -ang, -ang, ang], [ang, ang, -ang, -ang], 'green', 'FaceAlpha', 0.2)
xlabel("\delta_b")
ylabel("\delta_s")
text(0,0,"$\mathcal{U}$", 'Interpreter', 'latex')
hold off

%% State set
figure('Name', "State set")
hold on
grid on
patch([ang, 0, -ang, -ang, 0, ang], [1, 3, 1, -1, -3, -1], 'red', 'FaceAlpha', 0.2)
xlabel("\theta")
ylabel("$\dot{\theta}$", 'Interpreter', 'latex')
text(0,0,"$\mathcal{X}$", 'Interpreter', 'latex')
hold off

%% Terminal set

% z = +- 0.2
% z_dot = +- 0.1
% theta = +- 0.02 rad
% theta_dot = +- 0.005 rad

figure('Name', "State, Initial & Terminal set")
hold on
grid on
patch([ang, 0, -ang, -ang, 0, ang], [1, 3, 1, -1, -3, -1], 'red', 'FaceAlpha', 0.2)
patch([-1,1,1,-1], [-0.5,-0.5,0.5,0.5], 'magenta', 'FaceAlpha', 0.2) % [-0.5;-0.5;-1;-0.9]
patch([-0.15,0.15,0.15,-0.15], [-0.05,-0.05,0.05,0.05], 'blue', 'FaceAlpha', 0.5)
xlabel("\theta")
ylabel("$\dot{\theta}$", 'Interpreter', 'latex')
text(5,-1,"$\mathcal{X}$", 'Interpreter', 'latex')
text(-0.2,0.05,"$\mathcal{X}_f$", 'Interpreter', 'latex')
text(-0.5,-0.25,"$\mathcal{X}_0$", 'Interpreter', 'latex')
hold off

%% Reachability
load X_0

figure('Name', "Reachability")
subplot(2, 1, 1)
hold on
grid on
patch([ang, 0, -ang, -ang, 0, ang], [1, 3, 1, -1, -3, -1], 'red', 'FaceAlpha', 0.2)
patch([-1,1,1,-1], [-0.5,-0.5,0.5,0.5], 'magenta', 'FaceAlpha', 0.2) % [-0.5;-0.5;-1;-0.9]
patch([-0.15,0.15,0.15,-0.15], [-0.05,-0.05,0.05,0.05], 'blue', 'FaceAlpha', 0.5)
xlabel("\theta")
ylabel("$\dot{\theta}$", 'Interpreter', 'latex')
text(5,-1,"$\mathcal{X}$", 'Interpreter', 'latex')
text(-0.2,0.05,"$\mathcal{X}_f$", 'Interpreter', 'latex')
text(-0.5,-0.25,"$\mathcal{X}_0$", 'Interpreter', 'latex')
for idx = 1:16
    plot(X_0(3, :, idx), X_0(2, :, idx), 'Color', [idx/16 idx/16 1-idx/16 0.5])
end
hold off

subplot(2, 1, 2)
hold on
grid on
patch([-10, 10, 10, -10], [-10, -10, 10, 10], 'red', 'FaceAlpha', 0.2)
patch([-0.9,0.9,0.9,-0.9], [-0.5,-0.5,0.5,0.5], 'magenta', 'FaceAlpha', 0.2) % +-[0.5;0.5;1;0.9]
patch([-0.1,0.1,0.1,-0.1], [-0.1,-0.1,0.1,0.1], 'blue', 'FaceAlpha', 0.5)
xlabel("z")
ylabel("$\dot{z}$", 'Interpreter', 'latex')
text(5,-1,"$\mathcal{X}$", 'Interpreter', 'latex')
text(-0.2,0.05,"$\mathcal{X}_f$", 'Interpreter', 'latex')
text(-0.5,-0.25,"$\mathcal{X}_0$", 'Interpreter', 'latex')
for idx = 1:16
    plot(X_0(4, :, idx), X_0(1, :, idx), 'Color', [idx/16 idx/16 1-idx/16 0.5])
end
hold off

