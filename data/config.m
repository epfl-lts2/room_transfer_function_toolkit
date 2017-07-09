delete('config.mat')

clear all

Lx = 3.9; Ly = 8.15; Lz = 3.35;     % room dimensions
REVERBERATON_TIME_60 = 1.25;        % for the given room
TEMPERATURE = 25;                   % in the given room

save('config.mat')