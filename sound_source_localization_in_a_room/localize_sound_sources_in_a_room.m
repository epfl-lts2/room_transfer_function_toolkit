close all; clc

addpath('../room_transfer_function_toolkit_matlab');
addpath('build_room_mode_dictionary');
addpath('reconstruct_locations_of_sources');

% Input data
Lx = 4; Ly = 7; Lz = 3;
STEPS_X = 15; STEPS_Y = 25; STEPS_Z = 15;
TEMPERATURE = 25;
NUMBER_OF_WALLS = 6;
WALL_IMPEDANCES = 0.01*ones(NUMBER_OF_WALLS, 1);
% tunable parameter- up to which order of room modes to observe the data
N = 3;

% receiver's position
pos_r = Point3D(7*Lx/STEPS_X, 3*Ly/STEPS_Y, 5*Lz/STEPS_Z);

%% build the full dictionary
tic
disp('Started generating room mode dictionary...')
[position_grid, gound_truth_positions, signal, dictionary] = ...
    build_room_mode_dictionary_and_get_measured_signal(Lx, Ly, Lz, ...
    STEPS_X, STEPS_Y, STEPS_Z, ...
    pos_r, N, WALL_IMPEDANCES, TEMPERATURE);
elapsed_time = toc;

disp(['It took: ', num2str(elapsed_time), 's to create the dictionary.'])

%% try different subsampling schemes
termination = true;
i = 0;
tic
while termination 
    i = i + 1;
    disp('----------------------------------------------------------')
    disp(['Iteration: ', num2str(i), '.'])    

    DICTIONARY_HEIGHT = ceil(size(dictionary,1)); % can be changed to speed up
    DICTIONARY_WIDGHT = ceil(size(position_grid, 2)/2);
    Srf = datasample(eye(size(dictionary,1)), DICTIONARY_HEIGHT, 'Replace', false);
    Ssp = datasample(eye(size(dictionary,2)), DICTIONARY_WIDGHT, 2, 'Replace', false);
    undersampled_dictionary = Srf*dictionary*Ssp;
    selected_positions = position_grid*Ssp;
    undersampled_signal = Srf*signal;
    
    % try to recover the locations
    [reconstructed_indices, reconstruction_error, residual_norm]  = ...
        reconstruct_locations(undersampled_dictionary, undersampled_signal, ...
        length(gound_truth_positions));
    if((residual_norm < 0.0001) && ...
            ~isnan(sum(sum(reconstructed_indices))) && ...
            ~isnan(reconstruction_error))
        print_results(gound_truth_positions, reconstructed_indices, ...
            selected_positions, pos_r, Lx, Ly, Lz);
        disp('Reconstruction error')
        disp(get_reconstruction_error(gound_truth_positions, ...
            selected_positions(:,reconstructed_indices)))
        dictionary_benchmarking(reconstructed_indices, undersampled_dictionary);
        termination = false;
    end
end
save('winning_spatial_subsampling.mat','Ssp')
elapsed_time = toc;
disp(['It took: ', num2str(elapsed_time), 's to localize the sources.'])