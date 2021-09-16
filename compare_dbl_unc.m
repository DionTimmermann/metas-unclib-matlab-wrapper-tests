function compare_dbl_unc(command, varargin)
%   compare_dbl_unc(command, ['Accept', errorType])
%   
%   Executes command twice, once with the variable `type = @double;` and
%   once with the variable `type = unc`.
%   The type of unc variable used (LinProp, DistProp, MCProp) is set
%   through the global(!) variable unc.
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
%   2021-09-16  dion.timmermann@ptb.de
%               * Initial Version
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
    if numel(varargin) > 0
        if ischar(varargin{end-1}) && strcmp(varargin{end-1}, 'Accept')
            accept = varargin{end};
            varargin(end-1:end) = [];
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
    
    log_dbl_unc_difference(data, accept, useUnc);
    
end
