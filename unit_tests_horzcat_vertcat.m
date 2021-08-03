%% Unit Tests of horzcat and vertcat for uncLib
% This script tests the behavior of the functions horzcat and vertcat, 
% which concatenate variables. The scipt compares the output and error 
% messages of horzcat and vertcat on double and unc variables. It uses 
% the function

%compare_ans_dbl_unc(a, b, c, d, 'command');
%% 
% where the first parameter defines the values of the variables a, b, c, 
% and d. The second parameter is code that is executed with after the 
% variables have been defined. The function first casts a, b, c, and d 
% as doubles and executes the code. It then casts a, b, c, and d as  unc 
% variables and executes the code again. The behavior (error messages 
% and returned value, i.e. the value of ans) are compared.
% 
% The global variable unc determines which type of unc varaible is used for 
% the testing.

global unc;
unc = @LinProp;
%% 1. Tests

compare_ans_dbl_unc(rand(1, 1, 3), rand(1, 1, 3), rand(1, 1, 3), rand(1, 1, 3), '[a b; c d]');
%% 
%