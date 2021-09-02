%% Unit Tests of addition and subtraction for uncLib
% This script tests the behavior of addition and subtraction in the UncLib.
% 
% The global variable unc determines which type of unc varaible is used for 
% the testing.

global unc;
unc = @LinProp;
%% Bugs in UncLib
% Version 2.4.9

compare_ans_dbl_unc([], [], 'a=reshape(a, 1, 0); a+b;');
compare_ans_dbl_unc([], [], 'a=reshape(a, 1, 0); a-b;');