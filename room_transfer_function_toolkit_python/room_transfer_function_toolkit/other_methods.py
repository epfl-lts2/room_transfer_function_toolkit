import classes

import io
import numpy as np
import scipy.fftpack as fftpack
import scipy.signal as signal
from scipy.signal import butter, lfilter

def dec2base(num, base, l):
	'''
	Converts a decimal number into an array of l digits in a given base.
	Input:
	num - number to be converted
	base - conversion basis
	l - number of digits (padding with zeros if needed)
	Output:
	conv_num - converted number
	'''
	conv_num = np.zeros((l, 1))
	n = num
	for i in range(l):
		conv_num[l - i - 1] = n % base
		n = int(n/base)
	return conv_num

def filter_lowpass(input_signal, sampling_frequency, cut_off_frequency):
	'''
	Filters the recorded signal.
	Input:
	input_signal - signal that was recorded
	sampling_frequency - frequency at which signal was sampled
	cut_off_frequency - cutoff frequencty of the filter
	Output:
	filtered_signal - signal after filtering
	'''
	# we are going to filter the signal in Fourier domain
	order = 6
	nyquist_frequency = 1/2.1*sampling_frequency
	normalized_cutoff = cut_off_frequency/nyquist_frequency
	b, a = butter(order, normalized_cutoff, btype = 'low', analog = False)
	filtered_signal = lfilter(b, a, input_signal)
	return filtered_signal

def add_white_noise(x, SNR_dB):
	'''
	Adds white Gaussian noise with the given SNR
	Input:
	x - signal to which we add the noise
	SNR_dB - Signal to Noise Ratio given in dBs
	Output:
	x_with_noise - signal x with the added noise
	'''    
	# equations:
	# SNR_dB = 10log10(P_signal/P_noise)
	# P_noise = P_random_noise * scaling_factor
	# SNR_dB = 10log10(P_signal/(P_random_noise*scaling_factor))
	# 10^(SNR_dB/10) = P_signal/(P_random_noise*scaling_factor)
	# observe reciprocal values:
	# 10^(-SNR_dB/10) = (P_random_noise*scaling_factor)/P_signal
	# scaling_factor = (P_signal/P_random_noise)*10^(-SNR_dB/10)
	# required_noise = random_noise*sqrt(scaling_factor)
	L = x.shape[1]
	random_noise = np.random.randn(1, L)
	random_noise = random_noise.reshape(x.shape)
	P_signal = np.sum(np.power(x, 2))/L
	P_random_noise = np.sum(np.abs(random_noise)**2)/L
	scaling_factor = (P_signal/P_random_noise)*(10**(-float(SNR_dB)/10))
	required_noise = np.sqrt(scaling_factor)*random_noise
	if((np.real(x) == x).all()):
		x_with_noise = x + required_noise
	else:
		x_with_noise = x + required_noise*(1/np.sqrt(2) + 1j/np.sqrt(2))
	return x_with_noise
