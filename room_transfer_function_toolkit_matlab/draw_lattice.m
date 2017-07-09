function [ ] = draw_lattice(Lx, Ly, Lz, SPATIAL_SAMPLING_STEP)
color = [0.4,0.4,0.4];
for g = 0:SPATIAL_SAMPLING_STEP:Lx
    for i = 0:SPATIAL_SAMPLING_STEP:Lz
       plot3([g g], [0 Ly], [i, i], 'Color', color)
       hold on
    end
end

for g = 0:SPATIAL_SAMPLING_STEP:Ly
    for i = 0:SPATIAL_SAMPLING_STEP:Lz
       plot3([0 Lx], [g g], [i, i], 'Color', color)
       hold on
    end
end

for g = 0:SPATIAL_SAMPLING_STEP:Ly
    for i = 0:SPATIAL_SAMPLING_STEP:Lx
       plot3([i i], [g g], [0 Lz], 'Color', color)
       hold on
    end
end
end