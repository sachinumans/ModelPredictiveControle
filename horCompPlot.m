load horComp
n=60;
StateNames = ["$\dot{z}$", "$\dot{\theta}$", "$\theta$", "z", "$d$"];
figure('Name', "Estimates", 'windowState', 'maximized')
sp = ["b"; "ro--"; "m.:"];
for idx = 1:4
    subplot(2,2,idx); hold on
    for h = 1:3
    plot(0:sys.Ts:sys.Ts*(n-1), xHor(:, idx, h), sp(h))
    end
    title(StateNames(idx), 'Interpreter', 'latex');
end
legend("20", "40", "60", 'Interpreter', 'latex')
