function data = compare_dbl_unc(command, varargin)
%   data = compare_dbl_unc(command, [Options])
%   
%   Executes command twice, once with the variable `type = @double;` and
%   once with the variable `type = unc`.
%   The type of unc variable used (LinProp, DistProp, MCProp) is set
%   through the global(!) variable unc.
%
%   The returned struct 'data' contains the results and error objects for
%   unc and double.
%
%   Example:
%       global unc;
%       unc = @LinProp;
%       compare_dbl_unc('type(zeros(2, 2))');
%
%   This function practically executes the following code:
%       double_ans = double(zeros(2, 2))
%         and
%       unc_ans = unc(zeros(2, 2))
%
%   The test is considered passed, if double_ans == double(unc_ans) or both
%   eval commands returned the same error message. Otherwise, the test is
%   failed. The test result is output directly, as this function is
%   designed to be used in MATLAB LiveScript files.
%
%   The last input arguments can be pairs of parameters and values.
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
%   If the optional parameter 'MaxDifference' is passed, the test will be
%   marked as 'accepted difference', if abs(double_a - double(unc_a)) is
%   less than or equal to the specified value.
%
%   See also: compare_ans_dbl_unc


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
    maxDifference = 0;
    if numel(varargin) > 0
        for ii = 1:2
            if ischar(varargin{end-1}) && strcmp(varargin{end-1}, 'Accept')
                accept = varargin{end};
                varargin(end-1:end) = [];
            end
            if ischar(varargin{end-1}) && strcmp(varargin{end-1}, 'MaxDifference')
                maxDifference = varargin{end};
                varargin(end-1:end) = [];
            end
        end
    end
    
    if command(end) ~= ';'
        command = [command ';'];
    end
    
    data = struct();
    
    data.dbl_error = [];
    type = @double;
    
    try
        eval(command);
        data.dbl_result = ans;
    catch e
        data.dbl_error = e;
    end
    
    data.unc_error = [];
    type = useUnc;
    
    try
        eval(command);
        data.unc_result = ans;
    catch e
        data.unc_error = e;
    end
    
    log_dbl_unc_difference(data, accept, useUnc, maxDifference);
    
end
