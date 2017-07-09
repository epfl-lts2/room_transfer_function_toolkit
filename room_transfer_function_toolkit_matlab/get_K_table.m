function [ Kt ] = get_K_table( Lx, Ly, Lz, N )
V = Lx*Ly*Lz;
Kt = zeros(N+1, N+1, N+1);
for nx = 0:N
    for ny = 0:N
        for nz = 0:N
            eps_nx = 1 + (nx > 0);
            eps_ny = 1 + (ny > 0);
            eps_nz = 1 + (nz > 0);
            Kt(nx+1, ny+1, nz+1) = V/(eps_nx*eps_ny*eps_nz);
        end
    end
end

end

