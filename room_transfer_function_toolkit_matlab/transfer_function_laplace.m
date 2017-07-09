function [ Hs, Hs_array ] = transfer_function_laplace(N, source_room_mode_table, ...
    receiver_room_mode_table, eigenfrequency_table, damping_factor_table, ...
    K_table, temperature)
% A room transfer function (RTF) expresses the transmission characteristics
% of a sound between a source and a receiver. We use modal expasion. 
% In Laplace domain.

% Input:
% N - upper threshold for room modes
% source_room_mode_table - room modes for source's position
% receiver_room_mode_table - room modes for receiver's position
% eigenfrequency_table - table with precalculated eigenfrequencies
% damping_factor_table - damping factor is nx,ny,nz dependent
% K_table - K is nx,ny,nz dependent
% temperature - affects the speed of sound
% Output:
% Hs - transfer function in Laplace domain
% Hs_array - transfer function up to the given frequency splitted in
% array by modes

[c, rho, z] = get_air_properties_data(temperature);
BASE = N+1;
MAX_MODE = BASE^3-1;
Hs = tf(0);
Hs_array = [];

Q = 10^-3;
for mode = 1:MAX_MODE
    ind = dec2base(mode,BASE,3);
    i = str2num(ind(3)) + 1;
    j = str2num(ind(2)) + 1;
    k = str2num(ind(1)) + 1;
    numerator = [(source_room_mode_table(i,j,k)* ...
                receiver_room_mode_table(i,j,k)) 0];
    denominator = K_table(i,j,k)*...
        [1 2*damping_factor_table(i,j,k) ...
        (2*pi*eigenfrequency_table(i,j,k))^2];
    Hs_curr = rho*c^2*Q*tf(numerator, denominator);
    Hs = Hs + Hs_curr;
    Hs_array = [Hs_array; Hs_curr];
end
end