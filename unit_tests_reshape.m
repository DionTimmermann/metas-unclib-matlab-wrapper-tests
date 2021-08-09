%% Unit Tests of reshape for uncLib
% This script tests the behavior of the function reshape. The scipt compares 
% the output and error messages of reshape on double and unc varaibles. It uses 
% the function

%compare_a_dbl_unc(a, 'a(:, :)');
%% 
% where the first parameter defines the values of the variable a. The last parameter 
% is code that is executed with after the variable has been defined. The function 
% first casts a as a double and exectes the code. It then casts a as an unc variable 
% and executes the code again. The behavior (error messages and value of a) are compared.
% 
% The global variable unc determines which type of unc varaible is used for 
% the testing.

global unc;
unc = @LinProp;
%% 1. General tests
% reshape depends on several other functions, like size and subsref. Errors in 
% these tests might be caused by errors in other functions.

compare_a_dbl_unc(rand(1, 2, 3), 'a = reshape(a, [], 1)');
compare_a_dbl_unc(rand(1, 2), 'a = reshape(a, [], 1)');
compare_a_dbl_unc(rand(3, 2), 'a = reshape(a, 1, [])');

compare_a_dbl_unc(rand(1, 2, 3), 'b = reshape(a, [], 1)');
compare_a_dbl_unc(rand(1, 2), 'b = reshape(a, [], 1)');
compare_a_dbl_unc(rand(3, 2), 'b = reshape(a, 1, [])');