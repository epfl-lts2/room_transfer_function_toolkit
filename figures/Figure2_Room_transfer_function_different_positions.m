% Author: Helena Peic Tukuljac, LTS2, EPFL
% Title: "Localization of Multiple Sound Sources in a Room with One Microhone"
% Conference: SPIE, 2017

clc; clear; close all
addpath('../room_transfer_function_toolkit_matlab')
load('../data/config.mat')
col = ['r';'g';'b';'k';'y'];

pos_mt = [];
new_position = Point3D(1.3430,5.6611,1.4929);
pos_mt = [pos_mt ; new_position];
new_position = Point3D(Lx-1.3430,5.6611,1.4929);
pos_mt = [pos_mt ; new_position];
new_position = Point3D(1.3430,Ly-5.6611,1.4929);
pos_mt = [pos_mt ; new_position];
pos_s = Point3D(1, 1, 1);

N = 3;                     % the order of the room modes
NUMBER_OF_WALLS = 6;
WALL_IMPEDANCES = 0.01*ones(NUMBER_OF_WALLS,1);

eigenfrequency_table = get_eigenfrequency_table(Lx, Ly, Lz, N, TEMPERATURE);
resonant_frequencies = eigenfrequency_table(:);
receiver_room_mode_table = get_room_mode_table (Lx, Ly, Lz, N, pos_s);
damping_factor_table = get_damping_factor_table(Lx, Ly, Lz, ...
    WALL_IMPEDANCES, N, TEMPERATURE);
K_table = get_K_table(Lx, Ly, Lz, N);

LOWPASS_FILTER_BANDWIDTH = 50;
RECEIVER_NUMBER = 46; % dummy parameter (just to determine the denisty of the grid)
[~, ~, ~, spatial_sampling_step] = get_positions ...
    (Lx, Ly, Lz, TEMPERATURE, LOWPASS_FILTER_BANDWIDTH, RECEIVER_NUMBER);

figure('units','normalized','outerposition',[0 0 1 1])
set(gcf,'color','w');
subplot(2,3,[1,4])
draw_sensor_placement(Lx, Ly, Lz, pos_s, pos_mt(1), pos_mt(2), ...
    pos_mt(3), spatial_sampling_step, col);
set(gca,'fontsize', 16)

FREQUENCY_MIN = 0; FREQUENCY_MAX = 500; FREQUENCY_STEP = 0.01;
freq = FREQUENCY_MIN:FREQUENCY_STEP:FREQUENCY_MAX;
SCHROEDER_FREQUENCY = 217;

for i = 1:length(pos_mt)
    source_room_mode_table = get_room_mode_table (Lx, Ly, Lz, N, ...
        pos_mt(i));
    %% The continuous function (amplitude and phase)
    [Hf, ~] = transfer_function_fourier(N, source_room_mode_table, ...
        receiver_room_mode_table, eigenfrequency_table, ...
        damping_factor_table, K_table, TEMPERATURE, ...
        freq);
    subplot(2,3,2)    
    plot(2*pi*freq,20*log10(abs(Hf)), col(i),'LineWidth',1)
    title('Amplitude - Transfer functions')
    str = 'frequency $[\frac{\textrm{rad}}{\textrm{s}}]$';
    xlabel(str, 'Interpreter','latex')
    ylabel('$|\mathrm{H}|$ [dB]', 'Interpreter','latex')
    ylim([-70 0])
    xlim([0 SCHROEDER_FREQUENCY*2*pi])
    grid on
    hold on
    set(gca,'fontsize', 14)
    subplot(2,3,3)        
    plot(2*pi*freq, angle(Hf)/pi, col(i),'LineWidth',1)
    title('Phase - Transfer functions')
    str = 'frequency $[\frac{\textrm{rad}}{\textrm{s}}]$';
    xlabel(str, 'Interpreter','latex')
    ylabel('$$\times \pi[\mathrm{rad}]$$', 'Interpreter','latex')
    xlim([0 SCHROEDER_FREQUENCY*2*pi])
    grid on
    hold on
    set(gca,'fontsize', 15)
    
    
    %% The points (amplitude and phase)
    [Hf, ~] = transfer_function_fourier(N, source_room_mode_table, ...
        receiver_room_mode_table, eigenfrequency_table, ...
        damping_factor_table, K_table, TEMPERATURE, resonant_frequencies); 
    subplot(2,3,5)    
    plot(2*pi*resonant_frequencies,20*log10(abs(Hf)), strcat('.', col(i)), 'Markersize', 20)
    title('Amplitude - Values at the resonant frequencies')
    str = 'frequency $[\frac{\textrm{rad}}{\textrm{s}}]$';
    xlabel(str, 'Interpreter','latex')
    ylabel('$|\mathrm{H}|$ [dB]', 'Interpreter','latex')
    ylim([-70 0])
    xlim([0 SCHROEDER_FREQUENCY*2*pi])
    grid on
    hold on
    set(gca,'fontsize', 14)
    subplot(2,3,6)
    plot(2*pi*resonant_frequencies, angle(Hf)/pi, strcat('.', col(i)), 'Markersize', 20)
    title('Phase - Values at the resonant frequencies')
    str = 'frequency $[\frac{\textrm{rad}}{\textrm{s}}]$';
    xlabel(str, 'Interpreter','latex')
    ylabel('$$\times \pi[\mathrm{rad}]$$', 'Interpreter','latex')
    xlim([0 SCHROEDER_FREQUENCY*2*pi])
    grid on
    hold on 
    set(gca,'fontsize', 14)
end