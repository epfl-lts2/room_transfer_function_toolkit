import datetime
import math
import numpy as np
import os
import pickle
import scipy.io
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt

def write_load_parameters(data_path, file_name):
	'''
	Saves and loads the parameters of the experiment into 'config.pckl' file.
	If needed, change the parameters.
	Input:
	data_path - folder where the file with the parameters is located
	file_name - name of the file where parameters will be written
	Output:
	experiment_parameters - parameters for the experiment organized in a dictionary

	'''
	# relative file paths
	if not os.path.exists(data_path):
		os.makedirs(data_path)

	# SINGAL_NUMBER: look at 'other_methods.get_test_signal()'
	LOWPASS_FILTER_BANDWIDTH = 50 # key parameter of the system
	# we want to reduce the frequency from the frequency of a microphone
	# (from 44.1kHz) to a low frequency - for room mode tools
	# reduce frequency = filter + downsample
	adjusted_sampling_frequency = 2.1*LOWPASS_FILTER_BANDWIDTH
	SAMPLING_FREQUENCY = 44100 # microphone (44.1 kHz)
	STEP = math.floor(SAMPLING_FREQUENCY/adjusted_sampling_frequency)
	REVERBERATON_TIME_60 = 1.25
	TIME_MOMENTS = REVERBERATON_TIME_60*SAMPLING_FREQUENCY
	TIME_MOMENTS = math.ceil(TIME_MOMENTS/STEP)
	NUMBER_OF_WALLS = 6

	experiment_parameters = {'Lx':3.9, 'Ly':8.15, 'Lz':3.35, \
	'REVERBERATON_TIME_60':REVERBERATON_TIME_60, 'TEMPERATURE':25, \
	'RECEIVER_NUMBER':46, \
	'SIGNAL_NUMBER':0, 'LOWPASS_FILTER_BANDWIDTH':LOWPASS_FILTER_BANDWIDTH, \
	'N':3, 'WALL_IMPEDANCES':0.01*np.ones((NUMBER_OF_WALLS, 1)), \
	'SAMPLING_FREQUENCY':SAMPLING_FREQUENCY, 'STEP':STEP, \
	'TIME_MOMENTS':TIME_MOMENTS, \
	'TRAINING_DATA_FILE_PATH':'../data/measurements_training.pckl', \
	'EVALUATION_DATA_FILE_PATH':'../data/measurements_evaluation.pckl', \
	'UNLOCBOX_PATH':'../../unlocbox-1.7.3/unlocbox/init_unlocbox.m'}

	file = open(os.path.join(data_path, file_name), 'wb')
	pickle.dump(experiment_parameters, file)
	file.close()

	return experiment_parameters

def draw_lattice(fig, Lx, Ly, Lz, SPATIAL_SAMPLING_STEP):
	'''
	Visualizes the samling lattice on the given figure.
	Input:
	fig - figure handler
	Lx, Ly, Lz - room dimensions
	SPATIAL_SAMPLING_STEP - sampling step over all three coordinates
	Ouput:
	lattice drawn on the figure
	'''
	# color = [0.4, 0.4, 0.4]
	fig.hold(True)
	for g in range(0, Lx, SPATIAL_SAMPLING_STEP):
		for i in range(0, Lz, SPATIAL_SAMPLING_STEP):
			fig.plot([g, g], [0, Ly], [i, i], color = 'grey')

	for g in range(0, Ly, SPATIAL_SAMPLING_STEP):
		for i in range(0, Lz, SPATIAL_SAMPLING_STEP):
			fig.plot([0, Lx], [g, g], [i, i], color = 'grey')

	for g in range(0, Ly, SPATIAL_SAMPLING_STEP):
		for i in range(0, Lx, SPATIAL_SAMPLING_STEP):
			fig.plot([i, i], [g, g], [0, Lz], color = 'grey')
	return fig

def draw_sensor_placement(Lx, Ly, Lz, pos_s, pos_mt, pos_me, SPATIAL_SAMPLING_STEP):
	'''
	Draws placement of sensors and sound sources across the given room.
	Input:
	Lx, Ly, Lz - room dimensions
	pos_s - positions of sound sources
	pos_mt - positions of microphones from the training set
	pos_me - posiitions of microphones from the evaluation set
	SPATIAL_SAMPLING_STEP - sampling step over all three coordinates
	Output:
	figure saved in a file
	'''
	# 1st step: draw the room; bottom-top-left-right
	x = np.matrix('0 %s %s 0 0; 0 %s %s 0 0; \
		0 0 0 0 0; %s %s %s %s %s' % (Lx, Lx, Lx, Lx, Lx, Lx, Lx, Lx, Lx))
	y = np.matrix('0 0 %s %s 0; 0 0 %s %s 0; \
		0 %s %s 0 0; 0 %s %s 0 0' % (Ly, Ly, Ly, Ly, Ly, Ly, Ly, Ly))
	z = np.matrix('0 0 0 0 0; %s %s %s %s %s; \
		0 0 %s %s 0; 0 0 %s %s 0' % (Lz, Lz, Lz, Lz, Lz, Lz, Lz, Lz, Lz))

	# decorating the walls and the floor
	# img = imread('pic\floor.jpg')                 
	# fig.image([Lx, 0, 0], [Ly, 0, 0], img)
	# img = imread('pic\wall.jpg')
	# xImage = np.matrix('0 Lx; 0 Lx')
	# yImage = np.matrix('Ly Ly; Ly Ly') 
	# zImage = np.matrix('0 0; Lz Lz')
	# fig.surf(xImage, yImage, zImage, 'CData', img, 'FaceColor', 'texturemap')
	# xImage = np.matrix('Lx Lx; Lx Lx')
	# yImage = np.matrix('0 Ly; 0 Ly')
	# zImage = np.matrix('0 0; Lz Lz')
	# fig.surf(xImage, yImage, zImage, 'CData', img, 'FaceColor', 'texturemap')

	# 2nd step: draw the sources
	[xs, ys, zs] = pos_s.get_coordinates()
	# output_file("experimental_setting.html", title="example of an experimental setting")
	xmt = []
	ymt = []
	zmt = []
	xme = []
	yme = []
	zme = []
	for i in range(len(pos_mt)):
		[x, y, z] = (pos_mt[i]).get_coordinates()
		xmt.append(x)
		ymt.append(y)
		zmt.append(z)
		[x, y, z] = (pos_me[i]).get_coordinates()
		xme.append(x)
		yme.append(y)
		zme.append(z)
	fig = plt.figure()
	ax = fig.add_subplot(111, projection='3d')
	ax.scatter(xs, ys, zs, c = 'c', marker = 'o')
	ax.hold(True)
	ax.scatter(xmt, ymt, zmt, c = 'r', marker = 'o')
	ax.scatter(xme, yme, zme, c = 'g', marker = 'o')
	ax.set_xlabel('width')
	ax.set_ylabel('depth')
	ax.set_zlabel('height')
	ax.set_xlim(0, Lx)
	ax.set_ylim(0, Ly)
	ax.set_zlim(0, Lz)

	plt.show()
	return