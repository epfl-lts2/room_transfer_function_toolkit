function [reconstruction_error] = get_reconstruction_error(...
    gound_truth_positions_points, reconstructed_positions)
ground_truth_positions = [];
for i = 1:length(gound_truth_positions_points)
    [x, y, z] = get_coordinates(gound_truth_positions_points(i));
    ground_truth_positions = [ground_truth_positions; [x, y, z]];
end
ground_truth_positions = sortrows(ground_truth_positions);
reconstructed_positions = sortrows(reconstructed_positions');
reconstruction_error = sum(sum(abs(ground_truth_positions - ...
    reconstructed_positions)));
end