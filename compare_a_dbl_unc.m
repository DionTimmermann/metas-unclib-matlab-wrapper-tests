function compare_a_dbl_unc(varargin)
%   compare_a_dbl_unc(a, command)           or 
%   compare_a_dbl_unc(a, b, command)        or 
%   compare_a_dbl_unc(a, b, c, command)     or 
%   compare_a_dbl_unc(a, b, c, d, command)  or 
%   compare_a_dbl_unc(a, b, c, d, e, command)
%   
%   Compares `a` after executing `command` when using double variables
%   and unc variables from the uncLib by METAS. The first 1 to 5 arguments 
%   are values for the variables `a` through `e`, which are set and cast 
%   to double/unc before executing command. 
%   The type of unc variable used (LinProp, DistProp, MCProp) is set
%   through the global(!) variable unc.
%
%   Example:
%       global unc;
%       unc = @LinProp;
%       compare_ans_dbl_unc(rand(4, 5, 6), 'a(3, :, 3)');
%
%   This function practically executes the following code:
%       a_initial = rand(4, 5, 6);
%
%       a = double(a_initial);
%       eval(['a(3, :, 3)' ;]);
%       double_a = a;
%       
%       a = unc(a_initial);
%       eval(['a(3, :, 3)' ;]);
%       unc_a = a;
%
%   The test is considered passed, if double_a == double(unc_a) or both
%   eval commands returned the same error message. Otherwise, the test is
%   failed. The test result is output directly, as this function is
%   designed to be used in MATLAB LiveScript files.
%
%   Additional variables (`b` though `e`) are initialized in the same way 
%   as `a` in the example above. Passing `rand(...)` as a parameter for
%   these variables is an easy way to define an n-dimensional matrix with
%   values that in practice will all be different. As rand is evaluated
%   before its values are passed to `compare_a_dbl_unc`, both the double
%   and the unc variable will have the same value.
%
%   See also: compare_ans_dbl_unc
% 
%   2021-05-31  dion.timmermann@ptb.de
%               * Initial Version
%   2021-06-03  michael.wollensack@metas.ch
%               * Different dimensions exception added
%

    global unc;
    
    if nargin < 2
        error('Must pass at least a command and one variable.');
    elseif nargin > 5+1
        error('Must pass at most 5 varaibles.');
    end
    if ~char(varargin{end})
        error('Must pass a command as last parameter.');
    end

    command = varargin{end};
    if command(end) ~= ';'
        command = [command ';'];
    end
    variables = varargin(1:end-1);
    variableNames = {'a', 'b', 'c', 'd', 'e'};
    
    dbl_error = [];
    cellfun(@(v, n) assignin('caller', n, double(v)), variables, variableNames(1:length(variables)));
    
    try
        eval(command);
        dbl_result = a;
    catch e
        dbl_error = e;
    end
    
    cellfun(@(v, n) assignin('caller', n, unc(v)), variables, variableNames(1:length(variables)));
    unc_error = [];
    
    try
        eval(command);
        unc_result = a;
    catch e
        unc_error = e;
    end
    
    
    if isempty(dbl_error) && isempty(unc_error)
        % same error behavior. Test values
        
        if ndims(dbl_result) ~= ndims(unc_result)
            fprintf('FAILED: different dimensions. Expected %i, but got %i. Size was expected to be %s insteaf of %s. \n', ...
            ndims(dbl_result), ...
            ndims(unc_result), ...
            strjoin(string(size(dbl_result)), '-by-'), ...
            strjoin(string(size(unc_result)), '-by-'));
        elseif any(size(dbl_result) ~= size(unc_result))
            fprintf('FAILED: different size. Expected %s, but got %s.\n', ...
            strjoin(string(size(dbl_result)), '-by-'), ...
            strjoin(string(size(unc_result)), '-by-'));
        elseif any(dbl_result ~= double(unc_result))
            fprintf('FAILED: different results.\n');
        else
            fprintf('PASSED: same result.\n');
        end
        
    elseif ~isempty(dbl_error) && ~isempty(unc_error)
        % same error behavior. Test Errors
        
        if strcmp(dbl_error.message, unc_error.message)
            fprintf('PASSED: same error message.\n');
        else
            fprintf('WARNING: different error messages. Expected ''%s'', but got ''%s''.\n', dbl_error.message, unc_error.message);
        end
        
        
    elseif ~isempty(dbl_error) && isempty(unc_error)
        fprintf('FAILED: only double caused an error. (%s)\n', dbl_error.message);
    else
        fprintf('FAILED: only unc caused an error. (%s)\n', unc_error.message);
    end
end