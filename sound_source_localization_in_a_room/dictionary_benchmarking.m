function [] = dictionary_benchmarking(reconstructed_indices, undersampled_dictionary)
[mu, gram_matrix] = get_coherence_of_dictionary(undersampled_dictionary);
disp('Max in rows of the Gram matrix that correspond to the real positions')
disp(max(gram_matrix(reconstructed_indices, :),[],2))
disp(['Coherence parameter of the dictionary: ', num2str(mu), '.'])