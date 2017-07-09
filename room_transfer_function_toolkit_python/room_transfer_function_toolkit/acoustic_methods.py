import classes
import other_methods

from scipy.signal.ltisys import TransferFunction as transfer_function
import math
import numpy as np

def get_air_properties(temperature):
	'''
	Retruns a the information about the air temperature depenent
	parameters: sound speed, air density and acoustic impedance.
	Input:
	temperature - air temperature in the given room
	Output:
	c - sound speed
	rho - air density
	z - acoustic impedance
	'''
	if (temperature <= -25):
		c = 315.77
		rho = 1.4224
		z = 449.1
	elif (temperature <= -20):
		c = 318.94
		rho = 1.3943
		z = 444.6
	elif (temperature <= -15):
		c = 322.07
		rho = 1.3673
		z = 440.3
	elif (temperature <= -10):
		c = 325.18
		rho = 1.3413
		z = 436.1
	elif (temperature <= -5):
		c = 328.25
		rho = 1.3163
		z = 432.1
	elif (temperature <= 0):
		c = 331.30
		rho = 1.2922
		z = 428.0
	elif (temperature <= 5):
		c = 334.32
		rho = 1.2690
		z = 424.3
	elif (temperature <= 10):
		c = 337.31
		rho = 1.2466
		z = 420.5
	elif (temperature <= 15):
		c = 340.27
		rho = 1.2250
		z = 416.9
	elif (temperature <= 20):
		c = 343.21
		rho = 1.2041
		z = 413.3
	elif (temperature <= 25):
		c = 346.13
		rho = 1.1839
		z = 409.4
	elif (temperature <= 30):
		c = 349.02
		rho = 1.1644
		z = 406.5
	else:
		c = 351.88
		rho = 1.1455
		z = 403.2
	return c, rho, z

def get_damping_factor_table(Lx, Ly, Lz, wall_impedances, N, temperature):
	'''
	Returns a table with damping factor values.
	Input:
	Lx, Ly, Lz - room dimensions
	wall_impedances - impedances of the walls for the given room
	N - number of room modes
	temperature - temperature in the room
	Output:
	dft - damping factor table
	'''
	N = N + 1
	c = 331 + 0.6*temperature
	dft = np.zeros((N, N, N))
	# wall_impedances - arranged as zx0, zxL, zy0, zyL, zz0, zzL
	for nx in range(N):
		for ny in range(N):
			for nz in range(N):
				eps_nx = 1 + (nx > 0)
				eps_ny = 1 + (ny > 0)
				eps_nz = 1 + (nz > 0)
				dft[nx, ny, nz] = c/2*( \
					eps_nx*(wall_impedances[0] + wall_impedances[1])/Lx + \
					eps_ny*(wall_impedances[2] + wall_impedances[3])/Ly + \
					eps_nz*(wall_impedances[4] + wall_impedances[5])/Lz)
	return dft

def get_eigenfrequency_table(Lx, Ly, Lz, N, temperature):
	'''
	Returns a table with eigenfrequencies of the given room.
	Input:
	Lx, Ly, Lz - room dimensions
	N - range of n numbers
	temperature - temperature in the room
	Output:
	et - eigenfrequency table
	'''
	c = 331 + 0.6*temperature
	N = N + 1
	et = np.zeros((N, N, N))

	for nx in range(N):
		for ny in range(N):
			for nz in range(N):
				et[nx, ny, nz] = c/2*math.sqrt(\
					np.power(nx/Lx, 2) + \
					np.power(ny/Ly, 2) + \
					np.power(nz/Lz, 2))
	return et

def get_K_table(Lx, Ly, Lz, N):
	'''
	Returns a table with eigenfrequencies of the given room.
	Input:
	Lx, Ly, Lz - room dimensions
	N - range of n numbers
	Output:
	Kt - K coefficient table
	'''
	V = Lx*Ly*Lz
	N = N + 1
	Kt = np.zeros((N, N, N))
	for nx in range(N):
		for ny in range(N):
			for nz in range(N):
				eps_nx = 1 + (nx > 0)
				eps_ny = 1 + (ny > 0)
				eps_nz = 1 + (nz > 0)
				Kt[nx, ny, nz] = V/(eps_nx*eps_ny*eps_nz)
	return Kt

