function [ pos_s, pos_mt, pos_me, SPATIAL_SAMPLING_STEP ] = get_positions ...
    ( Lx, Ly, Lz, TEMPERATURE, MAX_FREQUENCY_IN_INPUT_SIGNAL, RECEIVER_NUMBER )
% output:
% pos_s  - position of the source
% pos_mt - positions of the microphones from the training set
% pos_me - positions of the microphones from the training set

% we need to satisfy the sampling step size in time and in space
TEMPORAL_SAMPLING_FREQUENCY = 2.1*(2*pi*MAX_FREQUENCY_IN_INPUT_SIGNAL);
c = 331 + 0.6*TEMPERATURE;
% adjust the scaling to the needs
SPATIAL_SAMPLING_STEP = (pi*c/TEMPORAL_SAMPLING_FREQUENCY)/4; 

% positions of the sources and the microphones should be on the grid
pos_s = Point3D(...
    floor((Lx/2)/SPATIAL_SAMPLING_STEP)*SPATIAL_SAMPLING_STEP, ...
    floor((Ly/5)/SPATIAL_SAMPLING_STEP)*SPATIAL_SAMPLING_STEP, ...
    floor((Lz/3)/SPATIAL_SAMPLING_STEP)*SPATIAL_SAMPLING_STEP);

pos_mt = [];
pos_me = [];
xmin = 0.2*Lx; xmax = 0.8*Lx; xdiff = xmax - xmin;
ymin = 0.6*Ly; ymax = 0.8*Ly; ydiff = ymax - ymin;
zmin = 0.2*Lz; zmax = 0.8*Lz; zdiff = zmax - zmin;

% in case if the requested number of microphones is too large
% divide by two - two groups: training and evaluation
if(((round(xdiff/SPATIAL_SAMPLING_STEP)*...
        round(ydiff/SPATIAL_SAMPLING_STEP)*...
        round(zdiff/SPATIAL_SAMPLING_STEP))...
        /2) < RECEIVER_NUMBER)
    disp('Number of available nodes')
    (round(xdiff/SPATIAL_SAMPLING_STEP)*...
        round(ydiff/SPATIAL_SAMPLING_STEP)*...
        round(zdiff/SPATIAL_SAMPLING_STEP))/2
    sprintf('Receiver number: %d', RECEIVER_NUMBER)
    msgID = 'MYFUN:incorrectReceiverNumber';
    msg = 'Too many receivers.\nReturn to config.m and readjust it';
    tooLargeException = MException(msgID,msg);
    throw(tooLargeException);
end

while (length(pos_mt) < RECEIVER_NUMBER)
    new_position = Point3D( ...
    floor((xmin + rand(1)*xdiff)/SPATIAL_SAMPLING_STEP)*SPATIAL_SAMPLING_STEP, ...
    floor((ymin + rand(1)*ydiff)/SPATIAL_SAMPLING_STEP)*SPATIAL_SAMPLING_STEP, ...
    floor((zmin + rand(1)*zdiff)/SPATIAL_SAMPLING_STEP)*SPATIAL_SAMPLING_STEP);
    if(~contains(pos_mt,new_position))
        pos_mt = [pos_mt ; new_position];
    end
end
while (length(pos_me) < RECEIVER_NUMBER)
    new_position = Point3D( ...
    floor((xmin + rand(1)*xdiff)/SPATIAL_SAMPLING_STEP)*SPATIAL_SAMPLING_STEP, ...
    floor((ymin + rand(1)*ydiff)/SPATIAL_SAMPLING_STEP)*SPATIAL_SAMPLING_STEP, ...
    floor((zmin + rand(1)*zdiff)/SPATIAL_SAMPLING_STEP)*SPATIAL_SAMPLING_STEP);
    if(~contains(pos_me,new_position) && ~contains(pos_mt,new_position))
        pos_me = [pos_me ; new_position];
    end
end
end