% All of the evaluation methods are based on the Monte Carlo method
% We fix the subsampling over sound source positon to 1/2 and vary the
% subsampling over frequencies

NUMBER_OF_TESTS = 100; % change to 100 once it is working
close all; clc

addpath('../../room_transfer_function_toolkit_matlab');
addpath('../build_room_mode_dictionary');
addpath('../reconstruct_locations_of_sources');
addpath('../')

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
termination = true;
i = 0;
tic
rf_vector = 11:63;
results = zeros(length(rf_vector),1);   % reconstruction error
results_i = zeros(length(rf_vector),1); % iteration number
results_t = zeros(length(rf_vector),1); % iteration number
results_f = zeros(length(rf_vector),1); % failure counter
for rf = rf_vector
    success_counter = 0;
    for test_number = 1:NUMBER_OF_TESTS
        disp(['Number of resonant frequencies taken into account: ', num2str(rf), '.']) 
        termination = true;
        tic
        while termination 
            i = i + 1;
            disp('----------------------------------------------------------')
            disp(['Iteration: ', num2str(i), '.'])    

            DICTIONARY_HEIGHT = rf; % can be changed to speed up
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
                reconstruction_error = get_reconstruction_error(gound_truth_positions, ...
                    selected_positions(:,reconstructed_indices));
                termination = false;
                results_i(rf-10) = results_i(rf-10) + i;
                results_t(rf-10) = results_t(rf-10) + toc;
                success_counter = success_counter + 1;
            elseif (i >= 300)
                reconstruction_error = get_reconstruction_error(gound_truth_positions, ...
                    selected_positions(:,reconstructed_indices));
                termination = false;
                results_f(rf-10) = results_f(rf-10) + 1;
            end
        end
        results(rf-10) = results(rf-10) + reconstruction_error;
        i = 0;
    end
    results_i(rf-10) = results_i(rf-10)/success_counter;
    results_t(rf-10) = results_t(rf-10)/success_counter;
end

results = results/NUMBER_OF_TESTS;


elapsed_time = toc;
disp(['It took: ', num2str(elapsed_time), 's to localize the sources.'])
figure('units','normalized','outerposition',[0 0 1 1])
plot(rf_vector, results)
xlabel('Subsampling size')
ylabel('Reconstruction error')
ylim([0 inf])
title('Average reconsruction error for different frequency subsampling')
set(gca,'fontsize', 12)
saveas(gcf,'subsampling_over_resonant_frequencies_convergence.png')
close all

figure('units','normalized','outerposition',[0 0 1 1])
plot(rf_vector, results_i)
xlabel('Subsampling size')
ylabel('Number of iterations')
ylim([0 inf])
title('Average number of iterations for successful reconstruction for different frequency subsampling')
set(gca,'fontsize', 12)
saveas(gcf,'subsampling_over_resonant_frequencies_iterations.png')
close all

figure('units','normalized','outerposition',[0 0 1 1])
plot(rf_vector, results_f)
xlabel('Subsampling size')
ylabel('Number of failures')
ylim([0 inf])
title('Number of failures for different frequency subsampling')
set(gca,'fontsize', 12)
saveas(gcf,'subsampling_over_resonant_frequencies_failures.png')
close all

figure('units','normalized','outerposition',[0 0 1 1])
plot(rf_vector, results_t)
xlabel('Subsampling size')
ylabel('Time [s]')
ylim([0 inf])
title('Average reconstruction time for different frequency subsampling')
set(gca,'fontsize', 12)
saveas(gcf,'subsampling_over_resonant_frequencies_times.png')
close all