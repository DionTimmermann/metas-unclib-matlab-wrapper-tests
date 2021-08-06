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
filename = sprintf('%s-test-report-MATLAB-%s.xlsx', datestr(now,'yyyy-mm-dd'), v.Release(2:end-1));
%%
delete(filename);
warning('off','MATLAB:xlswrite:AddSheet'); %optional
writetable(testReportFailed,filename,'Sheet','Failed Tests');
writetable(testReportWarning,filename,'Sheet','Warnings');
writetable(testReportAccepted,filename,'Sheet','Accepted Differences');
writetable(testReportPassed,filename,'Sheet','Passed Tests');

winopen(filename);