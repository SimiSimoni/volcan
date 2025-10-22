clc; clear; close all;

g = 9.81;
h0 = 0;
v0 = 50;       % velocidad inicial
theta = 45;    % angulo de elevación
phi = 30;      % angulo azimutal
k = 0.02;      % coeficiente de resistencia lineal

% colores
rosa = [251, 116, 168] / 255;
dorado = [252, 172, 57] / 255;

% componentes iniciales de velocidad
vx0 = v0 * cosd(theta) * cosd(phi);
vy0 = v0 * cosd(theta) * sind(phi);
vz0 = v0 * sind(theta);

% tiempo de vuelo sin resistencia (para estimar)
coef = [0.5*g, -vz0, -h0];
t_sol = roots(coef);
t_vuelo = max(t_sol);

% trayectoria sin resistencia
t1 = linspace(0, t_vuelo, 200);
X1 = vx0 * t1;
Y1 = vy0 * t1;
Z1 = h0 + vz0 * t1 - 0.5 * g * t1.^2;


% grafica 3D
figure
grid on
hold on
plot3(X1, Y1, Z1, '--o', 'Color', rosa, 'MarkerFaceColor', rosa, ...
    'MarkerEdgeColor', [0 0 0], 'LineWidth', 1.2)

xlabel('X (m)')
ylabel('Y (m)')
zlabel('Altura (m)')
title('Tiro parabólico 3D sin resistencia del aire')
legend('Sin resistencia')
axis equal
view(45,30)