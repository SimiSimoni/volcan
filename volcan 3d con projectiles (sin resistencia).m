% forma simplificada del volcan
[x, y] = meshgrid(-5:0.1:5, -5:0.1:5); 
r = sqrt(x.^2 + y.^2); 
z = exp(-0.1*r.^2) * 5 - 2*exp(-r.^2); 
z = z + 0.07*randn(size(z)); 

% plot
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

% esto es basicamente lo mismo que el documento 'resistencia del aire 3d'
v = [25, 50, 75, 100]; 
g = 9.81; 
h0 = 5400; % altura base
n=10;

colores = [ 
    251 116 168; 
    252 172 57; 
    251 149 1; 
    218 43 66; 
    245 77 233 
    ] / 255; 

for i = 1:n 
    v0 = v(randi(length(v))); % velocidad inicial aleatoria 
    theta = rand * 70 + 10; % angulo de elevacion
    phi = rand * 360; % angulo azimutal 
    
    % componentes de velocidad 
    vx = v0 * cosd(theta) * cosd(phi); 
    vy = v0 * cosd(theta) * sind(phi); 
    vz = v0 * sind(theta); 
    
    % tiempo de vuelo 
    coef = [0.5*g, -vz, -h0]; 
    t_sol = roots(coef); 
    t_vuelo = max(t_sol); 
    
    % trayectoria temporal 
    t = linspace(0, t_vuelo, 200); 
    X = vx * t; 
    Y = vy * t; 
    Z = h0 + vz * t - 0.5 * g * t.^2; 
    
    % color 
    color = colores(mod(i-1, size(colores,1)) + 1, :); 
    % graficar trayectoria 
    plot3(X, Y, Z, '--o', ... 
        'Color', color, ... 
        'MarkerFaceColor', color, ... 
        'MarkerEdgeColor', [0,0,0], ... 
        'LineWidth', 1); 
    
    disp(['Trayectoria ', num2str(i), ... 
        ': v0 = ', num2str(v0), ' m/s, elev = ', num2str(theta, '%.2f'), ...
        '°, azim = ', num2str(phi, '%.2f'), '°']) 
end 
legend(arrayfun(@(i) sprintf('Trayectoria %d', i), 1:n, ...
'UniformOutput', false))
view(45,30)