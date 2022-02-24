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
unc = @LinProp;
%% 1. ./ division (rdivide)
% 1.1. Division of a Scalar and a Vector

% Vector/Scalar Division
compare_a_dbl_unc(rand(1), rand(1, 3), 'a=a./b;');
compare_a_dbl_unc(rand(1, 3), rand(1), 'a=a./b;');
compare_a_dbl_unc(rand(1), rand(3, 1), 'a=a./b;');
compare_a_dbl_unc(rand(3, 1), rand(1), 'a=a./b;');
% 1.2. Division of a Vector and a Vector

% Vector/Vector Division (Correct number of elements)
compare_a_dbl_unc(rand(1, 3), rand(1, 3), 'a=a./b;');
compare_a_dbl_unc(rand(1, 3), rand(3, 1), 'a=a./b;');
compare_a_dbl_unc(rand(3, 1), rand(1, 3), 'a=a./b;');
compare_a_dbl_unc(rand(3, 1), rand(3, 1), 'a=a./b;');

% Vector/Vector Division (Incorrect number of elements)

if verLessThan('matlab', '9.9') % Some error messages were changed. The exact version number is just a guess.
    accept = 'differentErrors';
else
    accept = [];
end
compare_a_dbl_unc(rand(1, 4), rand(1, 3), 'a=a./b;', 'Accept', accept);
compare_a_dbl_unc(rand(1, 4), rand(3, 1), 'a=a./b;');
compare_a_dbl_unc(rand(4, 1), rand(1, 3), 'a=a./b;');
compare_a_dbl_unc(rand(4, 1), rand(3, 1), 'a=a./b;', 'Accept', accept);

%% 2. .\ division (ldivide)
% 2.1. Division of a Scalar and a Vector

% Vector\Scalar Division
compare_a_dbl_unc(rand(1), rand(1, 3), 'a=a.\b;');
compare_a_dbl_unc(rand(1, 3), rand(1), 'a=a.\b;');
compare_a_dbl_unc(rand(1), rand(3, 1), 'a=a.\b;');
compare_a_dbl_unc(rand(3, 1), rand(1), 'a=a.\b;');
% 2.2. Division of a Vector and a Vector

% Vector\Vector Division (Correct number of elements)
compare_a_dbl_unc(rand(1, 3), rand(1, 3), 'a=a.\b;');
compare_a_dbl_unc(rand(1, 3), rand(3, 1), 'a=a.\b;');
compare_a_dbl_unc(rand(3, 1), rand(1, 3), 'a=a.\b;');
compare_a_dbl_unc(rand(3, 1), rand(3, 1), 'a=a.\b;');

% Vector\Vector Division (Incorrect number of elements)

if verLessThan('matlab', '9.9') % Some error messages were changed. The exact version number is just a guess.
    accept = 'differentErrors';
else
    accept = [];
end
compare_a_dbl_unc(rand(1, 4), rand(1, 3), 'a=a.\b;', 'Accept', accept);
compare_a_dbl_unc(rand(1, 4), rand(3, 1), 'a=a.\b;');
compare_a_dbl_unc(rand(4, 1), rand(1, 3), 'a=a.\b;');
compare_a_dbl_unc(rand(4, 1), rand(3, 1), 'a=a.\b;', 'Accept', accept);
