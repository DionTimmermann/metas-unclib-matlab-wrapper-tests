%% Generate report on all tests for the metas unclib matlab wrapper
%
% This scripts runs all tests that match the pattern "tests/test_*" and
% generates an excel file results in the folder reports detailing the test
% results.
%

% 2021-08-06 dion.timmermann@ptb.de
%   Created Script

%% Config
clear;
clc;

% Test results to also print in the comand line
commandline_output = {...
        'failed', ...
        'warning', ...
%        'accepted', ...
%        'passed' ...
     };

testFolder = 'tests';
testPrefix = 'test_';

%% Setting Up Variables

result_types = {'failed', 'warning', 'accepted', 'passed'};

[currentPath,currentScript,~] = fileparts(mfilename('fullpath'));
cd(currentPath);
files = dir(testFolder);
addpath('.');
cd(testFolder);

uncTypes = {@LinProp, @DistProp, @MCProp};

global automatedUnc;
global testReport;
global automatedTestScript;
global automatedOutput;
global warningOnDifferentErrorMessages;

warningOnDifferentErrorMessages = false;

% automatedTestScript is used to detect in the testing functions, if they
% are executed as part of an automated test. Simply setting a global
% true/false flag might procued unexcepted results if the script crashes.
automatedTestScript = currentScript;
automatedOutput = commandline_output;

testReport = struct();
for ii = 1:length(result_types)
    testReport.(result_types{ii}) = table([], [], [], [], [], [], 'VariableNames', {'Script', 'Line', 'Test', 'UncType', 'Result', 'Message'});
end

%% Running the tests
for tt = 1:numel(uncTypes)
    automatedUnc = uncTypes{tt};
    fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\nTesting %s\n', char(uncTypes{tt}));
    for ii = 1:numel(files)

        if ~startsWith(files(ii).name, testPrefix) || ~endsWith(files(ii).name, '.m')
            continue;
        end
        
        fprintf('File %s\n', files(ii).name);
        eval(files(ii).name(1:end-2));
        
    end
end

%% Cleanup

cd('..');

v=ver('matlab');
filename = sprintf('reports/%s-test-report-MATLAB-%s.xlsx', datestr(now,'yyyy-mm-dd'), v.Release(2:end-1));

%% Prepare Report 
if verLessThan('matlab', '9.8')
    summary = readtable('report_template.xlsx', 'ReadVariableNames',false);
else
    summary = readtable('report_template.xlsx', 'ReadVariableNames',false,'Format','auto');
end
summary.Var2 = string(summary.Var2);
summary{1, 2} = string(v.Release(2:end-1));
summary{2, 2} = string(datestr(now,'yyyy-mm-dd'));
summary{3, 2} = string(datestr(now,'hh:MM'));

summary{5, 2} = height(testReport.failed);
summary{6, 2} = height(testReport.warning);
summary{7, 2} = height(testReport.accepted);
summary{8, 2} = height(testReport.passed);

% for ii = 1:length(result_types)
%     testReport.(result_types{ii}) = sortrows(testReport.(result_types{ii}), [1 2]);
% end

%% Write Report
tryWrite = true;
writeSuccess = false;
while tryWrite
    try
        copyfile('report_template.xlsx', filename);
        warning('off','MATLAB:xlswrite:AddSheet'); %optional
        writetable(summary,filename,'Sheet','Summary', 'WriteVariableNames', false);
        writetable(testReport.failed,filename,'Sheet','Failed Tests');
        writetable(testReport.warning,filename,'Sheet','Warnings');
        writetable(testReport.accepted,filename,'Sheet','Accepted Differences');
        writetable(testReport.passed,filename,'Sheet','Passed Tests');
        tryWrite = false;
        writeSuccess = true;
    catch
        opts.Interpreter = 'none';
        opts.Default = 'Retry';
        quest = 'Could not write error report.';
        answer = questdlg(quest,'File access error',...
                          'Retry','Cancel',opts);
        if ~strcmp(answer, 'Retry')
            tryWrite = false;
        end
    end
end

if writeSuccess
    try %#ok<TRYNC> % Will throw an error, if the excel is not installed.
        winopen(filename);
    end
end
    
