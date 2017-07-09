% Author: Helena Peic Tukuljac, LTS2, EPFL
% Title: "Localization of Multiple Sound Sources in a Room with One Microhone"
% Conference: SPIE, 2017

clc; close all; clear all

figure('units','normalized','outerposition',[0 0 1 1])
set(gcf,'color','w');
addpath('../room_transfer_function_toolkit_matlab')
%% an example of a eigenvalue lattice
subplot(2,4,1)
xnodes = 3;
ynodes = 3;
znodes = 3;

for k = 0:znodes
     for j = 0:ynodes
          for i = 0:xnodes
              if(i||j||k)
                  scatter3(i,j,k,'filled','MarkerEdgeColor',[0 0 0],...
                  'MarkerFaceColor',[0 0 0])
              end
              hold on
          end
     end
end
   
h = mArrow3([0 0 0],[0 0 1], 'facealpha', 0.5, 'color', 'r', 'stemWidth', 0.02);
h = mArrow3([0 0 0],[0 1 1], 'facealpha', 0.5, 'color', 'g', 'stemWidth', 0.02); 
h = mArrow3([0 0 0],[1 1 1], 'facealpha', 0.5, 'color', 'b', 'stemWidth', 0.02); 
view([-17.5,20])
title('Eigenvalue grid')
set(gca, 'XTick', [])
set(gca, 'YTick', [])
set(gca, 'ZTick', [])
xlabel('$k_x$','Interpreter','Latex')
ylabel('$k_y$','Interpreter','Latex')
zlabel('$k_z$','Interpreter','Latex')
xlim([0 3])
ylim([0 3])
zlim([0 3])
set(gca,'fontsize', 14)

%% an example of axial mode
subplot(2,4,2)
h = mArrow3([0 0 0],[0 0 1], 'facealpha', 0.5, 'color', 'r', 'stemWidth', 0.02);
h = mArrow3([0 0 0],[0 0 -1], 'facealpha', 0.5, 'color', 'r', 'stemWidth', 0.02);
hold on
scatter3(0,0,0,'filled','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 1 1])
view([-17.5,20])
title('Axial mode')
set(gca, 'XTick', [])
set(gca, 'YTick', [])
set(gca, 'ZTick', [])
xlabel('$k_x$','Interpreter','Latex')
ylabel('$k_y$','Interpreter','Latex')
zlabel('$k_z$','Interpreter','Latex')
xlim([-1 1])
ylim([-1 1])
zlim([-1 1])
set(gca,'fontsize', 14)

%% an example of tangential mode
subplot(2,4,3)
h = mArrow3([0 0 0],[0 1 1], 'facealpha', 0.5, 'color', 'g', 'stemWidth', 0.02);
h = mArrow3([0 0 0],[0 -1 1], 'facealpha', 0.5, 'color', 'g', 'stemWidth', 0.02);
h = mArrow3([0 0 0],[0 -1 -1], 'facealpha', 0.5, 'color', 'g', 'stemWidth', 0.02);
h = mArrow3([0 0 0],[0 1 -1], 'facealpha', 0.5, 'color', 'g', 'stemWidth', 0.02);
hold on
scatter3(0,0,0,'filled','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 1 1])
view([-17.5,20])
title('Tangential mode')
set(gca, 'XTick', [])
set(gca, 'YTick', [])
set(gca, 'ZTick', [])
xlabel('$k_x$','Interpreter','Latex')
ylabel('$k_y$','Interpreter','Latex')
zlabel('$k_z$','Interpreter','Latex')
xlim([-1 1])
ylim([-1 1])
zlim([-1 1])
set(gca,'fontsize', 14)

%% an example of oblique mode
subplot(2,4,4)
h = mArrow3([0 0 0],[1 1 1], 'facealpha', 0.5, 'color', 'b', 'stemWidth', 0.02);
h = mArrow3([0 0 0],[1 1 -1], 'facealpha', 0.5, 'color', 'b', 'stemWidth', 0.02);
h = mArrow3([0 0 0],[1 -1 1], 'facealpha', 0.5, 'color', 'b', 'stemWidth', 0.02);
h = mArrow3([0 0 0],[1 -1 -1], 'facealpha', 0.5, 'color', 'b', 'stemWidth', 0.02);

h = mArrow3([0 0 0],[-1 -1 -1], 'facealpha', 0.5, 'color', 'b', 'stemWidth', 0.02);
h = mArrow3([0 0 0],[-1 1 1], 'facealpha', 0.5, 'color', 'b', 'stemWidth', 0.02);
h = mArrow3([0 0 0],[-1 -1 1], 'facealpha', 0.5, 'color', 'b', 'stemWidth', 0.02);
h = mArrow3([0 0 0],[-1 1 -1], 'facealpha', 0.5, 'color', 'b', 'stemWidth', 0.02);
hold on
scatter3(0,0,0,'filled','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 1 1])
view([-17.5,20])
title('Oblique mode')
set(gca, 'XTick', [])
set(gca, 'YTick', [])
set(gca, 'ZTick', [])
xlabel('$k_x$','Interpreter','Latex')
ylabel('$k_y$','Interpreter','Latex')
zlabel('$k_z$','Interpreter','Latex')
xlim([-1 1])
ylim([-1 1])
zlim([-1 1])
set(gca,'fontsize', 14)
