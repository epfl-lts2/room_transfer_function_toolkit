function [position_grid, gound_truth_positions, signal, dictionary] = ...
    build_room_mode_dictionary_and_get_measured_signal(Lx, Ly, Lz, ...
    STEPS_X, STEPS_Y, STEPS_Z, ...
    pos_r, N, WALL_IMPEDANCES, TEMPERATURE)
% position of nodes on the grid
SAMPLING_STEP_X = Lx/STEPS_X;
SAMPLING_STEP_Y = Ly/STEPS_Y;
SAMPLING_STEP_Z = Lz/STEPS_Z;
x_coordinates = SAMPLING_STEP_X:SAMPLING_STEP_X:(Lx-SAMPLING_STEP_X);
y_coordinates = SAMPLING_STEP_Y:SAMPLING_STEP_Y:(Ly-SAMPLING_STEP_Y);
z_coordinates = SAMPLING_STEP_Z:SAMPLING_STEP_Z:(Lz-SAMPLING_STEP_Z);
position_grid = combvec(x_coordinates, y_coordinates, z_coordinates);

% room transfer function data
eigenfrequency_table = get_eigenfrequency_table(Lx, Ly, Lz, N, TEMPERATURE);
receiver_room_mode_table = get_room_mode_table (Lx, Ly, Lz, N, pos_r);
damping_factor_table = get_damping_factor_table(Lx, Ly, Lz, ...
    WALL_IMPEDANCES, N, TEMPERATURE);
K_table = get_K_table(Lx, Ly, Lz, N);
resonant_frequencies = eigenfrequency_table(:);
resonant_frequencies(resonant_frequencies == 0) = [];

% get the measured signal
[signal, gound_truth_positions] = get_test_signal(N, Lx, Ly, Lz, ...
    SAMPLING_STEP_X, SAMPLING_STEP_Y, SAMPLING_STEP_Z, ...
    receiver_room_mode_table, eigenfrequency_table, ...
    damping_factor_table, K_table, TEMPERATURE, resonant_frequencies);

% generate the dictionary
dictionary = [];
for i = 1:length(position_grid)
    source_room_mode_table = get_room_mode_table (Lx, Ly, Lz, N, ...
        Point3D(position_grid(1, i), ...
        position_grid(2, i), ...
        position_grid(3, i)));
    [Hf, ~] = transfer_function_fourier(N, source_room_mode_table, ...
        receiver_room_mode_table, eigenfrequency_table, ...
        damping_factor_table, K_table, TEMPERATURE, resonant_frequencies);
    Hf = abs(Hf);
    Hf = Hf/norm(Hf); % we use unit norm atoms
    dictionary = [dictionary Hf];
end