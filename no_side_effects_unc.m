function no_side_effects_unc(varargin)
%   no_side_effects_unc(a, command)                or 
%   no_side_effects_unc(a, b, command)             or 
%   no_side_effects_unc(a, b, c, command)          or 
%   no_side_effects_unc(a, b, c, d, command)       or 
%   no_side_effects_unc(a, b, c, d, e, command)
%   
%   Tests if a, b, c, d, or e chenge from before to after executing 
%   the command. The varaibles a through e are cast to unc.
%   The type of unc variable used (LinProp, DistProp, MCProp) is set
%   through the global(!) variable unc.
%
%   Example:
%       global unc;
%       unc = @LinProp;
%       no_side_effects_unc(rand(4, 5, 6), 'b=a; b(3, :, 3) = 1;');
%
%   This function practically executes the following code:
%       a = unc(rand(4, 5, 6));
%       a_initial = copy(a);
%
%       eval(['b=a; b(3, :, 3) = 1;' ;]);
%
%   The test is considered passed, if a and a_initial have the same size, 
%   values and uncertainties. Otherwise, the test is failed. The test 
%   result is output directly, and logged, if the test is run automatically.
%
%   Passing `rand(...)` as a parameter for a, b, c, d, and e is an easy way
%   to define an n-dimensional matrix with values that in practice will all
%   be different. 
%
%   See also: compare_ans_dbl_unc
% 
%   2021-08-10  dion.timmermann@ptb.de
%               * Initial Version

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
    variableNamesInitial = {'a_initial', 'b_initial', 'c_initial', 'd_initial', 'e_initial'};
    

    cellfun(@(v, n) assignin('caller', n, useUnc(v)), variables, variableNames(1:length(variables)));
    for ii = 1:length(variables)
        eval([variableNamesInitial{ii} ' = copy(' variableNames{ii} ');']);
    end
    
    unc_error = [];
    try
        eval(command);
    catch e
        unc_error = e;
    end
    
    type = [];
    if ~isempty(unc_error)
        type = 'failed';
        result = 'uncError';
        output_msg = sprintf('FAILED: error message was: %s\n', unc_error.message);
    else
        % Check dims
        for ii = 1:length(variables)
            dims_initial = eval(['ndims(' variableNamesInitial{ii} ')']);
            dims = eval(['ndims(' variableNames{ii} ')']);
            if dims_initial ~= dims
                type = 'failed';
                result = 'sideEffect';
                output_msg = sprintf('FAILED: %s changed from %i to %i dimensions. Size changed from %s to %s.\n', ...
                    variableNames{ii}, dims_initial, dims, ...
                    strjoin(string(eval(['size(' variableNames{ii} ')'])), '-by-'), ...
                    strjoin(string(eval(['size(' variableNamesInitial{ii} ')'])), '-by-'));
                break;
            end
        end
        
        if isempty(type)
            % Check size
            for ii = 1:length(variables)
                size_initial = eval(['size(' variableNamesInitial{ii} ')']);
                sizeNew = eval(['size(' variableNames{ii} ')']);
                if any(size_initial ~= sizeNew)
                    type = 'failed';
                    result = 'sideEffect';
                    output_msg = sprintf('FAILED: %s changed size from %s to %s.\n', ...
                        variableNames{ii}, ...
                        strjoin(string(size_initial), '-by-'), ...
                        strjoin(string(sizeNew), '-by-'));
                    break;
                end
            end
        end
        
        if isempty(type)
            % Check values
            for ii = 1:length(variables)
                values_initial = eval(variableNamesInitial{ii});
                values = eval(variableNames{ii});
                if any(values_initial(:) ~= values(:))
                    type = 'failed';
                    result = 'sideEffect';
                    output_msg = sprintf('FAILED: %s changed values.\n', ...
                        variableNames{ii});
                    break;
                end
            end
        end
        
        if isempty(type)
            % Check uncertainties
            for ii = 1:length(variables)
                u_initial = eval(['get_stdunc(' variableNamesInitial{ii} ')']);
                u = eval(['get_stdunc(' variableNames{ii} ')']);
                if any(u_initial(:) ~= u(:))
                    type = 'failed';
                    result = 'sideEffect';
                    output_msg = sprintf('FAILED: %s changed uncertainties.\n', ...
                        variableNames{ii});
                    break;
                end
            end
        end
    end
    
    if isempty(type)
        type = 'passed';
        result = 'passed';
        output_msg = sprintf('PASSED: No side effects.\n');
    end
    
    log_test_result(type, result, output_msg, char(useUnc), 3);
    
end
