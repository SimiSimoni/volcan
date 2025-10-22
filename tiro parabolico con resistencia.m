clc; clear; close all;

g = 9.81;
h0 = 0;
v0 = 35.355;
angulo = 45;
k = 0.02; 

rosa = [251, 116, 168] / 255; 
dorado = [252, 172, 57] / 255;

vx = v0 * cosd(angulo);
vy = v0 * sind(angulo);

coef = [0.5*g, -vy, -h0];
t_sol = roots(coef);
t_vuelo = max(t_sol);
t1 = linspace(0, t_vuelo, 200);

x1 = vx * t1;
y1 = h0 + vy * t1 - 0.5 * g * t1.^2;

f = @(t) h0 + (vy + g/k)/k * (1 - exp(-k * t)) - g * t / k;
t_vuelo_r = fzero(f, t_vuelo); 

t2 = linspace(0, t_vuelo_r, 200);
vx_r = vx * exp(-k * t2);
vy_r = (vy + g/k) * exp(-k * t2) - g/k;
x2 = (vx / k) * (1 - exp(-k * t2));
y2 = h0 + (vy + g/k)/k * (1 - exp(-k * t2)) - g * t2 / k;

figure
grid on
hold on
plot(x1, y1, '--o', 'Color', rosa, 'MarkerFaceColor', rosa, 'MarkerEdgeColor', [0 0 0],'LineWidth',1.2)
plot(x2, y2, '--o', 'Color', dorado, 'MarkerFaceColor', dorado, 'MarkerEdgeColor', [0 0 0],'LineWidth',1.2)
xlabel('Distancia horizontal (m)')
ylabel('Altura (m)')
title('Tiro parabólico desde un volcán (45°)')
legend('Sin resistencia del aire', 'Con resistencia del aire')
axis tight