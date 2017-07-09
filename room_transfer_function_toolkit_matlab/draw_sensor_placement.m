function [ ] = draw_sensor_placement( Lx, Ly, Lz, pos_s, pos_mx, pos_my, pos_mz, ...
    SPATIAL_SAMPLING_STEP, col )
% Illustration of placement of microphones and sound sources in a room. 

% Input:
% Lx - room width
% Ly - room depth 
% Lz - room height
% pos_s, _mt, _et - position of the source and training and evaluation
% microphones

% 1st step: draw the room
addpath('../room_transfer_function_toolkit_matlab/pic')
x=[
 0 Lx Lx 0 0 % bottom
 0 Lx Lx 0 0 % top
 0 0 0 0 0 % left
 Lx Lx Lx Lx Lx % right
];
y=[
 0 0 Ly Ly 0
 0 0 Ly Ly 0
 0 Ly Ly 0 0
 0 Ly Ly 0 0
];
z=[
 0 0 0 0 0
 Lz Lz Lz Lz Lz
 0 0 Lz Lz 0
 0 0 Lz Lz 0
];

line(x',y',z','color',[0 0 0]);
hold on
view(3);
xlabel('Lx (width)');
ylabel('Ly (depth)');
zlabel('Lz (height)');
axis equal
img = imread('pic\floor.jpg');           
hold on;                             
image([Lx 0 0],[Ly 0 0],img); 

img = imread('pic\wall.jpg');
xImage = [0 Lx; 0 Lx];
yImage = [Ly Ly; Ly Ly]; 
zImage = [0 0; Lz Lz];
surf(xImage,yImage,zImage,...
     'CData',img,...
     'FaceColor','texturemap');
xImage = [Lx Lx; Lx Lx];  
yImage = [0 Ly; 0 Ly];  
zImage = [0 0; Lz Lz];  
surf(xImage,yImage,zImage,...
     'CData',img,...
     'FaceColor','texturemap');

hold on

% 2nd step: draw the sensors
[xs, ys, zs] = get_coordinates(pos_s);
h(1) = plot3(xs,ys,zs,'og','Markersize', 10, 'MarkerEdgeColor','k', ...
                'MarkerFaceColor',[1 1 1]);
            
% 3rd step: draw the microphones
for i = 1:length(pos_mx)
    [xmt, ymt, zmt] = get_coordinates(pos_mx(i));
    h(2) = plot3(xmt, ymt, zmt,'o','Markersize', 7, 'MarkerEdgeColor','k', ...
                'MarkerFaceColor',col(1));
end
for i = 1:length(pos_my)
    [xmt, ymt, zmt] = get_coordinates(pos_my(i));
    h(2) = plot3(xmt, ymt, zmt,'o','Markersize', 7, 'MarkerEdgeColor','k', ...
                'MarkerFaceColor',col(2));
end
for i = 1:length(pos_mz)
    [xmt, ymt, zmt] = get_coordinates(pos_mz(i));
    h(2) = plot3(xmt, ymt, zmt,'o','Markersize', 7, 'MarkerEdgeColor','k', ...
                'MarkerFaceColor',col(3));
end
legend(h, 'microphone','sound source','Location','northeast')
title('The experimental setting')

if (SPATIAL_SAMPLING_STEP ~= 0) % draw the lattice
    draw_lattice(Lx, Ly, Lz, SPATIAL_SAMPLING_STEP);
end 
az = 335;
el = 45;
view(az, el);
end