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
xlim([-1.3*ang, 1.3*ang]);
ylim([-1.3*ang, 1.3*ang]);
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

%% determine Terminal set
load cstrMat
verts = [];
for c1 = 1:size(cstr.Xf_cstr, 1)
    for c2 = c1:size(cstr.Xf_cstr, 1)
        verts = [verts cstr.Xf_cstr([c1 c2], :)\cstr.Xf_cstr_b([c1 c2])];
    end
end

verts(find((abs(verts)<1e-6).*(verts~=0))) = 0;

% Depth
vertsZ = unique(verts([1 4], :)', 'rows')';
vertsZ(:, all( ~any( vertsZ), 1 )) = [];
args = angle(vertsZ(1, :) + vertsZ(2, :)*1j);
[~, shuf] = sort(args);
vertsZ = vertsZ(:, shuf);

bZ = boundary(vertsZ(2,:)', vertsZ(1,:)', 0);

% Pitch
vertsT = unique(verts([2 3], :)', 'rows')';
vertsT(:, all( ~any( vertsT), 1 )) = [];
args = angle(vertsT(1, :) + vertsT(2, :)*1j);
[~, shuf] = sort(args);
vertsT = vertsT(:, shuf);

bT = boundary(vertsT(2,:)', vertsT(1,:)', 0);





%% Terminal set
load X_0

figure('Name', "State, Initial & Terminal set")
subplot(2, 1, 1)
hold on
grid on
patch([ang, 0, -ang, -ang, 0, ang], [1, 3, 1, -1, -3, -1], 'red', 'FaceAlpha', 0.2)
patch([-1,1,1,-1].*vertX0(3), [-1,-1,1,1].*vertX0(2), 'magenta', 'FaceAlpha', 0.2) % [-0.5;-0.5;-1;-0.9]
patch(vertsT(2, bT), vertsT(1,bT), 'blue', 'FaceAlpha', 0.5)
xlabel("\theta")
ylabel("$\dot{\theta}$", 'Interpreter', 'latex')
text(5,-1,"$\mathcal{X}$", 'Interpreter', 'latex')
text(-0.2,0.05,"$\mathcal{X}_f$", 'Interpreter', 'latex')
text(-0.5,-0.25,"$\mathcal{X}_0$", 'Interpreter', 'latex')
hold off

subplot(2, 1, 2)
hold on
grid on
patch([-10, 10, 10, -10], [-10, -10, 10, 10], 'red', 'FaceAlpha', 0.2)
patch([-1,1,1,-1].*vertX0(4), [-1,-1,1,1].*vertX0(1), 'magenta', 'FaceAlpha', 0.2) % +-[0.5;0.5;1;0.9]
patch(vertsZ(2, bZ), vertsZ(1,bZ), 'blue', 'FaceAlpha', 0.5)
xlabel("z")
ylabel("$\dot{z}$", 'Interpreter', 'latex')
text(5,-1,"$\mathcal{X}$", 'Interpreter', 'latex')
text(-0.2,0.05,"$\mathcal{X}_f$", 'Interpreter', 'latex')
text(-0.5,-0.25,"$\mathcal{X}_0$", 'Interpreter', 'latex')

%% Reachability
load X_0

figure('Name', "Reachability")
subplot(2, 1, 1)
hold on
grid on
patch([ang, 0, -ang, -ang, 0, ang], [1, 3, 1, -1, -3, -1], 'red', 'FaceAlpha', 0.2)
patch([-1,1,1,-1].*vertX0(3), [-1,-1,1,1].*vertX0(2), 'magenta', 'FaceAlpha', 0.2) % [-0.5;-0.5;-1;-0.9]
patch(vertsT(2, bT), vertsT(1,bT), 'blue', 'FaceAlpha', 0.5)
xlabel("\theta")
ylabel("$\dot{\theta}$", 'Interpreter', 'latex')
text(5,-1,"$\mathcal{X}$", 'Interpreter', 'latex')
text(-0.2,0.05,"$\mathcal{X}_f$", 'Interpreter', 'latex')
text(-0.5,-0.25,"$\mathcal{X}_0$", 'Interpreter', 'latex')
for idx = 1:16
    plot(X_0(3, :, idx), X_0(2, :, idx), 'Color', [0 idx/16 1-idx/16 0.5])
end
hold off

subplot(2, 1, 2)
hold on
grid on
patch([-10, 10, 10, -10], [-10, -10, 10, 10], 'red', 'FaceAlpha', 0.2)
patch([-1,1,1,-1].*vertX0(4), [-1,-1,1,1].*vertX0(1), 'magenta', 'FaceAlpha', 0.2) % +-[0.5;0.5;1;0.9]
patch(vertsZ(2, bZ), vertsZ(1,bZ), 'blue', 'FaceAlpha', 0.5)
xlabel("z")
ylabel("$\dot{z}$", 'Interpreter', 'latex')
text(5,-1,"$\mathcal{X}$", 'Interpreter', 'latex')
text(-0.2,0.05,"$\mathcal{X}_f$", 'Interpreter', 'latex')
text(-0.5,-0.25,"$\mathcal{X}_0$", 'Interpreter', 'latex')
for idx = 1:16
    plot(X_0(4, :, idx), X_0(1, :, idx), 'Color', [0 idx/16 1-idx/16 0.5])
end
hold off

