function [answer] = decode(ciphered_text, filename)

    %create random cypher function:
    load('example_cipher.mat', 'plaintext');
    load('example_cipher.mat', 'cipher_function');
    load('language_parameters.mat', 'alphabet');
    load('language_parameters.mat', 'letter_probabilities');
    load('language_parameters.mat', 'letter_transition_matrix');
    [plaintext_length, n] = size(plaintext);
    function [ log_probability ] = likelihood(cipher)

        anticipher = [28,1];
        for index = 1:length(cipher)
            anticipher(index) = find(alphabet(index) == cipher);
        end

        anticipher_map = containers.Map;
        for index = 1:length(anticipher)
            anticipher_map(alphabet(index)) = anticipher(index);
        end

        log_probability = -1 * log(letter_probabilities(anticipher_map(ciphered_text(1))));

        for index = 2:length(ciphered_text)
            transition_probability = -1*log(letter_transition_matrix(anticipher_map(ciphered_text(index)),anticipher_map(ciphered_text(index-1))) + 10^(-10));
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
    function [deciphered_text_rate] = accuracy(cipher)
        count = 0;
        for index = 1:28
            if cipher(index) == cipher_function(index)
                count = count + 1;
            end
        end
        deciphered_text_rate = count / 28;
    end
    current_cipher = alphabet;
    answer = [100,1];
    switches = [100,1];
    accuracies = [100,1];
    for i = 1:100
        l_1 = likelihood(current_cipher);
        accuracies(i) = accuracy(current_cipher);
        answer(i) = l_1;
        potential_cipher = next_cipher(current_cipher);
        l_2 = likelihood(potential_cipher);
        switches(i) = 0;
        if isinf(l_1)
            current_cipher = potential_cipher;
            switches(i) = 1;
        elseif l_2 <= l_1
            current_cipher = potential_cipher;
            switches(i) = 1;
        else
            prob = 10^(l_1 - l_2);
            r = binornd(1, prob);
            if r == 1
                current_cipher = potential_cipher;
                switches(i) = 1;
            end
        end
    end
    acceptances = [100,1];
    for i = 1:100
        acceptances(i) = 0;
        if i < 11
            for j = 1:i
                acceptances(i) = acceptances(i) + switches(j);
            end
            acceptances(i)  = acceptances(i) / i;
        else
            for j = (i-9):i
                acceptances(i) = acceptances(i) + switches(j);
            end
            acceptances(i)  = acceptances(i) / 10;
        end
    end
    answer = accuracies;
end