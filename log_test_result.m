function log_test_result(type, result, output_msg, uncType, depth)

    global automatedTestScript;
    global automatedOutput;
    global testReport;
    
    callStack = dbstack;
    if strcmp(callStack(end).name, automatedTestScript)
        isAutomatedTest = true;
    else
        isAutomatedTest = false;
    end
    
    st = dbstack;
    depth = depth + 1;
    if length(st) >= depth

        [currentPath,~,~] = fileparts(mfilename('fullpath'));
        testFileName = st(depth).file;
        testFilePath = fullfile(currentPath, 'tests', testFileName);
        testFileLine = st(depth).line;
        
        % Based on https://de.mathworks.com/matlabcentral/answers/306876-how-do-i-read-only-a-specific-line-while-reading-a-text-file-in-matlab
        fHandle=fopen(st(depth).file); 
        line = textscan(fHandle,'%s',1,'delimiter','\n', 'headerlines',st(depth).line-1);
        testFileCode = line{1}{1};
        fclose(fHandle);
    end
    
    if any(strcmp(type, {'warning', 'failed'}))
        fid = 2;
    else
        fid = 1;
    end
    
    if ~isAutomatedTest || any(strcmp(type, automatedOutput))
        if ~strcmp(type, 'passed')
            fprintf(fid, '\nIn <a href="matlab:opentoline(''%s'',%i, 1)">%s</a> (<a href="matlab:opentoline(''%s'',%i, 1)">line %i</a>)\n', testFilePath, testFileLine, testFilePath, testFileName, testFileLine, testFileLine);
            fprintf(fid, '> %s\n', testFileCode);
        end
        fprintf(fid, output_msg);
    end
    
    if isAutomatedTest
         testReport.(type) = [testReport.(type); table(string(testFileName), testFileLine, string(testFileCode), string(uncType), string(result), string(output_msg), 'VariableNames', {'Script', 'Line', 'Test', 'UncType', 'Result', 'Message'})];
    end
    
end