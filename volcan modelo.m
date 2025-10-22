clear; clc; close all;

[x, y] = meshgrid(-5:0.1:5, -5:0.1:5);

r = sqrt(x.^2 + y.^2);

z = exp(-0.1*r.^2) * 5 - 2*exp(-r.^2); 

z = z + 0.07*randn(size(z));

surf(x*1000, y*1000, z*1000, 'EdgeColor', 'none');
colormap(parula);
axis equal;
xlabel('X');
ylabel('Y');
zlabel('Altura');
title('Modelo 3D de un Volcán');
lighting phong
camlight headlight