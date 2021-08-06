clear;
clc;

testFolder = 'tests';
testPrefix = 'test_';

[currentPath,currentScript,~] = fileparts(mfilename('fullpath'));
cd(currentPath);
files = dir(testFolder);
addpath('.');
cd(testFolder);

uncTypes = {@LinProp, @DistProp, @MCProp};

global automatedUnc;
global testReportFailed;
global testReportWarning;
global testReportAccepted;
global testReportPassed;
global automatedTestScript;

automatedTestScript = currentScript;

testReportFailed = table([], [], [], [], [], [], 'VariableNames', {'Script', 'Line', 'Test', 'UncType', 'Result', 'Message'});
testReportWarning = table([], [], [], [], [], [], 'VariableNames', {'Script', 'Line', 'Test', 'UncType', 'Result', 'Message'});
testReportAccepted = table([], [], [], [], [], [], 'VariableNames', {'Script', 'Line', 'Test', 'UncType', 'Result', 'Message'});
testReportPassed = table([], [], [], [], [], [], 'VariableNames', {'Script', 'Line', 'Test', 'UncType', 'Result', 'Message'});

for ii = 1:numel(files)
    
    if ~startsWith(files(ii).name, testPrefix) || ~endsWith(files(ii).name, '.m')
        continue;
    end
    filemane = fullfile(testFolder, files(ii).name);

    for tt = 1:numel(uncTypes)
        automatedUnc = uncTypes{tt};
        
        eval(files(ii).name(1:end-2));
        
    end
end

cd('..');

v=ver('matlab');
filename = sprintf('reports/%s-test-report-MATLAB-%s.xlsx', datestr(now,'yyyy-mm-dd'), v.Release(2:end-1));

%%

if verLessThan('matlab', '9.8')
    summary = readtable('report_template.xlsx', 'ReadVariableNames',false);
else
    summary = readtable('report_template.xlsx', 'ReadVariableNames',false,'Format','auto');
end
summary.Var2 = string(summary.Var2);
summary{1, 2} = string(v.Release(2:end-1));
summary{2, 2} = string(datestr(now,'yyyy-mm-dd'));
summary{3, 2} = string(datestr(now,'hh:MM'));

summary{5, 2} = height(testReportFailed);
summary{6, 2} = height(testReportWarning);
summary{7, 2} = height(testReportAccepted);
summary{8, 2} = height(testReportPassed);
%%
tryWrite = true;
writeSuccess = false;
while tryWrite
    try
        copyfile('report_template.xlsx', filename);
        warning('off','MATLAB:xlswrite:AddSheet'); %optional
        writetable(summary,filename,'Sheet','Summary', 'WriteVariableNames', false);
        writetable(testReportFailed,filename,'Sheet','Failed Tests');
        writetable(testReportWarning,filename,'Sheet','Warnings');
        writetable(testReportAccepted,filename,'Sheet','Accepted Differences');
        writetable(testReportPassed,filename,'Sheet','Passed Tests');
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
    winopen(filename);
end
    