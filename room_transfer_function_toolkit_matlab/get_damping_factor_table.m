function [ dft ] = get_damping_factor_table( Lx, Ly, Lz, wall_impedances, ...
                                             N, temperature )
c = 331+0.6*temperature;
dft = zeros(N+1, N+1, N+1);
% wall_impedances - arranged as zx0, zxL, zy0, zyL, zz0, zzL
for nx = 0:N
    for ny = 0:N
        for nz = 0:N
            eps_nx = 1 + (nx > 0);
            eps_ny = 1 + (ny > 0);
            eps_nz = 1 + (nz > 0);
            dft(nx+1, ny+1, nz+1) = c/2*( ...
                eps_nx*(wall_impedances(1) + wall_impedances(2))/Lx + ...
                eps_ny*(wall_impedances(3) + wall_impedances(4))/Ly + ...
                eps_nz*(wall_impedances(5) + wall_impedances(6))/Lz);
        end
    end
end
end

