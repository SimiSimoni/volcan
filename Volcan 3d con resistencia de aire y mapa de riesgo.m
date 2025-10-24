clc; clear; close all;

% volcan
[x, y] = meshgrid(-5:0.1:5, -5:0.1:5); 
r = sqrt(x.^2 + y.^2); 
z = exp(-0.1*r.^2) * 5 - 2*exp(-r.^2); 
z = z + 0.07*randn(size(z)); 

surf(x*1000, y*1000, z*1000, 'EdgeColor', 'none'); 
colormap(parula); 
axis equal 
xlabel('X (m)') 
ylabel('Y (m)') 
zlabel('Altura (m)') 
title('Modelo 3D de un volcán con trayectorias de proyectiles') 
lighting phong 
camlight headlight 
hold on 

% proyectiles 3d
n = 50; % número de proyectiles
v = [25, 50, 75, 100,125,150,175,200]; % velocidades posibles
g = 9.81; 
h0 = 5400; % altura del volcán
k = 0.02; % coeficiente de resistencia del aire

colores = [ 
    251 116 168; 
    252 172 57; 
    251 149 1; 
    218 43 66; 
    245 77 233 
    ] / 255; 

distancias = zeros(1,n); % para guardar distancias finales

for i = 1:n 
    v0 = v(randi(length(v))); % velocidad inicial aleatoria 
    theta = rand * 70 + 10; % ángulo de elevación
    phi = rand * 360; % ángulo azimutal 
    
    % componentes de velocidad 
    vx = v0 * cosd(theta) * cosd(phi); 
    vy = v0 * cosd(theta) * sind(phi); 
    vz = v0 * sind(theta); 
    
    % tiempo de vuelo
    coef = [0.5*g, -vz, -h0]; 
    t_sol = roots(coef); 
    t_vuelo = max(t_sol); 

    f = @(t) h0 + (vz + g/k)/k * (1 - exp(-k*t)) - g*t/k;
    t_vuelo_r = fzero(f, t_vuelo); 
    
    % trayectoria temporal 
    t = linspace(0, t_vuelo_r, 200); 
    X= (vx/k) * (1 - exp(-k*t));
    Y = (vy/k) * (1 - exp(-k*t));
    Z = h0 + (vz + g/k)/k * (1 - exp(-k*t)) - g*t/k;
    
    % guardar distancia final
    distancias(i) = sqrt(X(end)^2 + Y(end)^2);
    
    % color
    color = colores(mod(i-1, size(colores,1)) + 1, :); 
    % graficar trayectoria 
    plot3(X, Y, Z, '--o', ... 
        'Color', color, ... 
        'MarkerFaceColor', color, ... 
        'MarkerEdgeColor', [0,0,0], ... 
        'LineWidth', 0.5); 
    
    disp(['Trayectoria ', num2str(i), ...
        ': v0 = ', num2str(v0), ' m/s, elev = ', num2str(theta, '%.2f'), ...
        '°, azim = ', num2str(phi, '%.2f'), '°']); 
end 

% radio anillos
dist_ordenadas = sort(distancias);

R1 = dist_ordenadas( max(1, round(0.5*n)) );   % 50% de impactos
R2 = dist_ordenadas( max(1, round(0.8*n)) );   % 80%
R3 = dist_ordenadas( max(1, round(0.95*n)) );  % 95%
R4 = max(distancias);                           % distancia máxima ~0 probabilidad

anillo_radios = [R1, R2, R3, R4];
% anillo riesgo
anillo_colores = [1 0 0; 1 0.5 0; 1 1 0; 0 1 0]; % RGB para rojo naranja amarillo verde

% radio de anillos
R1 = 0.5 * max(distancias);    % 50% del max
R2 = 0.75 * max(distancias);   % 75% del max
R3 = 0.95 * max(distancias);   % 95% del max
R_max = 1.4 * max(distancias); % verde: expande más allá

radios_internos = [0, R1, R2, R3];
radios_externos = [R1, R2, R3, R_max];

theta_circ = linspace(0, 2*pi, 200);

for j = 1:4
    x_patch = [radios_internos(j)*cos(theta_circ), fliplr(radios_externos(j)*cos(theta_circ))];
    y_patch = [radios_internos(j)*sin(theta_circ), fliplr(radios_externos(j)*sin(theta_circ))];
    z_patch = zeros(size(x_patch))+5000; % puede subirse para que quede sobre el volcán

    patch(x_patch, y_patch, z_patch, anillo_colores(j,:), ...
          'FaceAlpha', 0.5, 'EdgeColor', [0 0 0], 'LineWidth', 1.2);
end

legend(arrayfun(@(i) sprintf('Trayectoria %d', i), 1:n, 'UniformOutput', false))
view(45,30)