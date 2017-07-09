import classes
import other_methods

import math
import numpy as np
import random

def contains_coordinates(coordinate_array, current_coordinates):
	'''
	Checks if the new element already exists in the given array.
	Input:
	coordinate_array - array of 3D coordinates
	current_coordinates - coordinates of the new element
	Output:
	True if the element is already in the array, of False otherwise
	'''
	r = False
	for i in range(len(coordinate_array)):
		current_element = coordinate_array[i]
		[x1, y1, z1] = current_element.get_coordinates()
		[x2, y2, z2] = current_coordinates.get_coordinates()
		if((x1 == x2) & (y1 == y2) & (z1 == z2)):
			r = True
			break
	return r

def get_positions(Lx, Ly, Lz, TEMPERATURE, MAX_FREQUENCY_IN_INPUT_SIGNAL, RECEIVER_NUMBER):
	'''
	Returns the positions of the speaker and the training and evaluation microphones.
	The sampling step is detemined by the theory developed in:
	"The Plenacoustic Function and Its Sampling" by Thibaut Ajdler, Luciano Sbaiz, Martin Vetterli
	Input:
	Lx, Ly, Lz - dimensions of the room
	TEMPERATURE - room temperature
	MAX_FREQUENCY_IN_INPUT_SIGNAL - cut-off frequency of the low-pass filter
	RECEIVER_NUMBER - number of microphones
	Output:
	pos_s  - position of the source
	pos_mt - positions of the microphones from the training set
	pos_me - positions of the microphones from the evaluation set
	spatial_sampling_step - sampling step in all three directions
	'''
	# % we need to satisfy the sampling step size in time and in space
	c = 331 + 0.6*TEMPERATURE
	TEMPORAL_SAMPLING_FREQUENCY = 2.1*(2*np.pi*MAX_FREQUENCY_IN_INPUT_SIGNAL)
	spatial_sampling_step = (np.pi*c/TEMPORAL_SAMPLING_FREQUENCY)/4 

	# positions of the sources and the microphones should be on the grid
	pos_s = classes.Point3D( \
		math.floor((Lx/2)/spatial_sampling_step)*spatial_sampling_step, \
		math.floor((Ly/5)/spatial_sampling_step)*spatial_sampling_step, \
		math.floor((Lz/3)/spatial_sampling_step)*spatial_sampling_step)

	pos_mt = []
	pos_me = []
	xmin = 0.2*Lx
	xmax = 0.8*Lx
	xdiff = xmax - xmin
	ymin = 0.6*Ly
	ymax = 0.8*Ly
	ydiff = ymax - ymin
	zmin = 0.2*Lz
	zmax = 0.8*Lz
	zdiff = zmax - zmin
	# in case if the requested number of microphones is too large
	available_positions = math.floor(np.round(xdiff/spatial_sampling_step)* \
		np.round(ydiff/spatial_sampling_step)* \
		np.round(zdiff/spatial_sampling_step))/2
	if (available_positions< RECEIVER_NUMBER):
		print('Number of available nodes on the spatial grid: %d' % available_positions)
		print('Requested receiver number: %d', RECEIVER_NUMBER)
		raise AttributeError('Too many receivers.\nReturn to config.m and readjust it')
	while (len(pos_mt) < RECEIVER_NUMBER):
		new_position = classes.Point3D( \
			math.floor((xmin + random.random()*xdiff)/spatial_sampling_step)*spatial_sampling_step, \
			math.floor((ymin + random.random()*ydiff)/spatial_sampling_step)*spatial_sampling_step, \
			math.floor((zmin + random.random()*zdiff)/spatial_sampling_step)*spatial_sampling_step)
		if (not contains_coordinates(pos_mt, new_position)):
			pos_mt.append(new_position)
	while (len(pos_me) < RECEIVER_NUMBER):
		new_position = classes.Point3D( \
			math.floor((xmin + random.random()*xdiff)/spatial_sampling_step)*spatial_sampling_step, \
			math.floor((ymin + random.random()*ydiff)/spatial_sampling_step)*spatial_sampling_step, \
			math.floor((zmin + random.random()*zdiff)/spatial_sampling_step)*spatial_sampling_step)
		if ((not contains_coordinates(pos_me, new_position)) & (not contains_coordinates(pos_mt, new_position))):
			pos_me.append(new_position)
	return pos_s, pos_mt, pos_me, spatial_sampling_step