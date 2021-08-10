%% Unit Tests of repmat for uncLib
% This script tests the behavior of the function repmat. The scipt compares 
% the output and error messages of repmat on double and unc varaibles. It uses 
% the function

%compare_ans_dbl_unc(a, 'a(:, :)');
%% 
% where the first parameter defines the values of the variable a. The last parameter 
% is code that is executed with after the variable has been defined. The function 
% first casts a as a double and exectes the code. It then casts a as an unc variable 
% and executes the code again. The behavior (error messages and returned value, 
% i.e. the value of ans) are compared.
% 
% The global variable unc determines which type of unc varaible is used for 
% the testing.

global unc;
unc = @LinProp;
%% 1. General tests
% Repmat depends on several other functions, like size and subsref. Errors in 
% these tests might be caused by errors in other functions.

compare_ans_dbl_unc(rand(), 'repmat(a, 2, 2)');
compare_ans_dbl_unc(rand(), 'repmat(a, 2, 2, 2)');
compare_ans_dbl_unc(rand(), 'repmat(a, 2, 2, 2, 2)');