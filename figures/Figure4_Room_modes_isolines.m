% Author: Helena Peic Tukuljac, LTS2, EPFL
% Title: "Localization of Multiple Sound Sources in a Room with One Microhone"
% Conference: SPIE, 2017

clc; clear; close all

figure('units','normalized','outerposition',[0 0 1 1])
set(gcf,'color','w');
Lx = 5;
Ly = 5;
xx = 0:0.1:Lx;
yy = 0:0.1:Ly;
colormap jet

%% (2,2,0) room mode graph
i = 1;
for x = xx
    j = 1;
    for y = yy
        z1(i,j) = cos(2*pi*x/Lx)* cos(2*pi*y/Ly);
        j = j+1;
    end
    i = i + 1;
end

%% (3,3,0) room mode graph
i = 1;
for x = xx
    j = 1;
    for y = yy
        z2(i,j) = cos(3*pi*x/Lx)* cos(3*pi*y/Ly);
        j = j+1;
    end
    i = i + 1;
end
subplot(2,3,1)
surf(xx,yy,z1)
title('Room mode (2,2,0) in a 5x5x3 room')
xlabel('x')
ylabel('y')
zlabel('$\cos(\frac{n_x \pi}{L_x}x)\cos(\frac{n_y \pi}{L_y}y)\cos(\frac{n_z \pi}{L_z}z)$','Interpreter','Latex')
set(gca,'fontsize', 14)
subplot(2,3,2)
surf(xx,yy,z2)
title('Room mode (3,3,0) in a 5x5x3 room')
xlabel('x')
ylabel('y')
zlabel('$\cos(\frac{n_x \pi}{L_x}x)\cos(\frac{n_y \pi}{L_y}y)\cos(\frac{n_z \pi}{L_z}z)$','Interpreter','Latex')
set(gca,'fontsize', 14)

%% (2,2,0) room mode isolines
subplot(2,3,4)
contour(xx,yy,z1,'Linewidth',2.5)
title('Isolines of (2,2,0) mode')
xlabel('x')
ylabel('y')
set(gca,'fontsize', 14)

%% (3,3,0) room mode isolines
subplot(2,3,5)
contour(xx,yy,z2,'Linewidth',2.5)
title('Isolines of (3,3,0) mode')
xlabel('x')
ylabel('y')
set(gca,'fontsize', 14)

%% (2,2,0) and (3,3,0) isolines
a = [3,6];
subplot(2,3,a)
contour(xx,yy,z1,'Linewidth',2.5)
hold on
contour(xx,yy,z2,'Linewidth',2.5)
title('Isolines of the two modes')
xlabel('x')
ylabel('y')
axis equal
set(gca,'fontsize', 14)