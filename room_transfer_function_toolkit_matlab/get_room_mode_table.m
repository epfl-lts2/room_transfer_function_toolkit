function [ rmt ] = get_room_mode_table(Lx, Ly, Lz, N, coordinates)
rmt = zeros(N+1, N+1, N+1);

[x, y, z] = get_coordinates(coordinates);

for nx = 0:N
    for ny = 0:N
        for nz = 0:N
            rmt(nx+1, ny+1, nz+1) = cos(nx*pi*x/Lx)* cos(ny*pi*y/Ly)* cos(nz*pi*z/Lz);
        end
    end
end
rmt(1, 1, 1) = 0; % if ((nx == 0) & (ny == 0) & (nz == 0))
end