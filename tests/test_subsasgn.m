%% Unit Tests of subsasgn for uncLib
% This script tests the behavior of the function subsasgn, which is called in 
% statements like a(:, :) = b; . The scipt compares the output and error messages 
% of subsasgn on double and unc varaibles. It uses the function

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
%% 0. Introduction
%% 0.1. Simple Tests
% These tests should not fail

% The following code compares
%   a = double(zeros(1, 3));
%   b = double(ones(1, 3));
%   a(:, :) = b;
% with
%   a = unc(zeros(1, 3));
%   b = unc(ones(1, 3));
%   a(:, :) = b;
compare_a_dbl_unc(zeros(1, 3), ones(1, 3), 'a(:, :) = b;');

% And with `a = double(zeros(3));` vs `a = unc(zeros(3));`
compare_a_dbl_unc(zeros(3), ones(3), 'a(:, :) = b;');

compare_a_dbl_unc(zeros(3), 1, 'a(:, :) = b;');
%% 0.2 Types of Errors in old subsasgn implementation
% 0.2.1 Assignment of incorrect values Instead of shifiting b from 1-by-3 to 
% 1-by-1-by-3, b(1, 1) is inserted three times into a(1, 1, 1:3);

% a = zeros(1, 1, 3); b = [1 2 3];
compare_a_dbl_unc(zeros(1, 1, 3), [1 2 3], 'a(:, :, :) = b;');
% 0.2.2 Error when trying to access incorrect index
% Instead of shifiting b from 3-by-1 to 1-by-3, LinProp tries to assign a(1, 
% 1:3) = b(1, 1:3) and fails with an error, as b(1, 2:3) do not exist.

