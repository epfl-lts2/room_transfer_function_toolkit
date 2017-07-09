function [mu, gram_matrix] = get_coherence_of_dictionary(dictionary)
gram_matrix = dictionary'*dictionary;
gram_matrix = abs(gram_matrix);
gram_matrix(logical(eye(size(gram_matrix)))) = 0;
[mu, ~] = max(max(gram_matrix));