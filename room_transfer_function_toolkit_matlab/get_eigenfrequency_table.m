function [ et ] = get_eigenfrequency_table(Lx, Ly, Lz, N, temperature)
c = 331+0.6*temperature;
et = zeros(N+1, N+1, N+1);

axial = [];
tangential = [];
oblique = [];
for nx = 0:N
    for ny = 0:N
        for nz = 0:N
            f = c/2*sqrt((nx/Lx)^2 + (ny/Ly)^2 + (nz/Lz)^2);
            switch(nnz([nx, ny, nz]))
                case 3
                    oblique = [oblique; [nx ny nz] f];
                case 2
                    tangential = [tangential; [nx ny nz] f];
                case 1
                    axial = [axial; [nx ny nz] f];
                otherwise
            end
            
            et(nx+1, ny+1, nz+1) = c/2*sqrt((nx/Lx)^2 + (ny/Ly)^2 + (nz/Lz)^2);
        end
    end
end

% if needed, different types of room modes can be estracted from the
% structured data
axial = sortrows(axial,4);
tangential = sortrows(tangential,4);
oblique = sortrows(oblique,4);

end