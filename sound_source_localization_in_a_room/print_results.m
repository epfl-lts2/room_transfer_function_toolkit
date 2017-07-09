function [] = print_results(gound_truth_positions, ...
    reconstructed_indices, selected_positions, pos_r, Lx, Ly, Lz)
figure('units','normalized','outerposition',[0 0 1 1])

% show the microphone position
[x, y, z] = get_coordinates(pos_r);
plot3(x, y, z, 'o', 'MarkerFaceColor', 'r','MarkerSize', 10);
hold on

% show the potential postion grid
plot3(selected_positions(1,:), selected_positions(2,:), ...
    selected_positions(3,:), 'o', ...
    'color', [145, 164, 196]/256, 'Linewidth', 3)

% show the ground truth positions
for i = 1:length(gound_truth_positions)
    [x, y, z] = get_coordinates(gound_truth_positions(i));
    plot3(x, y, z, 'ob', 'Linewidth', 5)
end

% show the estimated positions
plot3(selected_positions(1, reconstructed_indices), ...
    selected_positions(2, reconstructed_indices), ...
    selected_positions(3, reconstructed_indices), '*c', 'Linewidth', 5);

axis equal
xlim([0 Lx])
ylim([0 Ly])
zlim([0 Lz])
    
disp('----------------------------------------------------------')
disp('Initial positions')
disp(gound_truth_positions)

reconstructed_indices = sort(reconstructed_indices);
disp('Reconstructed positions')
disp(selected_positions(:, reconstructed_indices)')
end