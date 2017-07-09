function [reconstructed_indices, reconstruction_error, residual_norm] = ...
    reconstruct_locations(dictionary, signal, K)
[x, ~, residual_norm, residHist, ~] = CoSaMP(dictionary, signal, K,[],'');
reconstruction_error = residHist(end);
reconstructed_indices = find(x);