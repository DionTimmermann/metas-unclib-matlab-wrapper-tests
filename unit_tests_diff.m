%% Unit Tests of diff for uncLib
% This script tests the behavior of the function diff, which determines the 
% number of dimensions of a variables. The scipt compares the output and error 
% messages of diff on double and unc variables. It uses the function

%compare_ans_dbl_unc(a, 'command');
%% 
% where the first parameter defines the values of the variable a. The second 
% parameter is code that is executed with after the variable has been defined. 
% The function first casts a as a double and exectes the code. It then casts a 
% as an unc variable and executes the code again. The behavior (error messages 
% and returned value, i.e. the value of ans) are compared.
% 
% The global variable unc determines which type of unc varaible is used for 
% the testing.

global unc;
unc = @LinProp;
%% 1. Single Input

% Input validation
compare_ans_dbl_unc('diff({})');

compare_ans_dbl_unc([], 'diff(a)');
compare_ans_dbl_unc(rand(1), 'diff(a)');
compare_ans_dbl_unc(rand(1, 3), 'diff(a)');
compare_ans_dbl_unc(rand(3, 1), 'diff(a)');
compare_ans_dbl_unc(rand(3, 3), 'diff(a)');
compare_ans_dbl_unc(rand(3, 3, 3), 'diff(a)');
%% 2. Two Inputs

% Input validation
compare_ans_dbl_unc(rand(1, 3), 'diff(a, [])');
compare_ans_dbl_unc(rand(1, 3), 'diff(a, '':'')');
compare_ans_dbl_unc(rand(1, 3), 'diff(a, -1)');
compare_ans_dbl_unc(rand(1, 3), 'diff(a, 1.1)');
compare_ans_dbl_unc(rand(1, 3), 'diff(a, Inf)');
compare_ans_dbl_unc(rand(1, 3), 'diff(a, NaN)');
compare_ans_dbl_unc(rand(1, 3), 'diff(a, [1 2 3])');
compare_ans_dbl_unc(rand(1, 3), 'diff(a, {})');
compare_ans_dbl_unc(rand(1, 3), 'diff(a, unc(1))');

compare_ans_dbl_unc([], 'diff(a, 1)');
compare_ans_dbl_unc(rand(1), 'diff(a, 1)');
compare_ans_dbl_unc(rand(1, 3), 'diff(a, 1)');
compare_ans_dbl_unc(rand(3, 1), 'diff(a, 1)');
compare_ans_dbl_unc(rand(3, 3), 'diff(a, 1)');
compare_ans_dbl_unc(rand(3, 3, 3), 'diff(a, 1)');

compare_ans_dbl_unc([], 'diff(a, 2)');
compare_ans_dbl_unc(rand(1), 'diff(a, 2)');
compare_ans_dbl_unc(rand(1, 3), 'diff(a, 2)');
compare_ans_dbl_unc(rand(3, 1), 'diff(a, 2)');
compare_ans_dbl_unc(rand(3, 3), 'diff(a, 2)');
compare_ans_dbl_unc(rand(3, 3, 3), 'diff(a, 2)');

compare_ans_dbl_unc([], 3, 'diff(a, 3)');
compare_ans_dbl_unc(rand(1), 3, 'diff(a, 3)');
compare_ans_dbl_unc(rand(1, 3), 3, 'diff(a, 3)');
compare_ans_dbl_unc(rand(3, 1), 3, 'diff(a, 3)');
compare_ans_dbl_unc(rand(3, 3), 3, 'diff(a, 3)');
compare_ans_dbl_unc(rand(3, 3, 3), 3, 'diff(a, 3)');

compare_ans_dbl_unc([], 4, 'diff(a, 4)');
compare_ans_dbl_unc(rand(1), 4, 'diff(a, 4)');
compare_ans_dbl_unc(rand(1, 3), 4, 'diff(a, 4)');
compare_ans_dbl_unc(rand(3, 1), 4, 'diff(a, 4)');
compare_ans_dbl_unc(rand(3, 3), 4, 'diff(a, 4)');
compare_ans_dbl_unc(rand(3, 3, 3), 4, 'diff(a, 4)');
%% 3. Three Inputs

% Input validation
compare_ans_dbl_unc(rand(1, 3), 'diff(a, [], [])');
compare_ans_dbl_unc(rand(1, 3), 'diff(a, [], '':'')');
compare_ans_dbl_unc(rand(1, 3), 'diff(a, [], -1)');
compare_ans_dbl_unc(rand(1, 3), 'diff(a, [], 1.1)');
compare_ans_dbl_unc(rand(1, 3), 'diff(a, [], Inf)');
compare_ans_dbl_unc(rand(1, 3), 'diff(a, [], NaN)');
compare_ans_dbl_unc(rand(1, 3), 'diff(a, [], [1 2 3])');
compare_ans_dbl_unc(rand(1, 3), 'diff(a, [], {})');
compare_ans_dbl_unc(rand(1, 3), 'diff(a, [], unc(0))');

compare_ans_dbl_unc([], 'diff(a, [], 1)');
compare_ans_dbl_unc(rand(1), 'diff(a, [], 1)');
compare_ans_dbl_unc(rand(1, 3), 'diff(a, [], 1)');
compare_ans_dbl_unc(rand(3, 1), 'diff(a, [], 1)');
compare_ans_dbl_unc(rand(3, 3), 'diff(a, [], 1)');
compare_ans_dbl_unc(rand(3, 3, 3), 'diff(a, [], 1)');

compare_ans_dbl_unc([], 'diff(a, [], 2)');
compare_ans_dbl_unc(rand(1), 'diff(a, [], 2)');
compare_ans_dbl_unc(rand(1, 3), 'diff(a, [], 2)');
compare_ans_dbl_unc(rand(3, 1), 'diff(a, [], 2)');
compare_ans_dbl_unc(rand(3, 3), 'diff(a, [], 2)');
compare_ans_dbl_unc(rand(3, 3, 3), 'diff(a, [], 2)');

compare_ans_dbl_unc([], 3, 'diff(a, [], 3)');
compare_ans_dbl_unc(rand(1), 'diff(a, [], 3)');
compare_ans_dbl_unc(rand(1, 3), 'diff(a, [], 3)');
compare_ans_dbl_unc(rand(3, 1), 'diff(a, [], 3)');
compare_ans_dbl_unc(rand(3, 3), 'diff(a, [], 3)');
compare_ans_dbl_unc(rand(3, 3, 3), 'diff(a, [], 3)');
compare_ans_dbl_unc(rand(3, 3, 3), 'diff(a, [], 4)');