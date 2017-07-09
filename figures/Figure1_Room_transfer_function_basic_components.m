% Author: Helena Peic Tukuljac, LTS2, EPFL
% Title: "Localization of Multiple Sound Sources in a Room with One Microhone"
% Conference: SPIE, 2017

clc; clear; close all
addpath('../room_transfer_function_toolkit_matlab')
load('../data/config.mat')

pos_s = Point3D(1,1,1); % sound source position
pos_m = Point3D(2,2,2); % microphone position

%%  computing the room transfer function and its room modes
N = 3;                     % the order of the room modes
NUMBER_OF_WALLS = 6;
WALL_IMPEDANCES = 0.01*ones(NUMBER_OF_WALLS,1);
eigenfrequency_table = get_eigenfrequency_table(Lx, Ly, Lz, N, TEMPERATURE);
source_room_mode_table = get_room_mode_table (Lx, Ly, Lz, N, pos_s);
damping_factor_table = get_damping_factor_table(Lx, Ly, Lz, ...
    WALL_IMPEDANCES, N, TEMPERATURE);
K_table = get_K_table(Lx, Ly, Lz, N);

receiver_room_mode_table = get_room_mode_table (Lx, Ly, Lz, N, ...
             pos_m);
frequency_vector = 0:0.01:300;
[ Hf, Hf_array ] = transfer_function_fourier(N, ...
    source_room_mode_table, receiver_room_mode_table, ...
    eigenfrequency_table, damping_factor_table, ...
    K_table, TEMPERATURE, frequency_vector);

%% plot the results
figure('units','normalized','outerposition',[0 0 1 1])
set(gcf,'color','w');
subplot(1,2,1)
plot(frequency_vector*2*pi, 20*log10(abs(Hf)), 'k', 'Linewidth',2)
hold on
title('Room Transfer Function')
xlabel('frequency [$\frac{\mathrm{rad}}{\mathrm{s}}$]','Interpreter','LaTex')
ylabel('gain [dB]')
xlim([0 200*2*pi])
ylim([-150 0])
set(gca,'fontsize', 14)

subplot(1,2,2)
title('Room Transfer Functions - Individual Components')
hold on
plot(frequency_vector*2*pi, 20*log10(abs(Hf_array)), 'Linewidth',1)
xlabel('frequency [$\frac{\mathrm{rad}}{\mathrm{s}}$]','Interpreter','LaTex')
ylabel('gain [dB]')
xlim([0 200*2*pi])
ylim([-150 0])
set(gca,'fontsize', 14)