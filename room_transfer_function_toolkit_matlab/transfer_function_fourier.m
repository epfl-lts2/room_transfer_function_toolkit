function [ Hf, Hf_array ] = transfer_function_fourier(N, ...
    source_room_mode_table, receiver_room_mode_table, ...
    eigenfrequency_table, damping_factor_table, ...
    K_table, temperature, frequency_vector)
% A room transfer function (RTF) expresses the transmission characteristics
% of a sound between a source and a receiver. We use modal expasion. 

% Input:
% N - upper threshold for room modes
% source_room_mode_table - room modes for source's position
% receiver_room_mode_table - room modes for receiver's position
% eigenfrequency_table - table with precalculated eigenfrequencies
% damping_factor_table - damping factor is nx,ny,nz dependent
% K_table - K is nx,ny,nz dependent
% temperature - affects the speed of sound
% frequency_vector - frequencies for which we want to know the value of
% transfer function
% Output:
% Hf - transfer function up to the given frequency
% Hf_array - transfer function up to the given frequency splitted in
% array by modes

[c, rho, z] = get_air_properties_data(temperature);
BASE = N+1;
MAX_MODE = BASE^3-1;
Hf = zeros(size(frequency_vector));
Hf_array = zeros(length(frequency_vector),MAX_MODE);

Q = 10^-3;
for mode = 1:MAX_MODE
    ind = dec2base(mode,BASE,3);
    i = str2num(ind(3)) + 1;
    j = str2num(ind(2)) + 1;
    k = str2num(ind(1)) + 1;
    trans_curr = (rho*c^2*Q*(2*pi*frequency_vector)* ...
        source_room_mode_table(i,j,k)* ...
        receiver_room_mode_table(i,j,k))./ ...
        ((((2*pi*frequency_vector).^2 - ...
        (2*pi*eigenfrequency_table(i,j,k))^2)*1j + ...
        4*pi*frequency_vector*damping_factor_table(i,j,k))* ...
        K_table(i,j,k));
    Hf = Hf + trans_curr;
    Hf_array(:,mode) = trans_curr;
end
end