function log_dbl_unc_difference(data, accept, uncType, maxDifference)

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
        elseif isequaln(data.dbl_result, double(data.unc_result))
            result = 'passed';
            result_msg = sprintf('same result.');
        elseif all(abs(data.dbl_result(:) - double(data.unc_result(:))) <= maxDifference)
            result = 'acceptedDifferentResults';
            result_msg = sprintf('simmilar result (difference < %g).', maxDifference);
        else
            result = 'differentResults';
            result_msg = sprintf('different results.');
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
    
    type = [];
    output_msg = [];
    if strcmp(result, 'passed') && ~isempty(accept)
        type = 'warning';
        output_msg = sprintf('ATTENTION: Test PASSED, even though an error was accepted (%s).\n', accept);
    elseif strcmp(result, 'passed')
        type = 'passed';
        output_msg = sprintf('PASSED: %s\n', result_msg);
    elseif strcmp(result, 'acceptedDifferentResults')
        type = 'accepted';
        output_msg = sprintf('ACCEPTED DIFFERENCE: %s\n', result_msg);
    elseif strcmp(result, accept)
        type = 'accepted';
        output_msg = sprintf('ACCEPTED DIFFERENCE: %s\n', accept);
    elseif ~isempty(accept)
        type = 'warning';
        output_msg = sprintf('ATTENTION: An error (%s) was accepted, but a different error occured.\nFAILED: %s\n', accept, result_msg);
    else
        if strcmp(result, 'differentErrors')
            type = 'warning';
            output_msg = sprintf('WARNING: %s\n', result_msg);
        else
            type = 'failed';
            output_msg = sprintf('FAILED: %s\n', result_msg);
        end
    end
    
    log_test_result(type, result, output_msg, char(uncType), 3);
    
end
