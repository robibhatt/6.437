function [answer] = decode(ciphered_text, filename)

    %create random cypher function:
    load('example_cipher.mat', 'plaintext');
    load('example_cipher.mat', 'cipher_function');
    load('language_parameters.mat', 'alphabet');
    load('language_parameters.mat', 'letter_probabilities');
    load('language_parameters.mat', 'letter_transition_matrix');
    n = length(plaintext);
    alphabet_map = containers.Map;
    for index = 1:length(alphabet)
        alphabet_map(alphabet(index)) = index;
    end
    function [answer] = anticipher_generate(cipher_to_anticipher)
        anticipher = [28, 1];
        for indexy = 1:length(cipher_to_anticipher)
            anticipher(indexy) = find(alphabet(indexy) == cipher_to_anticipher);
        end
        anticipher_map = containers.Map;
        for indexy = 1:length(anticipher)
            anticipher_map(alphabet(indexy)) = find(cipher_to_anticipher(indexy) == alphabet);
        end
        answer = anticipher_map;
    end
    function [ letter ] = decipher(old_letter, anticipher_map)
        letter = alphabet(anticipher_map(old_letter)); 
    end
    function [ log_probability ] = likelihood(cipher)

        anticipher = [28,1];
        for indexz = 1:length(cipher)
            anticipher(indexz) = find(alphabet(indexz) == cipher);
        end

        anticipher_map = containers.Map;
        for indexz = 1:length(anticipher)
            anticipher_map(alphabet(indexz)) = find(cipher(indexz) == alphabet);
        end

        log_probability = -1 * log(letter_probabilities(anticipher_map(ciphered_text(1))));

        for indexz = 232:400
            transition_probability = -1*log(letter_transition_matrix(anticipher_map(ciphered_text(indexz)),anticipher_map(ciphered_text(indexz-1))) + 10^(-10));
            log_probability = log_probability + transition_probability;
        end

    end
    function [new_cipher] = next_cipher(cipher)
        a = 0;
        b = 0;
        while a == b
            R = randi(28, 2);
            a = R(1,1);
            b = R(1,2);
        end

        new_cipher = cipher;
        new_cipher(a) = cipher(b);
        new_cipher(b) = cipher(a);
    end
    current_cipher = cipher_function;
    for i = 1:100
        l_1 = likelihood(current_cipher);
        potential_cipher = next_cipher(current_cipher);
        l_2 = likelihood(potential_cipher);
        if isinf(l_1)
            current_cipher = potential_cipher;
        elseif l_2 <= l_1
            current_cipher = potential_cipher;
        else
            prob = 10^(l_1 - l_2);
            r = binornd(1, prob);
            if r == 1
                current_cipher = potential_cipher;
            end
        end
    end    
    answer = 1;
    fileID = fopen(filename,'w');
    for i = 1:n
        anticipher_we_use = anticipher_generate(cipher_function);
        fprintf(fileID, decipher(ciphered_text(i), anticipher_we_use));
    end
    fclose(fileID);
end