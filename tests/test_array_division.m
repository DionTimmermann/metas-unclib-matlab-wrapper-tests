%% Unit Tests of array division for uncLib
% This script tests the behavior of the array division (./ and .\). The
% scipt compares the output and error messages of size on double and unc
% variables. It uses the function
%
%compare_a_dbl_unc(a, b, 'code');
%
% where the first two parameters define the values of the variables a and 
% b. The last parameter is code that is executed with after theses two variables 
% have been defined. The function first casts a and b as doubles and executes the 
% code. It then casts a and b as unc variables and executes the code again. The 
% behavior (error messages and results) are compared.
% 
% The global variable unc determines which type of unc varaible is used for 
% the testing.

global unc;
global automatedUnc;
global automatedTestScript;
unc = @DistProp;
%% 1. ./ division (rdivide)
% 1.1. Division of a Scalar and a Vector

% DistProp has numerical differences of up to 1e-13. We accept these.
callStack = dbstack;
if (strcmp(callStack(end).name, automatedTestScript) && strcmp(char(automatedUnc), 'DistProp')) || ...
   (~strcmp(callStack(end).name, automatedTestScript) && strcmp(char(unc), 'DistProp'))
    maxDifference = 1e-13;
else
    maxDifference = 0;
end

% Vector/Scalar Division
compare_a_dbl_unc(rand(1), rand(1, 3), 'a=a./b;', 'MaxDifference', maxDifference);
compare_a_dbl_unc(rand(1, 3), rand(1), 'a=a./b;', 'MaxDifference', maxDifference);
compare_a_dbl_unc(rand(1), rand(3, 1), 'a=a./b;', 'MaxDifference', maxDifference);
compare_a_dbl_unc(rand(3, 1), rand(1), 'a=a./b;', 'MaxDifference', maxDifference);
% 1.2. Division of a Vector and a Vector

% Vector/Vector Division (Correct number of elements)
compare_a_dbl_unc(rand(1, 3), rand(1, 3), 'a=a./b;', 'MaxDifference', maxDifference);
compare_a_dbl_unc(rand(1, 3), rand(3, 1), 'a=a./b;', 'MaxDifference', maxDifference);
compare_a_dbl_unc(rand(3, 1), rand(1, 3), 'a=a./b;', 'MaxDifference', maxDifference);
compare_a_dbl_unc(rand(3, 1), rand(3, 1), 'a=a./b;', 'MaxDifference', maxDifference);

% Vector/Vector Division (Incorrect number of elements)

% Flag to account for some error messages becomming more specific over time. 
if verLessThan('matlab', '9.10') % Error messages changed in 2021a
    accept = 'differentErrors';
else
    accept = [];
end
compare_a_dbl_unc(rand(1, 4), rand(1, 3), 'a=a./b;', 'Accept', accept);
compare_a_dbl_unc(rand(1, 4), rand(3, 1), 'a=a./b;', 'MaxDifference', maxDifference);
compare_a_dbl_unc(rand(4, 1), rand(1, 3), 'a=a./b;', 'MaxDifference', maxDifference);
compare_a_dbl_unc(rand(4, 1), rand(3, 1), 'a=a./b;', 'Accept', accept);

%% 2. .\ division (ldivide)
% 2.1. Division of a Scalar and a Vector

% Vector\Scalar Division
compare_a_dbl_unc(rand(1), rand(1, 3), 'a=a.\b;', 'MaxDifference', maxDifference);
compare_a_dbl_unc(rand(1, 3), rand(1), 'a=a.\b;', 'MaxDifference', maxDifference);
compare_a_dbl_unc(rand(1), rand(3, 1), 'a=a.\b;', 'MaxDifference', maxDifference);
compare_a_dbl_unc(rand(3, 1), rand(1), 'a=a.\b;', 'MaxDifference', maxDifference);
% 2.2. Division of a Vector and a Vector

% Vector\Vector Division (Correct number of elements)
compare_a_dbl_unc(rand(1, 3), rand(1, 3), 'a=a.\b;', 'MaxDifference', maxDifference);
compare_a_dbl_unc(rand(1, 3), rand(3, 1), 'a=a.\b;', 'MaxDifference', maxDifference);
compare_a_dbl_unc(rand(3, 1), rand(1, 3), 'a=a.\b;', 'MaxDifference', maxDifference);
compare_a_dbl_unc(rand(3, 1), rand(3, 1), 'a=a.\b;', 'MaxDifference', maxDifference);

% Vector\Vector Division (Incorrect number of elements)

compare_a_dbl_unc(rand(1, 4), rand(1, 3), 'a=a.\b;', 'Accept', accept);
compare_a_dbl_unc(rand(1, 4), rand(3, 1), 'a=a.\b;', 'MaxDifference', maxDifference);
compare_a_dbl_unc(rand(4, 1), rand(1, 3), 'a=a.\b;', 'MaxDifference', maxDifference);
compare_a_dbl_unc(rand(4, 1), rand(3, 1), 'a=a.\b;', 'Accept', accept);