def get_room_mode_table(Lx, Ly, Lz, N, coordinates):
	'''
	Returns a table of room modes of the given room.
	Input:
	Lx, Ly, Lz - room dimensions
	N - range of n numbers
	coordinates - 3D coordinates of the microphones/sound sources
	Output:
	rmt - table of room modes
	'''
	N = N + 1
	rmt = np.zeros((N, N, N))
	[x, y, z] = coordinates.get_coordinates()

	for nx in range(N):
		for ny in range(N):
			for nz in range(N):
				rmt[nx, ny, nz] = np.cos(nx*math.pi*x/Lx)* \
				np.cos(ny*math.pi*y/Ly)* \
				np.cos(nz*math.pi*z/Lz)
	rmt[0, 0, 0] = 0 # if ((nx == 0) & (ny == 0) & (nz == 0))
	return rmt


def get_transfer_function_fourier(N, source_room_mode_table, receiver_room_mode_table, \
	eigenfrequency_table, damping_factor_table, K_table, temperature, frequency_vector):
	'''
	A room transfer function (RTF) expresses the transmission characteristics
	of a sound between a source and a receiver. We use modal expasion.
	Input:
	N - upper threshold for room modes
	source_room_mode_table - table of room modes related to the sources
	receiver_room_mode_table - table of room modes related to the receivers
	eigenfrequency_table - table of room eigenfrequencies
	damping_factor_table - table of damping factors
	K_table - table of K coefficients
	temperature - temperature in the given room
	frequency_vector - frequency range for which we want to have the values of the transfer function
	Output:
	Hf - transfer function in Fourier domain up to the given 
	Hf_array - transfer function up to the given frequency splitted in array by modes
	'''
	[c, rho, z] = get_air_properties(temperature)
	BASE = N + 1
	MAX_MODE = np.power(BASE, 3) - 1
	Hf = np.zeros((len(frequency_vector), 1), dtype=np.complex_)
	Hf_array = np.zeros((len(frequency_vector), MAX_MODE), dtype=np.complex_)

	Q = 10^-3
	for mode in range(1, MAX_MODE + 1):
		ind = other_methods.dec2base(mode, BASE, 3)
		i = int(ind[2])
		j = int(ind[1])
		k = int(ind[0])
		trans_curr = rho*np.power(c, 2)*Q*(2*np.pi*frequency_vector)*source_room_mode_table[i, j, k]* \
			np.divide((receiver_room_mode_table[i, j, k]), (((np.power(2*np.pi*frequency_vector, 2) - \
				np.power(2*np.pi*eigenfrequency_table[i, j, k], 2))*1j + 4*np.pi*frequency_vector* \
			damping_factor_table[i, j, k])*K_table[i, j, k]))
		Hf = Hf + np.reshape(trans_curr, Hf.shape)
		Hf_array[:, mode-1] = trans_curr
	return Hf, Hf_array

def get_transfer_function_laplace(N, source_room_mode_table, receiver_room_mode_table, \
	eigenfrequency_table, damping_factor_table, K_table, temperature):
	'''
	A room transfer function (RTF) expresses the transmission characteristics
	of a sound between a source and a receiver. We use modal expasion.
	Input:
	N - upper threshold for room modes
	source_room_mode_table - table of room modes related to the sources
	receiver_room_mode_table - table of room modes related to the receivers
	eigenfrequency_table - table of room eigenfrequencies
	damping_factor_table - table of damping factors
	K_table - table of K coefficients
	temperature - temperature in the given room
	Output:
	Hs_array - transfer function splitted in an array by modes
	'''
	[c, rho, z] = get_air_properties(temperature)
	BASE = N+1
	MAX_MODE = BASE^3-1
	Hs_array = []

	Q = 10^-3
	for mode in range(1, MAX_MODE + 1):
		ind = other_methods.dec2base(mode, BASE, 3)
		i = int(ind[2])
		j = int(ind[1])
		k = int(ind[0])
		numerator = [rho*np.power(c, 2)*Q*a for a in [(source_room_mode_table[i, j, k]* \
			receiver_room_mode_table[i, j, k]), 0]]
		denominator = [K_table[i, j, k]*a for a in [1, 2*damping_factor_table[i, j, k], \
		np.power(2*np.pi*eigenfrequency_table[i, j, k], 2)]] 
		Hs_curr = transfer_function(numerator, denominator)
		Hs_array.append(Hs_curr)
	return Hs_array