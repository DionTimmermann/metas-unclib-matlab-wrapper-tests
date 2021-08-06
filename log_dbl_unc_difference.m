function log_dbl_unc_difference(data, accept, uncType)

    result = [];
    result_msg = [];
    
    if isempty(data.dbl_error) && isempty(data.unc_error)
        % same error behavior. Test values
        
        if ndims(data.dbl_result) ~= ndims(data.unc_result)
            result = 'differentDimensions';
            result_msg = sprintf('different dimensions. Expected %i, but got %i. Size was expected to be %s instead of %s.', ...
            ndims(data.dbl_result), ...
            ndims(data.unc_result), ...
            strjoin(string(size(data.dbl_result)), '-by-'), ...
            strjoin(string(size(data.unc_result)), '-by-'));
        elseif any(size(data.dbl_result) ~= size(data.unc_result))
            result = 'differentSizes';
            result_msg = sprintf('different sizes. Expected %s, but got %s.', ...
            strjoin(string(size(data.dbl_result)), '-by-'), ...
            strjoin(string(size(data.unc_result)), '-by-'));
        elseif any(data.dbl_result ~= double(data.unc_result))
            result = 'differentResults';
            result_msg = sprintf('different results.');
        else
            result = 'passed';
            result_msg = sprintf('same result.');
        end
        
    elseif ~isempty(data.dbl_error) && ~isempty(data.unc_error)
        % same error behavior. Test Errors
        
        if strcmp(data.dbl_error.message, data.unc_error.message)
            result = 'passed';
            result_msg = sprintf('same error message.');
        else
            result = 'differentErrors';
            result_msg = sprintf('different error messages. Expected ''%s'', but got ''%s''.', data.dbl_error.message, data.unc_error.message);
        end
        
    elseif ~isempty(data.dbl_error) && isempty(data.unc_error)
        result = 'doubleError';
        result_msg = sprintf('only double caused an error. (%s)', data.dbl_error.message);
    else
        result = 'uncError';
        result_msg = sprintf('only unc caused an error. (%s)', data.unc_error.message);
    end
    
    warn = false;
    output = false;
    output_msg = [];
    no_message = false;
    type = [];
    if strcmp(result, 'passed') && ~isempty(accept)
        type = 'warning';
        warn = true;
        output = true;
        output_msg = sprintf('ATTENTION: Test PASSED, even though an error was accepted (%s).\n', accept);
    elseif strcmp(result, 'passed')
        type = 'passed';
        warn = false;
        output = false;
        output_msg = sprintf('PASSED: %s\n', result_msg);
    elseif strcmp(result, accept)
        type = 'accepted';
        warn = false;
        output = true;
        output_msg = sprintf('ACCEPTED DIFFERENCE: %s\n', accept);
    elseif ~isempty(accept)
        type = 'warning';
        warn = true;
        output = true;
        output_msg = sprintf('ATTENTION: An error (%s) was accepted, but a different error occured.\nFAILED: %s\n', accept, result_msg);
    else
        if strcmp(result, 'differentErrors')
            type = 'warning';
            warn = true;
            output = true;
            output_msg = sprintf('WARNING: %s\n', result_msg);
        else
            type = 'failed';
            warn = true;
            output = true;
            output_msg = sprintf('FAILED: %s\n', result_msg);
        end
    end
    
    if warn
        fid = 2;
    else
        fid = 1;
    end
    
    
    global automatedTestScript;
    global testReportFailed;
    global testReportWarning;
    global testReportAccepted;
    global testReportPassed;
    
    callStack = dbstack;
    if strcmp(callStack(end).name, automatedTestScript)
        isAutomatedTest = true;
    else
        isAutomatedTest = false;
    end
    
    st = dbstack;
    if length(st) > 2

        [currentPath,~,~] = fileparts(mfilename('fullpath'));
        testFileName = st(3).file;
        testFilePath = fullfile(currentPath, 'tests', st(3).file);
        testFileLine = st(3).line;
        
        % Based on https://de.mathworks.com/matlabcentral/answers/306876-how-do-i-read-only-a-specific-line-while-reading-a-text-file-in-matlab
        fHandle=fopen(st(3).file); 
        line = textscan(fHandle,'%s',1,'delimiter','\n', 'headerlines',st(3).line-1);
        testFileCode = line{1}{1};
        fclose(fHandle);
    end
    
    if ~isAutomatedTest || output
        if ~strcmp(type, 'passed')
            fprintf(fid, '\nIn <a href="matlab:opentoline(''%s'',%i, 1)">%s</a> (<a href="matlab:opentoline(''%s'',%i, 1)">line %i</a>)\n', testFilePath, testFileLine, testFilePath, testFileName, testFileLine, testFileLine);
            fprintf(fid, '> %s\n', testFileCode);
        end
        fprintf(fid, output_msg);
    end
    
    if isAutomatedTest
        
        switch (type)
            case 'passed'
                testReportPassed = [testReportPassed; table(string(testFileName), testFileLine, string(testFileCode), string(char(uncType)), string(result), string(output_msg), 'VariableNames', {'Script', 'Line', 'Test', 'UncType', 'Result', 'Message'})];
            case 'accepted'
                testReportAccepted = [testReportAccepted; table(string(testFileName), testFileLine, string(testFileCode), string(char(uncType)), string(result), string(output_msg), 'VariableNames', {'Script', 'Line', 'Test', 'UncType', 'Result', 'Message'})];
            case 'warning'
                testReportWarning = [testReportWarning; table(string(testFileName), testFileLine, string(testFileCode), string(char(uncType)), string(result), string(output_msg), 'VariableNames', {'Script', 'Line', 'Test', 'UncType', 'Result', 'Message'})];
            case 'failed'
                testReportFailed = [testReportFailed; table(string(testFileName), testFileLine, string(testFileCode), string(char(uncType)), string(result), string(output_msg), 'VariableNames', {'Script', 'Line', 'Test', 'UncType', 'Result', 'Message'})];
            otherwise
                error('Unknown error type.');
         end
            
    end
    
end
