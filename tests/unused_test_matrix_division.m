%% Unit Tests of matrix division for uncLib
% This script tests the behavior of the matrix division (\ and /). The
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

%% 1. / division (mrdivide)
% 1.1. Division of a Scalar and a Vector

% Real Scalar and Vector
compare_a_dbl_unc(3, rand(1, 3), 'a=a/b;');
compare_a_dbl_unc(rand(1, 3), 3, 'a=a/b;');
compare_a_dbl_unc(3, rand(3, 1), 'a=a/b;');
compare_a_dbl_unc(rand(3, 1), 3, 'a=a/b;');

% Complex Scalar/Vector
compare_a_dbl_unc(3+4j, rand(1, 3), 'a=a/b;');
compare_a_dbl_unc(rand(1, 3)+1j*rand(1, 3), 3, 'a=a/b;');
compare_a_dbl_unc(3+4j, rand(3, 1), 'a=a/b;');
compare_a_dbl_unc(rand(3, 1)+1j*rand(3, 1), 3, 'a=a/b;');

% Scalar/Complex Vector
compare_a_dbl_unc(3, rand(1, 3)+1j*rand(1, 3), 'a=a/b;');
compare_a_dbl_unc(rand(1, 3), 3+4j, 'a=a/b;');
compare_a_dbl_unc(3, rand(3, 1)+1j*rand(3, 1), 'a=a/b;');
compare_a_dbl_unc(rand(3, 1), 3+4j, 'a=a/b;');
% 1.2. Division of a Vector and a Vector

% Vector/Vector Division
compare_a_dbl_unc(rand(1, 3), rand(1, 3), 'a=a/b;');
compare_a_dbl_unc(rand(3, 1), rand(1, 3), 'a=a/b;');
compare_a_dbl_unc(rand(1, 3), rand(3, 1), 'a=round(double(a/b), 10);'); % This operation causes slightly different results due to the order of operations.
compare_a_dbl_unc(rand(2, 3), rand(3, 4), 'a=round(double(a/b), 10);'); % This operation causes slightly different results due to the order of operations.
compare_a_dbl_unc(rand(3, 1), rand(3, 1), 'a=a/b;');

% Complex Vector/Vector Division
compare_a_dbl_unc(rand(1, 3)+1j*rand(1, 3), rand(1, 3), 'a=a/b;');
compare_a_dbl_unc(rand(3, 1)+1j*rand(3, 1), rand(1, 3), 'a=a/b;');
compare_a_dbl_unc(rand(1, 3)+1j*rand(1, 3), rand(3, 1), 'a=round(double(a/b), 10);'); % This operation causes slightly different results due to the order of operations.
compare_a_dbl_unc(rand(2, 3)+1j*rand(2, 3), rand(3, 4), 'a=round(double(a/b), 10);'); % This operation causes slightly different results due to the order of operations.
compare_a_dbl_unc(rand(3, 1)+1j*rand(3, 1), rand(3, 1), 'a=a/b;');

% Vector/Complex Vector Division
compare_a_dbl_unc(rand(1, 3), rand(1, 3)+1j*rand(1, 3), 'a=a/b;');
compare_a_dbl_unc(rand(3, 1), rand(1, 3)+1j*rand(1, 3), 'a=a/b;');
compare_a_dbl_unc(rand(1, 3), rand(3, 1)+1j*rand(3, 1), 'a=round(double(a/b), 10);'); % This operation causes slightly different results due to the order of operations.
compare_a_dbl_unc(rand(2, 3), rand(3, 4)+1j*rand(3, 4), 'a=round(double(a/b), 10);'); % This operation causes slightly different results due to the order of operations.
compare_a_dbl_unc(rand(3, 1), rand(3, 1)+1j*rand(3, 1), 'a=a/b;');

% 1.3. Division of a Matricies with more than 2 dimensions

% Three-dimensional mutiplication
if verLessThan('matlab', '9.9')
    accept = [];
else
    accept = 'differentErrors';
end
compare_a_dbl_unc(rand(3, 3, 3), rand(3, 3, 3), 'a=a/b;', 'Accept', accept); % Hint to PAGEMTIMES was introduced in 2020b and is currently not applicable to *Prop.

