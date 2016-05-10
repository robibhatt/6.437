try
    % Detect "decode.m"
    if (~exist('./to_be_removed/decode.m','file'))
        if (~exist('./upload.zip','file')) % Detect "upload.zip"
            error('MATLAB:Test6437FileNotFound', ...
              ['Please check folder structure since ''upload.zip'' is ',...
              'missing from the path expected. File ''upload.zip'' should ',...
              'be in this folder with the other three files for testing, namely ',...
              '''coded_message.mat'', ''test_code.sh'', and ''matlab_wrapper.m'' . '...
              'Please do NOT use a filename different from ''upload.zip'' for your zip file.']);
        else
            error('MATLAB:Test6437FileNotFound', ...
              ['Please check folder structure since ''decode.m'' is ',...
              'missing from the path expected. File ''decode.m'' should ',...
              'be directly in the ''upload.zip'' file without any intermediate folders.']);
        end
    end
    
    % Detect "coded_message.mat"
    if (~exist('./coded_message.mat','file'))
        error('MATLAB:Test6437FileNotFound', ...
          ['Please check folder structure since ''coded_message.mat'' is ',...
          'missing from the path expected. File ''coded_message.mat'' should ',...
          'be in this folder with the other three files for testing, namely ',...
          '''upload.zip'', ''test_code.sh'', and ''matlab_wrapper.m'' .']);
    end
    
    % Make the output file name
    opfname = ['temp_test_output.txt'];
    
    % Get the ciphertext
    load('coded_message.mat','ciphertext');
    
    % Run code
    cd('./to_be_removed');
    decode(ciphertext,opfname);
    cd('../');
    
    % Detect the output file
    if (~exist(['./to_be_removed/',opfname],'file'))
        error('MATLAB:Test6437FileNotFound', ...
          ['The output txt file is missing from the path expected. Please check the code.']);
    end
    
    % Final status if no error
    fprintf('\n----------------------\n%s\n\n','Program terminates normally!');

catch theerror
    % If the file gave an error, output it and stop
    fprintf('\n\n\n----------- ERROR! -----------\n\n');
    if (strcmp(theerror.identifier,'MATLAB:Test6437FileNotFound') == 1) % './to_be_removed/decode.m', './upload.zip', './coded_message.mat', or the output file is not found
        fprintf('%s\n\n', theerror.message);
    elseif (strcmpi(theerror.identifier,'MATLAB:HandleGraphics:noJVM') == 1)
        fprintf('%s\n\n',['Please check your MATLAB program and remove all functions that are related to figures. ',...
            'Such functions will not be supported in the evaluation process and thus will crash.']);
        msgString = getReport(theerror);
        index_bypass = strfind(msgString, 'Error in');
        msgString = msgString(index_bypass:end);
        fprintf('%s\n\n',msgString);
    else
        msgString = getReport(theerror);
        fprintf('%s\n\n',msgString);
    end
end