%% Unit Tests of ndims for uncLib
% This script tests the behavior of the function ndims, which determines the 
% number of dimensions of a variables. The scipt compares the output and error 
% messages of ndims on double and unc variables. It uses the function

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
%% 1. Tests

% The following code compares the value of ans after
%   tmp = rand(1, 3);
%   a = double(tmp);
%   a(:, :);
% and this
%   a = unc(tmp);
%   a(:, :);
compare_ans_dbl_unc(rand(1, 3), 'ndims(a)');
compare_ans_dbl_unc([], 'ndims(a)');
compare_ans_dbl_unc(3, 'ndims(a)');
compare_ans_dbl_unc(zeros(1, 1), 'ndims(a)');
compare_ans_dbl_unc(1:3, 'ndims(a)');
compare_ans_dbl_unc([1 2 3], 'ndims(a)');
compare_ans_dbl_unc([1 2 3]', 'ndims(a)');
compare_ans_dbl_unc(rand(1, 2, 3, 4, 5), 'ndims(a)');
compare_ans_dbl_unc(rand(5, 1, 1, 1), 'ndims(a)');
compare_ans_dbl_unc(rand(5, 1, 1, 1, 5), 'ndims(a)');

%%