%% 2. \ division (mldivide)
% 2.1. Division of a Scalar and a Vector

% Real Scalar and Vector
compare_a_dbl_unc(3, rand(1, 3), 'a=a\b;');
compare_a_dbl_unc(rand(1, 3), 3, 'a=a\b;');
compare_a_dbl_unc(3, rand(3, 1), 'a=a\b;');
compare_a_dbl_unc(rand(3, 1), 3, 'a=a\b;');

% Complex Scalar\Vector
compare_a_dbl_unc(3+4j, rand(1, 3), 'a=a\b;');
compare_a_dbl_unc(rand(1, 3)+1j*rand(1, 3), 3, 'a=a\b;');
compare_a_dbl_unc(3+4j, rand(3, 1), 'a=a\b;');
compare_a_dbl_unc(rand(3, 1)+1j*rand(3, 1), 3, 'a=a\b;');

% Scalar\Complex Vector
compare_a_dbl_unc(3, rand(1, 3)+1j*rand(1, 3), 'a=a\b;');
compare_a_dbl_unc(rand(1, 3), 3+4j, 'a=a\b;');
compare_a_dbl_unc(3, rand(3, 1)+1j*rand(3, 1), 'a=a\b;');
compare_a_dbl_unc(rand(3, 1), 3+4j, 'a=a\b;');
% 2.2. Division of a Vector and a Vector

% Vector\Vector Division
compare_a_dbl_unc(rand(1, 3), rand(1, 3), 'a=a\b;');
compare_a_dbl_unc(rand(3, 1), rand(1, 3), 'a=a\b;');
compare_a_dbl_unc(rand(1, 3), rand(3, 1), 'a=round(double(a\b), 10);'); % This operation causes slightly different results due to the order of operations.
compare_a_dbl_unc(rand(2, 3), rand(3, 4), 'a=round(double(a\b), 10);'); % This operation causes slightly different results due to the order of operations.
compare_a_dbl_unc(rand(3, 1), rand(3, 1), 'a=a\b;');

% Complex Vector\Vector Division
compare_a_dbl_unc(rand(1, 3)+1j*rand(1, 3), rand(1, 3), 'a=a\b;');
compare_a_dbl_unc(rand(3, 1)+1j*rand(3, 1), rand(1, 3), 'a=a\b;');
compare_a_dbl_unc(rand(1, 3)+1j*rand(1, 3), rand(3, 1), 'a=round(double(a\b), 10);'); % This operation causes slightly different results due to the order of operations.
compare_a_dbl_unc(rand(2, 3)+1j*rand(2, 3), rand(3, 4), 'a=round(double(a\b), 10);'); % This operation causes slightly different results due to the order of operations.
compare_a_dbl_unc(rand(3, 1)+1j*rand(3, 1), rand(3, 1), 'a=a\b;');

% Vector\Complex Vector Division
compare_a_dbl_unc(rand(1, 3), rand(1, 3)+1j*rand(1, 3), 'a=a\b;');
compare_a_dbl_unc(rand(3, 1), rand(1, 3)+1j*rand(1, 3), 'a=a\b;');
compare_a_dbl_unc(rand(1, 3), rand(3, 1)+1j*rand(3, 1), 'a=round(double(a\b), 10);'); % This operation causes slightly different results due to the order of operations.
compare_a_dbl_unc(rand(2, 3), rand(3, 4)+1j*rand(3, 4), 'a=round(double(a\b), 10);'); % This operation causes slightly different results due to the order of operations.
compare_a_dbl_unc(rand(3, 1), rand(3, 1)+1j*rand(3, 1), 'a=a\b;');

% 2.3. Division of a Matricies with more than 2 dimensions

% Three-dimensional mutiplication
if verLessThan('matlab', '9.9')
    accept = [];
else
    accept = 'differentErrors';
end
compare_a_dbl_unc(rand(3, 3, 3), rand(3, 3, 3), 'a=a\b;', 'Accept', accept); % Hint to PAGEMTIMES was introduced in 2020b and is currently not applicable to *Prop.
%% 
%