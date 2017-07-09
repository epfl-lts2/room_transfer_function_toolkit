% Author: Helena Peic Tukuljac, LTS2, EPFL
% Title: "Localization of Multiple Sound Sources in a Room with One Microhone"
% Conference: SPIE, 2017

clc; clear; close all

Lx = 5;
Ly = 5;
Lz = 5;
xx = 0:0.1:(Lx);
yy = 0:0.1:(Ly);
zz = 0:0.1:(Lz);
colormap jet

i = 1;
for x = xx
    j = 1;
    for y = yy
        k = 1;
        for z = zz
            z100(i,j,k)  = cos(pi*x/Lx);
            z010(i,j,k)  = cos(pi*y/Ly);
            z001(i,j,k)  = cos(pi*z/Lz);
            k = k + 1;
        end
        j = j + 1;
    end
    i = i + 1;
end


%% non-axial modes bring no new information, so we observe just the basic modes
figure('units','normalized','outerposition',[0 0 1 1])
set(gcf,'color','w');

subplot(2,3,1)
surf(xx, yy, z100(:,:,1))
xlabel('Lx')
ylabel('Ly')
title('(1,0,0) mode')
axis equal
set(gca,'fontsize', 14)

subplot(2,3,4)
surf(xx, yy, abs(z100(:,:,1)))
xlabel('Lx')
ylabel('Ly')
title('Amplitude of (1,0,0) mode')
axis equal
set(gca,'fontsize', 14)

subplot(2,3,2)
surf(xx, yy, z010(:,:,1))
xlabel('Lx')
ylabel('Ly')
title('(0,1,0) mode')
axis equal
set(gca,'fontsize', 14)

subplot(2,3,5)
surf(xx, yy, abs(z010(:,:,1)))
xlabel('Lx')
ylabel('Ly')
title('Amplitude of (0,1,0) mode')
axis equal
set(gca,'fontsize', 14)

subplot(2,3,3)
surf(xx, yy, z100(:,:,1))
hold on
surf(xx, yy, z010(:,:,1))
xlabel('Lx')
ylabel('Ly')
title('(1,0,0) and (0,1,0) mode')
axis equal
set(gca,'fontsize', 14)

subplot(2,3,6)
surf(xx, yy, abs(z100(:,:,1)))
hold on
surf(xx, yy, abs(z010(:,:,1)))
xlabel('Lx')
ylabel('Ly')
title('Amplitude of (1,0,0) and (0,1,0) mode')
axis equal
set(gca,'fontsize', 14)
