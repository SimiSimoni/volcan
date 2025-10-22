n = 5; 
v = [25, 50, 75,100]; 
g = 9.81;
h0 = 5400;

rosa = [251, 116, 168] / 255; 
dorado = [252, 172, 57] / 255;
naranja=[251, 149, 1] / 255;
rosam=[218, 43, 66]/255;
morado=[245,77,233]/255;

colores = [rosa; dorado; naranja; rosam; morado];

figure
hold on
grid on

for i = 1:n
    v0 = v(randi(length(v)));
    angulo = rand * 70 + 10;

    vx = v0 * cosd(angulo);
    vy = v0 * sind(angulo);

    coef = [0.5*g, -vy, -h0];
    t_sol = roots(coef);
    t_vuelo = max(t_sol);

    t = linspace(0, t_vuelo, 200);
    x = vx * t;
    y = h0 + vy * t - 0.5 * g * t.^2;

    color = colores(mod(i-1, size(colores,1)) + 1, :);

    plot(x, y, 'LineStyle', '--', 'Marker', 'o', ...
        'MarkerFaceColor', color, ...
        'MarkerEdgeColor', [0, 0, 0], ...
        'Color', color, ...
        'LineWidth', 1.2)

    disp(['Trayectoria ', num2str(i), ': v0 = ', num2str(v0), ' m/s, ángulo = ', num2str(angulo, '%.2f'), '°'])
end

xlabel('Distancia horizontal (m)')
ylabel('Altura (m)')
title('Tiro parabólico desde un volcán con diferentes trayectorias')
legend(arrayfun(@(i) sprintf('Trayectoria %d', i), 1:n, 'UniformOutput', false))
axis tight