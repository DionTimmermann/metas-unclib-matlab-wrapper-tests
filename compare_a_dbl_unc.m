function compare_a_dbl_unc(varargin)
%   compare_a_dbl_unc(a, command, ['Accept', errorType])                or 
%   compare_a_dbl_unc(a, b, command, ['Accept', errorType])             or 
%   compare_a_dbl_unc(a, b, c, command, ['Accept', errorType])          or 
%   compare_a_dbl_unc(a, b, c, d, command, ['Accept', errorType])       or 
%   compare_a_dbl_unc(a, b, c, d, e, command, ['Accept', errorType])
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
%   If the optinal parameter 'Accept' is passed, a specific type of error
%   can be marked as accepted. Possible error types are
%       differentDimensions     results have different ndims()
%       differentSizes          results have different size()
%       differentResults        results are not identical, when cast to
%                               double
%       differentErrors         the error messages returned are different
%       doubleError             only double throws an error
%       uncError                only unc throws an error
%
%   See also: compare_ans_dbl_unc
% 
%   2021-05-31  dion.timmermann@ptb.de
%               * Initial Version
%   2021-06-03  michael.wollensack@metas.ch
%               * Different dimensions exception added
%

    global unc;
    global automatedUnc;
    global automatedTestScript;
    
    callStack = dbstack;
    if strcmp(callStack(end).name, automatedTestScript)
        useUnc = automatedUnc;
    else
        useUnc = unc;
    end
    
    accept = [];
    if ischar(varargin{end-1}) && strcmp(varargin{end-1}, 'Accept')
        accept = varargin{end};
        varargin(end-1:end) = [];
    end
    
    if numel(varargin)  < 2
        error('Must pass at least a command and one variable.');
    elseif numel(varargin) > 5+1
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
    
    data = struct();
    
    data.dbl_error = [];
    cellfun(@(v, n) assignin('caller', n, double(v)), variables, variableNames(1:length(variables)));
    
    try
        eval(command);
        data.dbl_result = a;
    catch e
        data.dbl_error = e;
    end
    
    cellfun(@(v, n) assignin('caller', n, useUnc(v)), variables, variableNames(1:length(variables)));
    data.unc_error = [];
    
    try
        eval(command);
        data.unc_result = a;
    catch e
        data.unc_error = e;
    end
    
    
    log_dbl_unc_difference(data, accept, useUnc);
    
end
