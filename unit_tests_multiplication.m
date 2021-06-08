%% Unit Tests of multiplication for uncLib
% This script tests the behavior of the multiplication, which determines the 
% number of dimensions of a variables. The scipt compares the output and error 
% messages of size on double and unc variables. It uses the function

%compare_a_dbl_unc(a, b, 'code');
%% 
% where the first two parameters define the values of the variables a and and 
% b. The last parameter is code that is executed with after theses two variables 
% have been defined. The function first casts a and b as doubles and exectes the 
% code. It then casts a and b as unc variables and executes the code again. The 
% behavior (error messages and results) are compared.
% 
% The global variable unc determines which type of unc varaible is used for 
% the testing.

global unc;
unc = @LinProp;
%% 1. .* multiplication (times)

% Vector/Scalar Multiplication
compare_a_dbl_unc(rand(1), rand(1, 3), 'a=a.*b;');
compare_a_dbl_unc(rand(1, 3), rand(1), 'a=a.*b;');
compare_a_dbl_unc(rand(1), rand(3, 1), 'a=a.*b;');
compare_a_dbl_unc(rand(3, 1), rand(1), 'a=a.*b;');

% Vector/Vector Multiplication (Correct number of elements)
compare_a_dbl_unc(rand(1, 3), rand(1, 3), 'a=a.*b;');
compare_a_dbl_unc(rand(1, 3), rand(3, 1), 'a=a.*b;');
compare_a_dbl_unc(rand(3, 1), rand(1, 3), 'a=a.*b;');
compare_a_dbl_unc(rand(3, 1), rand(3, 1), 'a=a.*b;');

% Vector/Vector Multiplication (Incorrect number of elements)
compare_a_dbl_unc(rand(1, 4), rand(1, 3), 'a=a.*b;');
compare_a_dbl_unc(rand(1, 4), rand(3, 1), 'a=a.*b;');
compare_a_dbl_unc(rand(4, 1), rand(1, 3), 'a=a.*b;');
compare_a_dbl_unc(rand(4, 1), rand(3, 1), 'a=a.*b;');

%% 1. * multiplication (mtimes)
% Scalar/Vector Multiplication
compare_a_dbl_unc(3, rand(1, 3), 'a=a*b;');
compare_a_dbl_unc(rand(1, 3), 3, 'a=a*b;');
compare_a_dbl_unc(3, rand(3, 1), 'a=a*b;');
compare_a_dbl_unc(rand(3, 1), 3, 'a=a*b;');

% Vector/Vector Multiplication
compare_a_dbl_unc(rand(1, 3), rand(1, 3), 'a=a*b;');
compare_a_dbl_unc(rand(3, 1), rand(1, 3), 'a=a*b;');
compare_a_dbl_unc(rand(1, 3), rand(3, 1), 'a=a*b;');
compare_a_dbl_unc(rand(3, 1), rand(3, 1), 'a=a*b;');

% Complex Scalar/Vector Multiplication
compare_a_dbl_unc(3+4j, rand(1, 3), 'a=a*b;');
compare_a_dbl_unc(rand(1, 3)+1j*rand(1, 3), 3, 'a=a*b;');
compare_a_dbl_unc(3+4j, rand(3, 1), 'a=a*b;');
compare_a_dbl_unc(rand(3, 1)+1j*rand(3, 1), 3, 'a=a*b;');

% Complex Vector/Vector Multiplication
compare_a_dbl_unc(rand(1, 3)+1j*rand(1, 3), rand(1, 3), 'a=a*b;');
compare_a_dbl_unc(rand(3, 1)+1j*rand(3, 1), rand(1, 3), 'a=a*b;');
compare_a_dbl_unc(rand(1, 3)+1j*rand(1, 3), rand(3, 1), 'a=a*b;');
compare_a_dbl_unc(rand(3, 1)+1j*rand(3, 1), rand(3, 1), 'a=a*b;');

% Scalar/Complex Vector Multiplication
compare_a_dbl_unc(3, rand(1, 3)+1j*rand(1, 3), 'a=a*b;');
compare_a_dbl_unc(rand(1, 3), 3+4j, 'a=a*b;');
compare_a_dbl_unc(3, rand(3, 1)+1j*rand(3, 1), 'a=a*b;');
compare_a_dbl_unc(rand(3, 1), 3+4j, 'a=a*b;');

% Vector/Complex Vector Multiplication
compare_a_dbl_unc(rand(1, 3), rand(1, 3)+1j*rand(1, 3), 'a=a*b;');
compare_a_dbl_unc(rand(3, 1), rand(1, 3)+1j*rand(1, 3), 'a=a*b;');
compare_a_dbl_unc(rand(1, 3), rand(3, 1)+1j*rand(3, 1), 'a=a*b;');
compare_a_dbl_unc(rand(3, 1), rand(3, 1)+1j*rand(3, 1), 'a=a*b;');

% Three-dimensional mutiplication
compare_a_dbl_unc(rand(3, 3, 3), rand(3, 3, 3), 'a=a*b;');
%% 
%