clc; clear; close all;

[x, y] = meshgrid(-5:0.1:5, -5:0.1:5);
r = sqrt(x.^2 + y.^2);
z = exp(-0.1*r.^2) * 5 - 2*exp(-r.^2);
z = z + 0.07*randn(size(z));

surf(x*1000, y*1000, z*1000, 'EdgeColor', 'none');
colormap(spring);
axis equal
xlabel('X (m)')
ylabel('Y (m)')
zlabel('Altura (m)')
title('Modelo 3D de un volcán con trayectorias de proyectiles (animadas)')
lighting phong
camlight headlight
hold on

n = 20;                            
v = [50, 75, 100, 125, 150, 175, 200]; 
g = 9.81;
h0 = 4100;      
k = 0.003;
colores = [ ...
    251 116 168;
    252 172 57;
    251 149 1;
    218 43 66;
    245 77 233 ...
] / 255;

for i = 1:n
    v0 = v(randi(length(v)));
    theta = rand * 25 + 20;
    phi = rand * 360;

    vx = v0 * cosd(theta) * cosd(phi);
    vy = v0 * cosd(theta) * sind(phi);
    vz = v0 * sind(theta);

    coef = [0.5*g, -vz, -h0];
    t_sol = roots(coef);
    t_vuelo = max(t_sol);

    f = @(t) h0 + (vz + g/k)/k * (1 - exp(-k*t)) - g*t/k;
    t_vuelo_r = fzero(f, t_vuelo);

    t = linspace(0, t_vuelo_r, 200);
    X = (vx/k) * (1 - exp(-k*t));
    Y = (vy/k) * (1 - exp(-k*t));
    Z = h0 + (vz + g/k)/k * (1 - exp(-k*t)) - g*t/k;

    color = colores(mod(i-1, size(colores,1)) + 1, :);

    p = plot3(X(1), Y(1), Z(1), 'o', ...
        'Color', color, ...
        'MarkerFaceColor', color, ...
        'MarkerEdgeColor', [0,0,0], ...
        'LineWidth', 1);

    for j = 2:length(t)
        set(p, 'XData', X(j), 'YData', Y(j), 'ZData', Z(j)); 
        drawnow limitrate
        pause(0.01); 
    end

    plot3(X, Y, Z, '--', 'Color', color, 'LineWidth', 0.7);

    disp(['Trayectoria ', num2str(i), ...
        ': v0 = ', num2str(v0), ' m/s, elev = ', num2str(theta, '%.2f'), ...
        '°, azim = ', num2str(phi, '%.2f'), '°'])
end

legend(arrayfun(@(i) sprintf('Trayectoria %d', i), 1:n, ...
    'UniformOutput', false))
view(45, 30)