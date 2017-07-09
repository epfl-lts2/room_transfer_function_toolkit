function [ output_signal ] = filter_lowpass( input_signal, ...
    sampling_frequency, adjusted_sampling_frequency )
% we are going to filter the signal in Fourier domain
NFFT = length(input_signal);
input_signal_F = fft(input_signal, NFFT);
F = ((0:1/NFFT:1-1/NFFT)*sampling_frequency).';
output_signal_F = input_signal_F;
output_signal_F(F>=adjusted_sampling_frequency/2 & ...
    F<=sampling_frequency-adjusted_sampling_frequency/2) = 0;
output_signal = ifft(output_signal_F);
end