% a = zeros(1, 3); b = [1 2 3]';
compare_a_dbl_unc(zeros(1, 3), [1 2 3]', 'a(:, :) = b;');
% 0.2.3 Assignment, even when number of elements does not match
% Instead of throwing the error message "Unable to perform assignment because 
% the size of the left side is 1-by-2 and the size of the right side is 1-by-4." 
% the follwoing code executes, as if the command had been a(:, :) = b(1, 1:2);

% a = zeros(1, 2); b = [1 2 3 4];
compare_a_dbl_unc(zeros(1, 2), [1 2 3 4], 'a(:, :) = b;');
% 0.2.4 Codes does not return
% The following code never completes.

% a = zeros(3); b = 1;
compare_a_dbl_unc(zeros(3), 1, 'a(2:5) = b;'); 
% 0.2.5 Missing Features
% The old implemation of subsasn also did not respect several sepcial cases, 
% like logical indexing or the null assignment to remove parts of a matrix.
%% 1. Scalar Assignment
% 1.1. Linear Indexing In Matlab, matricies and vectors can be index linearly, 
% i.e. as if they were a vector. 1.1.1. Linear Indexing of Vectors

% Automatic size
compare_a_dbl_unc(zeros(1, 3), 1, 'a(:) = b;');
compare_a_dbl_unc(zeros(3, 1), 1, 'a(:) = b;');

% Manual, correct size
compare_a_dbl_unc(zeros(1, 3), 1, 'a(1:3) = b;');
compare_a_dbl_unc(zeros(3, 1), 1, 'a(1:3) = b;');

compare_a_dbl_unc(zeros(1, 3), 1, 'a([1 3]) = b;');
compare_a_dbl_unc(zeros(3, 1), 1, 'a([1 3]) = b;');

% Manual vector, a has to grow
compare_a_dbl_unc(zeros(1, 3), 1, 'a(1:4) = b;');
compare_a_dbl_unc(zeros(3, 1), 1, 'a(1:4) = b;');

compare_a_dbl_unc(zeros(1, 3), 1, 'a(5:6) = b;');
compare_a_dbl_unc(zeros(3, 1), 1, 'a(5:6) = b;');

% Manual single element, a has to grow
compare_a_dbl_unc(zeros(1, 3), 1, 'a(5) = b;');
compare_a_dbl_unc(zeros(3, 1), 1, 'a(5) = b;');

% Manual multiple elements, a has to grow
compare_a_dbl_unc(zeros(1, 3), 1, 'a([5 7]) = b;');
compare_a_dbl_unc(zeros(3, 1), 1, 'a([5 7]) = b;');
% 1.1.2. Linear Indexing of Matricies

% Automatic size
compare_a_dbl_unc(zeros(3), 1, 'a(:) = b;');

% Manual, correct size
compare_a_dbl_unc(zeros(3), 1, 'a(1:3) = b;');  % Some values, from beginning
compare_a_dbl_unc(zeros(3), 1, 'a(2:5) = b;');  % Some values, from middle
compare_a_dbl_unc(zeros(3), 1, 'a(7:9) = b;');  % Some values, from end
compare_a_dbl_unc(zeros(3), 1, 'a(1:9) = b;');  % All values

% Manual vector, a has to grow
compare_a_dbl_unc(zeros(3), 1, 'a(1:10) = b;');
compare_a_dbl_unc(zeros(3), 1, 'a(1:12) = b;');
compare_a_dbl_unc(zeros(3), 1, 'a(11:12) = b;');

% Manual single element, a has to grow
compare_a_dbl_unc(zeros(3), 1, 'a(10) = b;');
compare_a_dbl_unc(zeros(3), 1, 'a(12) = b;');
% 1.2. Partial Linear Indexing of Matricies
% Matricies can also be partially linearly indexed, with the first n dimensions 
% being addressed by n subscripts and the remaining dimensions by linear indexing.
% 
% Tests with the first dimensions being indexed with scalars.

% Automatic size
compare_a_dbl_unc(zeros(3, 3, 3, 3), 1, 'a(1, 2, :) = b;');

% Manual, correct size
compare_a_dbl_unc(zeros(3, 3, 3, 3), 1, 'a(1, 2, 1:3) = b;');  % Some values, from beginning
compare_a_dbl_unc(zeros(3, 3, 3, 3), 1, 'a(1, 2, 2:5) = b;');  % Some values, from middle
compare_a_dbl_unc(zeros(3, 3, 3, 3), 1, 'a(1, 2, 7:9) = b;');  % Some values, from end
compare_a_dbl_unc(zeros(3, 3, 3, 3), 1, 'a(1, 2, 1:9) = b;');  % All values

% Manual, some values
compare_a_dbl_unc(zeros(3, 3, 3, 3), 1, 'a(1, 2, [3 7]) = b;');
compare_a_dbl_unc(zeros(3, 3, 3, 3), 1, 'a(1, 2, [1 2]) = b;');

% Manual vector, a has to grow
compare_a_dbl_unc(zeros(3, 3, 3, 3), 1, 'a(1, 2, 1:10) = b;');
compare_a_dbl_unc(zeros(3, 3, 3, 3), 1, 'a(1, 2, 1:12) = b;');
compare_a_dbl_unc(zeros(3, 3, 3, 3), 1, 'a(1, 2, 11:12) = b;');

% Manual single element, a has to grow
compare_a_dbl_unc(zeros(3, 3, 3, 3), 1, 'a(1, 2, 10) = b;');
compare_a_dbl_unc(zeros(3, 3, 3, 3), 1, 'a(1, 2, 12) = b;');
%% 
% Tests with the first dimensions being indexed with vectors.

% Automatic size
compare_a_dbl_unc(zeros(3, 3, 3, 3), 1, 'a(:, :, :) = b;');

% Manual, correct size
compare_a_dbl_unc(zeros(3, 3, 3, 3), 1, 'a(:, :, 1:3) = b;');  % Some values, from beginning
compare_a_dbl_unc(zeros(3, 3, 3, 3), 1, 'a(:, :, 2:5) = b;');  % Some values, from middle
compare_a_dbl_unc(zeros(3, 3, 3, 3), 1, 'a(:, :, 7:9) = b;');  % Some values, from end
compare_a_dbl_unc(zeros(3, 3, 3, 3), 1, 'a(:, :, 1:9) = b;');  % All values

% Manual, some values
compare_a_dbl_unc(zeros(3, 3, 3, 3), 1, 'a(1, 2, [3 7]) = b;');
compare_a_dbl_unc(zeros(3, 3, 3, 3), 1, 'a(1, 2, [1 2]) = b;');

% Manual vector, a has to grow
compare_a_dbl_unc(zeros(3, 3, 3, 3), 1, 'a(:, :, 1:10) = b;');
compare_a_dbl_unc(zeros(3, 3, 3, 3), 1, 'a(:, :, 1:12) = b;');
compare_a_dbl_unc(zeros(3, 3, 3, 3), 1, 'a(:, :, 11:12) = b;');

% Manual single element, a has to grow
compare_a_dbl_unc(zeros(3, 3, 3, 3), 1, 'a(:, :, 10) = b;');
compare_a_dbl_unc(zeros(3, 3, 3, 3), 1, 'a(:, :, 12) = b;');
%% 2. Matrix Assignment
% 2.1. Linear Indexing 2.1.1 Linear Indexing of Vectors

% Automatic size
compare_a_dbl_unc(zeros(1, 3), [1, 2, 3], 'a(:) = b;');
compare_a_dbl_unc(zeros(3, 1), [1, 2, 3], 'a(:) = b;');
compare_a_dbl_unc(zeros(1, 3), [1; 2; 3], 'a(:) = b;');
compare_a_dbl_unc(zeros(3, 1), [1; 2; 3], 'a(:) = b;');

% Manual, correct size
compare_a_dbl_unc(zeros(1, 3), [1, 2, 3], 'a(1:3) = b;');
compare_a_dbl_unc(zeros(3, 1), [1, 2, 3], 'a(1:3) = b;');
compare_a_dbl_unc(zeros(1, 3), [1; 2; 3], 'a(1:3) = b;');
compare_a_dbl_unc(zeros(3, 1), [1; 2; 3], 'a(1:3) = b;');

% Manual vector, a has to grow, b with incorrect size
compare_a_dbl_unc(zeros(1, 3), [1, 2, 3], 'a(1:4) = b;');
compare_a_dbl_unc(zeros(3, 1), [1, 2, 3], 'a(1:4) = b;');
compare_a_dbl_unc(zeros(1, 3), [1; 2; 3], 'a(1:4) = b;');
compare_a_dbl_unc(zeros(3, 1), [1; 2; 3], 'a(1:4) = b;');

% Manual vector, a has to grow, b with correct size
compare_a_dbl_unc(zeros(1, 3), [1, 2, 3, 4], 'a(1:4) = b;');
compare_a_dbl_unc(zeros(3, 1), [1, 2, 3, 4], 'a(1:4) = b;');
compare_a_dbl_unc(zeros(1, 3), [1; 2; 3; 4], 'a(1:4) = b;');
compare_a_dbl_unc(zeros(3, 1), [1; 2; 3; 4], 'a(1:4) = b;');

% Manual vector, a has to grow, b with correct size but incorrect dimension
compare_a_dbl_unc(zeros(1, 3), [1, 2; 3, 4], 'a(1:4) = b;');
compare_a_dbl_unc(zeros(3, 1), [1, 2; 3, 4], 'a(1:4) = b;');

% Manual vector, a has to grow, assignment bordering original bounds
compare_a_dbl_unc(zeros(1, 3), [1, 2, 3], 'a(4:6) = b;');
compare_a_dbl_unc(zeros(3, 1), [1, 2, 3], 'a(4:6) = b;');
compare_a_dbl_unc(zeros(1, 3), [1; 2; 3], 'a(4:6) = b;');
compare_a_dbl_unc(zeros(3, 1), [1; 2; 3], 'a(4:6) = b;');

% Manual vector, a has to grow, assignment far outside orignal bounds
compare_a_dbl_unc(zeros(1, 3), [1, 2, 3], 'a(7:9) = b;');
compare_a_dbl_unc(zeros(3, 1), [1, 2, 3], 'a(7:9) = b;');
compare_a_dbl_unc(zeros(1, 3), [1; 2; 3], 'a(7:9) = b;');
compare_a_dbl_unc(zeros(3, 1), [1; 2; 3], 'a(7:9) = b;');
% 2.1.2. Linear Indexing of Matricies

% Automatic size
compare_a_dbl_unc(zeros(3, 3), magic(3), 'a(:) = b;');

% Manual, correct size
compare_a_dbl_unc(zeros(3), [1, 2, 3], 'a(1:3) = b;');  % Some values, from beginning
compare_a_dbl_unc(zeros(3), [1, 2, 3], 'a(2:4) = b;');  % Some values, from middle
compare_a_dbl_unc(zeros(3), [1, 2, 3], 'a(7:9) = b;');  % Some values, from end
compare_a_dbl_unc(zeros(3), 1:9, 'a(1:9) = b;');  % All values
compare_a_dbl_unc(zeros(3), [1; 2; 3], 'a(1:3) = b;');  % Some values, from beginning
compare_a_dbl_unc(zeros(3), [1; 2; 3], 'a(2:4) = b;');  % Some values, from middle
compare_a_dbl_unc(zeros(3), [1; 2; 3], 'a(7:9) = b;');  % Some values, from end
compare_a_dbl_unc(zeros(3), (1:9)', 'a(1:9) = b;');  % All values

% Manual, incorrect size
compare_a_dbl_unc(zeros(3), [1, 2], 'a(1:3) = b;');  % Some values, from beginning
compare_a_dbl_unc(zeros(3), [1, 2], 'a(2:4) = b;');  % Some values, from middle
compare_a_dbl_unc(zeros(3), [1, 2], 'a(7:9) = b;');  % Some values, from end
compare_a_dbl_unc(zeros(3), 1:8, 'a(1:9) = b;');  % All values
compare_a_dbl_unc(zeros(3), [1; 2], 'a(1:3) = b;');  % Some values, from beginning
compare_a_dbl_unc(zeros(3), [1; 2], 'a(2:4) = b;');  % Some values, from middle
compare_a_dbl_unc(zeros(3), [1; 2], 'a(7:9) = b;');  % Some values, from end
compare_a_dbl_unc(zeros(3), (1:8)', 'a(1:9) = b;');  % All values

compare_a_dbl_unc(zeros(3), [1, 2; 3, 4], 'a(2:5) = b;');  % Incorrect Dimensions

% Manual vector, a has to grow
compare_a_dbl_unc(zeros(3), [1, 2, 3, 4], 'a(9:12) = b;');
compare_a_dbl_unc(zeros(3), [1, 2, 3], 'a(10:12) = b;');

% Manual single element, a has to grow
compare_a_dbl_unc(zeros(3), 1, 'a(10) = b;');
compare_a_dbl_unc(zeros(3), 1, 'a(12) = b;');
% 2.2. Partial Linear Indexing
% Matricies can also be partially linearly indexed, with the first n dimensions 
% being addressed by n subscripts and the remaining dimensions by linear indexing.

% Automatic size
compare_a_dbl_unc(zeros(3, 3, 3), magic(3), 'a(1, :) = b;');
compare_a_dbl_unc(zeros(3, 3, 3), magic(3), 'a(2, :) = b;');
compare_a_dbl_unc(zeros(3, 3, 3), magic(3), 'a(3, :) = b;');

compare_a_dbl_unc(zeros(3, 3, 3, 3), magic(3), 'a(1, 2:3) = b;');
compare_a_dbl_unc(zeros(3, 3, 3, 3), magic(3), 'a(1, :, 1, :) = b;');
compare_a_dbl_unc(zeros(3, 3, 3, 3), magic(3), 'a(1, :) = b;');
compare_a_dbl_unc(zeros(3, 3, 3, 3), magic(3), 'a(2, :) = b;');
compare_a_dbl_unc(zeros(3, 3, 3, 3), magic(3), 'a(3, :) = b;');

compare_a_dbl_unc(zeros(3, 3, 3), magic(3), 'a(:, 1) = b;');
compare_a_dbl_unc(zeros(3, 3, 3), magic(3), 'a(:, 2) = b;');
compare_a_dbl_unc(zeros(3, 3, 3), magic(3), 'a(:, 3) = b;');

% Manual, correct size
compare_a_dbl_unc(zeros(3, 3, 3), [1, 2, 3], 'a(2, 1:3) = b;');  % Some values, from beginning
compare_a_dbl_unc(zeros(3, 3, 3), [1, 2, 3], 'a(2, 2:4) = b;');  % Some values, from middle
compare_a_dbl_unc(zeros(3, 3, 3), [1, 2, 3], 'a(2, 7:9) = b;');  % Some values, from end
compare_a_dbl_unc(zeros(3, 3, 3), 1:9, 'a(2, 1:9) = b;');  % All values
compare_a_dbl_unc(zeros(3, 3, 3), [1; 2; 3], 'a(2, 1:3) = b;');  % Some values, from beginning
compare_a_dbl_unc(zeros(3, 3, 3), [1; 2; 3], 'a(2, 2:4) = b;');  % Some values, from middle
compare_a_dbl_unc(zeros(3, 3, 3), [1; 2; 3], 'a(2, 7:9) = b;');  % Some values, from end
compare_a_dbl_unc(zeros(3, 3, 3), (1:9)', 'a(2, 1:9) = b;');  % All values

% Manual, incorrect size
compare_a_dbl_unc(zeros(3, 3, 3), [1, 2], 'a(2, 1:3) = b;');  % Some values, from beginning
compare_a_dbl_unc(zeros(3, 3, 3), [1, 2], 'a(2, 2:4) = b;');  % Some values, from middle
compare_a_dbl_unc(zeros(3, 3, 3), [1, 2], 'a(2, 7:9) = b;');  % Some values, from end
compare_a_dbl_unc(zeros(3, 3, 3), 1:8, 'a(2, 1:9) = b;');  % All values
compare_a_dbl_unc(zeros(3, 3, 3), [1; 2], 'a(2, 1:3) = b;');  % Some values, from beginning
compare_a_dbl_unc(zeros(3, 3, 3), [1; 2], 'a(2, 2:4) = b;');  % Some values, from middle
compare_a_dbl_unc(zeros(3, 3, 3), [1; 2], 'a(2, 7:9) = b;');  % Some values, from end
compare_a_dbl_unc(zeros(3, 3, 3), (1:8)', 'a(2, 1:9) = b;');  % All values

compare_a_dbl_unc(zeros(3, 3, 3), [1, 2; 3, 4], 'a(2, 2:5) = b;');  % Incorrect Dimensions

% Manual vector, a has to grow
compare_a_dbl_unc(zeros(3, 3, 3), [1, 2, 3, 4], 'a(2, 9:12) = b;');
compare_a_dbl_unc(zeros(3, 3, 3), [1, 2, 3], 'a(2, 10:12) = b;');

% Manual single element, a has to grow
compare_a_dbl_unc(zeros(3, 3, 3), 1, 'a(2, 10) = b;');
compare_a_dbl_unc(zeros(3, 3, 3), 1, 'a(2, 12) = b;');
% 2.3. Subscript Indexing
% 2.3.1. With Matching Numbers of Elements

% Row vector in row of matrix
compare_a_dbl_unc(zeros(3, 3), [1, 2, 3], 'a(1, :) = b;');
compare_a_dbl_unc(zeros(3, 3), [1, 2, 3], 'a(2, :) = b;');
compare_a_dbl_unc(zeros(3, 3), [1, 2, 3], 'a(3, :) = b;');
compare_a_dbl_unc(zeros(3, 3), [1, 2, 3], 'a(4, :) = b;');
compare_a_dbl_unc(zeros(3, 3), [1, 2, 3], 'a(5, :) = b;');

% Column vector in column of matrix
compare_a_dbl_unc(zeros(3, 3), [1; 2; 3], 'a(:, 1) = b;');
compare_a_dbl_unc(zeros(3, 3), [1; 2; 3], 'a(:, 2) = b;');
compare_a_dbl_unc(zeros(3, 3), [1; 2; 3], 'a(:, 3) = b;');
compare_a_dbl_unc(zeros(3, 3), [1; 2; 3], 'a(:, 4) = b;');
compare_a_dbl_unc(zeros(3, 3), [1; 2; 3], 'a(:, 5) = b;');

% Row vector in column of matrix
compare_a_dbl_unc(zeros(3, 3), [1, 2, 3], 'a(:, 1) = b;');
compare_a_dbl_unc(zeros(3, 3), [1, 2, 3], 'a(:, 2) = b;');
compare_a_dbl_unc(zeros(3, 3), [1, 2, 3], 'a(:, 3) = b;');
compare_a_dbl_unc(zeros(3, 3), [1, 2, 3], 'a(:, 4) = b;');
compare_a_dbl_unc(zeros(3, 3), [1, 2, 3], 'a(:, 5) = b;');

% Column vector in row of matrix
compare_a_dbl_unc(zeros(3, 3), [1; 2; 3], 'a(1, :) = b;');
compare_a_dbl_unc(zeros(3, 3), [1; 2; 3], 'a(2, :) = b;');
compare_a_dbl_unc(zeros(3, 3), [1; 2; 3], 'a(3, :) = b;');
compare_a_dbl_unc(zeros(3, 3), [1; 2; 3], 'a(4, :) = b;');
compare_a_dbl_unc(zeros(3, 3), [1; 2; 3], 'a(5, :) = b;');
% 2.3.2. With Different Numbers of Elements

% The next 10 rows produce a different error message, but only when using
% eval()...

% Row vector in row of matrix
compare_a_dbl_unc(zeros(3, 3), [1, 2, 3, 4], 'a(1, :) = b;', 'Accept', 'differentErrors');
compare_a_dbl_unc(zeros(3, 3), [1, 2, 3, 4], 'a(2, :) = b;', 'Accept', 'differentErrors');
compare_a_dbl_unc(zeros(3, 3), [1, 2, 3, 4], 'a(3, :) = b;', 'Accept', 'differentErrors');
compare_a_dbl_unc(zeros(3, 3), [1, 2, 3, 4], 'a(4, :) = b;', 'Accept', 'differentErrors');
compare_a_dbl_unc(zeros(3, 3), [1, 2, 3, 4], 'a(5, :) = b;', 'Accept', 'differentErrors');

% Column vector in column of matrix
compare_a_dbl_unc(zeros(3, 3), [1; 2; 3; 4], 'a(:, 1) = b;', 'Accept', 'differentErrors');
compare_a_dbl_unc(zeros(3, 3), [1; 2; 3; 4], 'a(:, 2) = b;', 'Accept', 'differentErrors');
compare_a_dbl_unc(zeros(3, 3), [1; 2; 3; 4], 'a(:, 3) = b;', 'Accept', 'differentErrors');
compare_a_dbl_unc(zeros(3, 3), [1; 2; 3; 4], 'a(:, 4) = b;', 'Accept', 'differentErrors');
compare_a_dbl_unc(zeros(3, 3), [1; 2; 3; 4], 'a(:, 5) = b;', 'Accept', 'differentErrors');

% Row vector in column of matrix
compare_a_dbl_unc(zeros(3, 3), [1, 2, 3, 4], 'a(:, 1) = b;');
compare_a_dbl_unc(zeros(3, 3), [1, 2, 3, 4], 'a(:, 2) = b;');
compare_a_dbl_unc(zeros(3, 3), [1, 2, 3, 4], 'a(:, 3) = b;');
compare_a_dbl_unc(zeros(3, 3), [1, 2, 3, 4], 'a(:, 4) = b;');
compare_a_dbl_unc(zeros(3, 3), [1, 2, 3, 4], 'a(:, 5) = b;');

% Column vector in row of matrix
compare_a_dbl_unc(zeros(3, 3), [1; 2; 3; 4], 'a(1, :) = b;');
compare_a_dbl_unc(zeros(3, 3), [1; 2; 3; 4], 'a(2, :) = b;');
compare_a_dbl_unc(zeros(3, 3), [1; 2; 3; 4], 'a(3, :) = b;');
compare_a_dbl_unc(zeros(3, 3), [1; 2; 3; 4], 'a(4, :) = b;');
compare_a_dbl_unc(zeros(3, 3), [1; 2; 3; 4], 'a(5, :) = b;');

% Row vector in row of matrix
compare_a_dbl_unc(zeros(3, 3), [1, 2], 'a(1, :) = b;');
compare_a_dbl_unc(zeros(3, 3), [1, 2], 'a(2, :) = b;');
compare_a_dbl_unc(zeros(3, 3), [1, 2], 'a(3, :) = b;');
compare_a_dbl_unc(zeros(3, 3), [1, 2], 'a(4, :) = b;');
compare_a_dbl_unc(zeros(3, 3), [1, 2], 'a(5, :) = b;');

% Column vector in column of matrix
compare_a_dbl_unc(zeros(3, 3), [1; 2], 'a(:, 1) = b;');
compare_a_dbl_unc(zeros(3, 3), [1; 2], 'a(:, 2) = b;');
compare_a_dbl_unc(zeros(3, 3), [1; 2], 'a(:, 3) = b;');
compare_a_dbl_unc(zeros(3, 3), [1; 2], 'a(:, 4) = b;');
compare_a_dbl_unc(zeros(3, 3), [1; 2], 'a(:, 5) = b;');

% Row vector in column of matrix
compare_a_dbl_unc(zeros(3, 3), [1, 2], 'a(:, 1) = b;');
compare_a_dbl_unc(zeros(3, 3), [1, 2], 'a(:, 2) = b;');
compare_a_dbl_unc(zeros(3, 3), [1, 2], 'a(:, 3) = b;');
compare_a_dbl_unc(zeros(3, 3), [1, 2], 'a(:, 4) = b;');
compare_a_dbl_unc(zeros(3, 3), [1, 2], 'a(:, 5) = b;');

% Column vector in row of matrix
compare_a_dbl_unc(zeros(3, 3), [1; 2], 'a(1, :) = b;');
compare_a_dbl_unc(zeros(3, 3), [1; 2], 'a(2, :) = b;');
compare_a_dbl_unc(zeros(3, 3), [1; 2], 'a(3, :) = b;');
compare_a_dbl_unc(zeros(3, 3), [1; 2], 'a(4, :) = b;');
compare_a_dbl_unc(zeros(3, 3), [1; 2], 'a(5, :) = b;');

% 2.4. Shifiting
% 2.4.1. Adding a Dimension in Front

compare_a_dbl_unc(zeros(3, 3, 3), rand(3, 3), 'a(1, :, :) = b;');
compare_a_dbl_unc(zeros(3, 3, 3), rand(9, 1), 'a(1, :) = b;');
% 2.4.2. Adding a Dimension in the Middle

compare_a_dbl_unc(zeros(3, 3, 3), rand(3, 3), 'a(:, 2, :) = b;');
% 2.4.3. Adding a Dimension in the Back

compare_a_dbl_unc(zeros(3, 3, 3), rand(3, 3), 'a(:, :, 2) = b;');
compare_a_dbl_unc(zeros(3, 3, 3), rand(3, 1), 'a(:, 2) = b;');
% 2.4.4. Adding Multiple Dimensions

compare_a_dbl_unc(zeros(3, 3, 3, 3, 3), rand(3, 3), 'a(1, :, 3,  :, 2) = b;');
% 2.4.5. Removing a Dimension in Front

compare_a_dbl_unc(zeros(3, 3), rand(1, 3, 3), 'a(:, :) = b;');
% 2.4.6. Removing a Dimension in the Middle

compare_a_dbl_unc(zeros(3, 3), rand(3, 1, 3), 'a(:, :) = b;');
% 2.4.7. Removing a Dimension in the Back

compare_a_dbl_unc(zeros(3, 3), rand(3, 3, 1), 'a(:, :) = b;');
% 2.4.8. Removing Multiple Dimensions

compare_a_dbl_unc(zeros(3, 3), rand(1, 3, 1, 3, 1), 'a(:, :) = b;');
% 2.4.9. Adding and Removing Dimensions

compare_a_dbl_unc(zeros(3, 3, 3, 3, 3), rand(1, 3, 1, 3, 1), 'a(1, :, 3,  :, 2) = b;');
%% 3. Logical Indexing

compare_a_dbl_unc(magic(3), 99, 'a(a>4) = b;');
compare_a_dbl_unc(magic(3), 99, 'a(a(:,:)>4) = b;');
%% 4. Multiple Assignments to the Same Index/Subscript

compare_a_dbl_unc(zeros(1, 3), 1, 'a([1 2 1 2]) = b;');
compare_a_dbl_unc(zeros(3, 1), 1, 'a([1 2 1 2]) = b;');

compare_a_dbl_unc(zeros(1, 3), 1:4, 'a([1 2 1 2]) = b;');
compare_a_dbl_unc(zeros(3, 1), 1:4, 'a([1 2 1 2]) = b;');

compare_a_dbl_unc(zeros(1, 3), 1:4, 'a([1 1], [1 2]) = b;');
compare_a_dbl_unc(zeros(1, 3), [1 2; 3 4], 'a([1 1], [1 2]) = b;');
%% 5. Null asignment

compare_a_dbl_unc(rand(1, 9), [], 'a(2:3) = [];');
compare_a_dbl_unc(rand(1, 9), [], 'a((2:3)'') = [];');
compare_a_dbl_unc(rand(9, 1), [], 'a(2:3) = [];');
compare_a_dbl_unc(rand(9, 1), [], 'a((2:3)'') = [];');

compare_a_dbl_unc(magic(3), [], 'a(:) = [];');
compare_a_dbl_unc(magic(3), [], 'a(2:3) = [];');
compare_a_dbl_unc(magic(3), [], 'a(5:6) = [];');
compare_a_dbl_unc(magic(3), [], 'a((2:3)'') = [];');
compare_a_dbl_unc(magic(3), [], 'a((5:6)'') = [];');
compare_a_dbl_unc(rand(3, 5, 7), [], 'a(2:3, :, :) = [];');
compare_a_dbl_unc(rand(2, 3, 4), [], 'a(:, 2, :) = [];');
compare_a_dbl_unc(rand(2, 3, 4), [], 'a(4, 2, :) = [];');

compare_a_dbl_unc(rand(2, 3, 4), [], 'a(4, 10:12) = [];');

compare_a_dbl_unc(magic(3), [], 'a(:) = b;');
compare_a_dbl_unc(magic(3), [], 'a(2:3) = b;');
compare_a_dbl_unc(rand(3, 5, 7), [], 'a(2:3, :, :) = b;');
compare_a_dbl_unc(rand(2, 3, 4), [], 'a(:, 2, :) = b;');
compare_a_dbl_unc(rand(2, 3, 4), [], 'a(4, 2, :) = b;');

compare_a_dbl_unc(magic(3), [], 'a(:) = zeros(0, 0);', 'Accept', 'doubleError');                 % subsasgn implemented in matlab cannot distinguis between [] and an empty double. This difference in behavior cannot be resolved.
compare_a_dbl_unc(magic(3), [], 'a(2:3) = zeros(0, 0);', 'Accept', 'doubleError');               % subsasgn implemented in matlab cannot distinguis between [] and an empty double. This difference in behavior cannot be resolved.
compare_a_dbl_unc(rand(3, 5, 7), [], 'a(2:3, :, :) = zeros(0, 0);', 'Accept', 'doubleError');    % subsasgn implemented in matlab cannot distinguis between [] and an empty double. This difference in behavior cannot be resolved.
compare_a_dbl_unc(rand(2, 3, 4), [], 'a(:, 2, :) = zeros(0, 0);', 'Accept', 'doubleError');      % subsasgn implemented in matlab cannot distinguis between [] and an empty double. This difference in behavior cannot be resolved.
compare_a_dbl_unc(rand(2, 3, 4), [], 'a(4, 2, :) = zeros(0, 0);', 'Accept', 'differentErrors');      % subsasgn implemented in matlab cannot distinguis between [] and an empty double. This difference in behavior cannot be resolved.
%% 6. Invalid Parameters

% Empty bracket, caught directly by Matlab.
compare_a_dbl_unc(rand(2, 3, 4), magic(3), 'a() = b;');

% Incorrect indices
compare_a_dbl_unc(rand(2, 3, 4), 3, 'a(''d'') = b;');
compare_a_dbl_unc(rand(1, 100), 3, 'a(''d'') = b;');
compare_a_dbl_unc(rand(2, 3, 4), 3, 'a(2.3) = b;');
compare_a_dbl_unc(rand(2, 3, 4), 3, 'a(-4) = b;');
compare_a_dbl_unc(rand(2, 3, 4), 3, 'a(0) = b;');
compare_a_dbl_unc(rand(2, 3, 4), rand(3, 4), 'a(2, 1.1:3.1, :) = b;', 'Accept', 'uncError');  % double throws a warning, unc an error. This difference is accepted.
%% 7. Initialization

compare_a_dbl_unc([], 3, 'clear a; a(5) = b;');
compare_a_dbl_unc([], 3, 'clear a; a(5, 5) = b;');
compare_a_dbl_unc([], 3j, 'clear a; a(5) = b;');
compare_a_dbl_unc([], 3j, 'clear a; a(5, 5) = b;');

compare_a_dbl_unc([], 3, 'clear a; a(1:5) = b;');
compare_a_dbl_unc([], 3, 'clear a; a(3:5) = b;');
compare_a_dbl_unc([], 3, 'clear a; a(1:5, 1:5) = b;');
compare_a_dbl_unc([], 3, 'clear a; a(3:5, 3:5) = b;');
compare_a_dbl_unc([], 3j, 'clear a; a(1:5) = b;');
compare_a_dbl_unc([], 3j, 'clear a; a(3:5) = b;');
compare_a_dbl_unc([], 3j, 'clear a; a(1:5, 1:5) = b;');
compare_a_dbl_unc([], 3j, 'clear a; a(3:5, 3:5) = b;');

compare_a_dbl_unc([], 3, 'clear a; a(:) = b;');
compare_a_dbl_unc([], 3, 'clear a; a(:, :) = b;');
compare_a_dbl_unc([], 3j, 'clear a; a(:) = b;');
compare_a_dbl_unc([], 3j, 'clear a; a(:, :) = b;');

compare_a_dbl_unc([], 1:3, 'clear a; a(:) = b;');
compare_a_dbl_unc([], 1:3, 'clear a; a(1, :) = b;');
compare_a_dbl_unc([], 1:3, 'clear a; a(2, :) = b;');
compare_a_dbl_unc([], (1:3)', 'clear a; a(:) = b;');
compare_a_dbl_unc([], (1:3)', 'clear a; a(1, :) = b;');
compare_a_dbl_unc([], (1:3)', 'clear a; a(2, :) = b;');

compare_a_dbl_unc([], 1:3, 'clear a; a(:, :) = b;');
compare_a_dbl_unc([], 1:3, 'clear a; a(1, :, :) = b;');
compare_a_dbl_unc([], 1:3, 'clear a; a(2, :, :) = b;');
compare_a_dbl_unc([], (1:3)', 'clear a; a(:, :) = b;');
compare_a_dbl_unc([], (1:3)', 'clear a; a(1, :, :) = b;');
compare_a_dbl_unc([], (1:3)', 'clear a; a(2, :, :) = b;');

compare_a_dbl_unc([], magic(3), 'clear a; a(1:9) = b;');
compare_a_dbl_unc([], magic(3), 'clear a; a(1:3, 1:3) = b;');
compare_a_dbl_unc([], magic(3), 'clear a; a(1:3, 1:3, 1) = b;');
compare_a_dbl_unc([], magic(3), 'clear a; a(1:3, 1:3, 5) = b;');
compare_a_dbl_unc([], magic(3), 'clear a; a(5, 1:9) = b;', 'Accept', 'differentErrors');
compare_a_dbl_unc([], magic(3), 'clear a; a(5, 1:3, 1:3) = b;');
compare_a_dbl_unc([], magic(3), 'clear a; a(5, 1:3, 1:3, 1) = b;');
compare_a_dbl_unc([], magic(3), 'clear a; a(5, 1:3, 1:3, 5) = b;');

compare_a_dbl_unc([], magic(3), 'clear a; a(:) = b;');
compare_a_dbl_unc([], magic(3), 'clear a; a(:, :) = b;');
compare_a_dbl_unc([], magic(3), 'clear a; a(:, :, :) = b;');
compare_a_dbl_unc([], magic(3), 'clear a; a(5, :) = b;', 'Accept', 'differentErrors');
compare_a_dbl_unc([], magic(3), 'clear a; a(5, :, :) = b;');
compare_a_dbl_unc([], magic(3), 'clear a; a(5, :, :, :) = b;');

compare_a_dbl_unc([], (magic(3)), 'clear a; a(5:8, :) = b;');

compare_a_dbl_unc([], (magic(4)), 'clear a; a(5:8, :) = b;');
compare_a_dbl_unc([], (magic(4)), 'clear a; a(5:9, :) = b;');
compare_a_dbl_unc([], complex(magic(4)), 'clear a; a(5:8, :) = b;');
compare_a_dbl_unc([], complex(magic(4)), 'clear a; a(5:9, :) = b;');

compare_a_dbl_unc([], (magic(4)), 'clear a; a(:, 5:8) = b;');
compare_a_dbl_unc([], (magic(4)), 'clear a; a(:, 5:9) = b;');
compare_a_dbl_unc([], complex(magic(4)), 'clear a; a(:, 5:8) = b;');
compare_a_dbl_unc([], complex(magic(4)), 'clear a; a(:, 5:9) = b;');

compare_a_dbl_unc([], rand(4, 4, 4), 'clear a; a(:, 5:8) = b;');
compare_a_dbl_unc([], rand(4, 4, 4), 'clear a; a(:, 5:9) = b;');
compare_a_dbl_unc([], rand(4, 4, 4), 'clear a; a(5:8, :) = b;');
compare_a_dbl_unc([], rand(4, 4, 4), 'clear a; a(5:9, :) = b;');
compare_a_dbl_unc([], rand(4, 4, 4), 'clear a; a(:, 5:8, :) = b;');
compare_a_dbl_unc([], rand(4, 4, 4), 'clear a; a(:, 5:9, :) = b;');
compare_a_dbl_unc([], rand(4, 4, 4), 'clear a; a(5:8, :, :) = b;');
compare_a_dbl_unc([], rand(4, 4, 4), 'clear a; a(5:9, :, :) = b;');

% Do singleton dimensions in b get copied by colon? (They do not, except the dimensions already match.)
compare_a_dbl_unc([], rand(1, 3), 'clear a; a(5, :) = b;');
compare_a_dbl_unc([], rand(1, 3), 'clear a; a(5, :, :) = b;');
compare_a_dbl_unc([], rand(1, 3), 'clear a; a(5, :, :, :) = b;');

compare_a_dbl_unc([], rand(1, 3), 'clear a; a(5, 1:3) = b;');
compare_a_dbl_unc([], rand(1, 3), 'clear a; a(5, 1:3, :) = b;');
compare_a_dbl_unc([], rand(1, 3), 'clear a; a(5, 1, :) = b;');
compare_a_dbl_unc([], rand(1, 3), 'clear a; a(5, 1, :, :) = b;');
compare_a_dbl_unc([], rand(1, 3), 'clear a; a(5, 1, :, :, :) = b;');

compare_a_dbl_unc([], rand(3, 1), 'clear a; a(5, :) = b;');
compare_a_dbl_unc([], rand(3, 1), 'clear a; a(5, :, :) = b;');
compare_a_dbl_unc([], rand(3, 1), 'clear a; a(5, :, :, :) = b;');

compare_a_dbl_unc([], rand(3, 1, 3), 'clear a; a(5, :, :) = b;');
compare_a_dbl_unc([], rand(3, 1, 3), 'clear a; a(5, :, :, :) = b;');
compare_a_dbl_unc([], rand(3, 1, 3), 'clear a; a(5, :, :, :, :) = b;');
compare_a_dbl_unc([], rand(3, 1, 3), 'clear a; a(5, :, 1, :) = b;');

compare_a_dbl_unc([], rand(3, 3, 1, 3), 'clear a; a(5, :, :, :, :, :) = b;');
compare_a_dbl_unc([], rand(3, 3, 1, 3), 'clear a; a(5, 1:3, :, :, :, :, :) = b;');
compare_a_dbl_unc([], rand(3, 3, 1, 3), 'clear a; a(5, 1:3, :, :, :) = b;');
compare_a_dbl_unc([], rand(3, 3, 1, 3), 'clear a; a(5, 1:3, :, :) = b;');

% Initialization with empty variable.
compare_a_dbl_unc([], 'clear a; a(:) = [];');
compare_a_dbl_unc([], 'clear a; a(:, :) = [];');
%% 7. Known Bugs
% Version 2.4.8

compare_a_dbl_unc(rand(3, 1), rand(3, 1), 'a(:, 1) = b;');
compare_a_dbl_unc(rand(3, 1), rand(3, 1), 'a(:, 1) = b(:);');

% Not sure if the following is really relevant...
compare_a_dbl_unc(rand(3, 1, 1), rand(), 'reshape(a, [3 1 1]); a(1, 1, 1) = b;');

% Different datatypes in the indexes cause an error (issue #12).
compare_a_dbl_unc(rand(3, 3), rand(3, 1), 'a(:, uint32(1)) = b;');
% Version 2.4.9

compare_a_dbl_unc([], 0, 'a([]) = b;');
compare_a_dbl_unc([], 0, 'a([], []) = b;');
compare_a_dbl_unc([], rand(1, 1), 'a([]) = b;');
compare_a_dbl_unc([], rand(1, 2), 'a([]) = b;');
compare_a_dbl_unc([], rand(2, 1), 'a([]) = b;');
compare_a_dbl_unc([], rand(2, 2), 'a([]) = b;');
compare_a_dbl_unc([], rand(2, 2, 2), 'a([]) = b;');
compare_a_dbl_unc([], rand(2, 2, 2), 'a([], []) = b;');
compare_a_dbl_unc([], [], 'clear a; a([]) = b;');
compare_a_dbl_unc(rand(1, 1, 10), 'a(3) = [];');