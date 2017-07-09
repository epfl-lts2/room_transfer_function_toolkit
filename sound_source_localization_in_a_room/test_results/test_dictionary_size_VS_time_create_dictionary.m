% All of the evaluation methods are based on the Monte Carlo method

addpath('../../room_transfer_function_toolkit_matlab');
addpath('../build_room_mode_dictionary');
addpath('../reconstruct_locations_of_sources');

% All the times will be measured after the dictionary has been created
% We can also express the time needed for creating a citionary.
close all
figure('units','normalized','outerposition',[0 0 1 1])
% Input data
Lx = 4; Ly = 7; Lz = 3;
TEMPERATURE = 25;
NUMBER_OF_WALLS = 6;
WALL_IMPEDANCES = 0.01*ones(NUMBER_OF_WALLS, 1);
% receiver's position
pos_r = Point3D(7*Lx/STEPS_X, 3*Ly/STEPS_Y, 5*Lz/STEPS_Z);
% tunable parameter- up to which order of room modes to observe the data
N = 3;
STEP_ARRAY = [10, 15, 20, 25, 30, 35, 40];
results = [];
for i = 1:length(STEP_ARRAY)
    accumulator = 0;
    STEPS_X = STEP_ARRAY(i); 
    STEPS_Y = STEP_ARRAY(i); 
    STEPS_Z = STEP_ARRAY(i);    
    % run Monte Carlo tests
    %% build the full dictionary
    tic
    disp('Started generating room mode dictionary...')
    [position_grid, gound_truth_positions, signal, dictionary] = ...
        build_room_mode_dictionary_and_get_measured_signal(Lx, Ly, Lz, ...
        STEPS_X, STEPS_Y, STEPS_Z, ...
        pos_r, N, WALL_IMPEDANCES, TEMPERATURE);
    size(dictionary)
    elapsed_time = toc;
    %% save the result
    results = [results elapsed_time];
end

% results for 63 modes
plot(STEP_ARRAY, results)
xlabel('Number of steps over each axis')
ylabel('Elapsed time [s]')

save('dictionary_size_VS_time_create_dictionary_data.mat')
saveas(gcf,'dictionary_size_VS_time_create_dictionary.png')
close all
