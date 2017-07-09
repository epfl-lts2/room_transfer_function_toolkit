% Author: Helena Peic Tukuljac, LTS2, EPFL
% Title: "Localization of Multiple Sound Sources in a Room with One Microhone"
% Conference: SPIE, 2017

clc; clear; close all
addpath('../room_transfer_function_toolkit_matlab')
load('../data/config.mat')

%%  DRAWING EXPERIMENTAL SETUP
N = 3;                     % how many room modes to calculate
NUMBER_OF_WALLS = 6;
WALL_IMPEDANCES = 0.01*ones(NUMBER_OF_WALLS,1);
Lx = 5;
Ly = 7;
Lz = 2.5;

pos_s = Point3D(1,1,1);
pos_mt = [];
new_position = Point3D(1.3430,5.6611,1.4929);
pos_mt = [pos_mt ; new_position];
new_position = Point3D(Lx-1.3430,5.6611,1.4929);
pos_mt = [pos_mt ; new_position];

%% TRANSFER FUNCTIONS + GENERATING AND SAVING THE MEASUREMENTS
% generate data once and store it in a table to optimize
% if we need data for nx=ny=nz=0, we will index with (1,1,1)
eigenfrequency_table = get_eigenfrequency_table(Lx, Ly, Lz, N, TEMPERATURE);
source_room_mode_table = get_room_mode_table (Lx, Ly, Lz, N, pos_s);
damping_factor_table = get_damping_factor_table(Lx, Ly, Lz, ...
    WALL_IMPEDANCES, N, TEMPERATURE);
K_table = get_K_table(Lx, Ly, Lz, N);

col = ['r'; 'g'];
figure('units','normalized','outerposition',[0 0 1 1])
set(gcf,'color','w');
title('The ambiguity of the room transfer functions')
xlabel('frequency [$\frac{\mathrm{rad}}{\mathrm{s}}$]','Interpreter','LaTex')
ylabel('real part of the RTF')
zlabel('imaginary part of the RTF')
xlim([0 800])
view([-17.5,20])
set(gca,'fontsize', 16)
for i = 1:2
    receiver_room_mode_table = get_room_mode_table (Lx, Ly, Lz, N, ...
                 pos_mt(i));
    frequency_vector = 0:0.01:300;
    [ Hf, Hf_array ] = transfer_function_fourier(N, ...
        source_room_mode_table, receiver_room_mode_table, ...
        eigenfrequency_table, damping_factor_table, ...
        K_table, TEMPERATURE, frequency_vector);

    hold on
    
    plot3(frequency_vector'*2*pi, real(Hf_array(:,1)), ...
        imag(Hf_array(:,1)), col(i), 'Linewidth',3)
    plot3(frequency_vector'*2*pi, real(Hf_array(:,2)), ...
        imag(Hf_array(:,2)), col(i), 'Linewidth',3)
    plot3(frequency_vector'*2*pi, real(Hf_array(:,3)), ...
        imag(Hf_array(:,3)), col(i), 'Linewidth',3)
end
legend('Position (x,y,z)', 'Position (Lx-x,y,z)')
set(gca,'fontsize', 16)