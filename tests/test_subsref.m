%% Unit Tests of subsref for uncLib
% This script tests the behavior of the function subsref, which is called in 
% statements like a(:, :), i.e. when one or several values of an array are addressed. 
% The scipt compares the output and error messages of subsref on double and unc 
% varaibles. It uses the function

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
%% 0. Introduction
%% 0.1. Simple Tests
% These tests should not fail

% The following code compares the value of ans after
%   tmp = rand(1, 3);
%   a = double(tmp);
%   a(:, :);
% and this
%   a = unc(tmp);
%   a(:, :);
compare_ans_dbl_unc(rand(1, 3), 'a(:, :)');
%% 0.2 Types of Errors in the old subsref implementation
% The old implementation of subsref expected the variable to have the same dimensions 
% and size as the indices used to address it. However, this is not necessarily 
% the case in Matlab, as matricies can for example be addressed linarly. (A matrix 
% a=magic(3) can for example be addressed as a(1:9).) This resulted in several 
% cases, where the result was not as expected.
% 
% The old implementation of subsref also did not respect several special cases, 
% like logical indexing or the orientation of vectors.
%% 1. Addressing all dimensions that exist
% Vectors

compare_ans_dbl_unc(rand(5, 1), 'a(:)');
compare_ans_dbl_unc(rand(1, 5), 'a(:)');
compare_ans_dbl_unc(rand(5, 1), 'a(:, 1)');
compare_ans_dbl_unc(rand(1, 5), 'a(1, :)');
compare_ans_dbl_unc(rand(5, 1), 'a([2 4])');

compare_ans_dbl_unc(rand(5, 1), 'a((1:5))');
compare_ans_dbl_unc(rand(1, 5), 'a((1:5))');
compare_ans_dbl_unc(rand(5, 1), 'a((1:5)'')');
compare_ans_dbl_unc(rand(1, 5), 'a((1:5)'')');

compare_ans_dbl_unc(rand(5, 1), 'a([2 4 6])');
compare_ans_dbl_unc(rand(5, 1), 'a([2 4 6 8])');
compare_ans_dbl_unc(rand(5, 1), 'a(10)');
compare_ans_dbl_unc(rand(5, 1), 'a(10, 1)');

compare_ans_dbl_unc(rand(5, 1), 'a([2 3 5 2 3 1 2 3 2])');
%% 
% 2D Matricies

compare_ans_dbl_unc(rand(4, 5), 'a(:, :)');
compare_ans_dbl_unc(rand(4, 5), 'a(1, :)');
compare_ans_dbl_unc(rand(4, 5), 'a(:, 1)');
compare_ans_dbl_unc(rand(4, 5), 'a(3, :)');
compare_ans_dbl_unc(rand(4, 5), 'a(:, 3)');
compare_ans_dbl_unc(rand(4, 5), 'a(4, :)');
compare_ans_dbl_unc(rand(4, 5), 'a(:, 5)');
compare_ans_dbl_unc(rand(4, 5), 'a(5, :)');
compare_ans_dbl_unc(rand(4, 5), 'a(:, 6)');
compare_ans_dbl_unc(rand(4, 5), 'a(5, 6)');

compare_ans_dbl_unc(rand(4, 5), 'a([1 3 3 4 1], [3 1 5 2 2 5 1])');


compare_ans_dbl_unc(rand(4, 5), 'a([7 8], [4 6])');
%% 
% Matricies with more than 2 dimensions.

compare_ans_dbl_unc(rand(4, 5, 6), 'a(4, 5, 6)');
compare_ans_dbl_unc(rand(4, 5, 6), 'a(3, :, :)');
compare_ans_dbl_unc(rand(4, 5, 6), 'a(:, 3, :)');
compare_ans_dbl_unc(rand(4, 5, 6), 'a(:, :, 3)');
compare_ans_dbl_unc(rand(4, 5, 6), 'a(:, 3, 3)');
compare_ans_dbl_unc(rand(4, 5, 6), 'a(3, :, 3)');
compare_ans_dbl_unc(rand(4, 5, 6), 'a(3, 3, :)');

compare_ans_dbl_unc(rand(4, 5, 6, 7, 8), 'a(1, :, :, 1, 1)');
%% 2. Addressing less dimensions than exist
% Vectors

compare_ans_dbl_unc(rand(5, 1), 'a([])');
%% 
% 2D Matricies

compare_ans_dbl_unc(rand(4, 5), 'a(:)');
compare_ans_dbl_unc(rand(4, 5), 'a(2:3)');
compare_ans_dbl_unc(rand(4, 5), 'a(4:6)');
compare_ans_dbl_unc(rand(4, 5), 'a(4:8)');
compare_ans_dbl_unc(rand(4, 5), 'a(4:12)');
compare_ans_dbl_unc(rand(4, 5), 'a(1:20)');
compare_ans_dbl_unc(rand(4, 5), 'a(1:21)');
compare_ans_dbl_unc(rand(4, 5), 'a(21:23)');
compare_ans_dbl_unc(rand(4, 5), 'a(3)');
compare_ans_dbl_unc(rand(4, 5), 'a(23)');

compare_ans_dbl_unc(rand(4, 5), 'a([1 3 3 4 1])');
compare_ans_dbl_unc(rand(4, 5), 'a([1 3 3 4 1 6 8])');
compare_ans_dbl_unc(rand(4, 5), 'a([1; 3; 3; 4; 1])');
compare_ans_dbl_unc(rand(4, 5), 'a([1; 3; 3; 4; 1; 6; 8])');
compare_ans_dbl_unc(rand(4, 5), 'a([1 3 3 4 1 6 8 30 4])');
%% 
% Matricies with more than 2 dimensions.

compare_ans_dbl_unc(rand(4, 5, 6), 'a(4, 5)');
compare_ans_dbl_unc(rand(4, 5, 6), 'a(3, :)');
compare_ans_dbl_unc(rand(4, 5, 6), 'a(:, 3)');
compare_ans_dbl_unc(rand(4, 5, 6), 'a(:, :)');
compare_ans_dbl_unc(rand(4, 5, 6), 'a(3, 3)');

compare_ans_dbl_unc(rand(4, 5, 6), 'a(3, 6:7)');
compare_ans_dbl_unc(rand(4, 5, 6), 'a(:, 6:7)');

compare_ans_dbl_unc(rand(4, 5, 6, 7, 8), 'a(1, :, :, 1, 1)');

compare_ans_dbl_unc(rand(4, 5, 6, 7, 8), 'a([])');
compare_ans_dbl_unc(rand(4, 5, 6, 7, 8), 'a([], [])');
compare_ans_dbl_unc(rand(4, 5, 6, 7, 8), 'a([], [], [])');
compare_ans_dbl_unc(rand(4, 5, 6, 7, 8), 'a([], [], :)');
%% 3. Addressing more dimensions than exist

compare_ans_dbl_unc([], 'a(4)');
compare_ans_dbl_unc([], 'a(:)');
compare_ans_dbl_unc(rand(), 'a(1, :)');
compare_ans_dbl_unc(rand(), 'a(1, 1)');
compare_ans_dbl_unc(rand(), 'a(1, 2)');
compare_ans_dbl_unc(rand(), 'a(2, 1)');
compare_ans_dbl_unc(rand(1, 3), 'a(:, :, :)');
compare_ans_dbl_unc(rand(3, 1), 'a(:, :, :)');
compare_ans_dbl_unc(rand(4, 5, 6), 'a(3, 3, 3, 3)');


compare_ans_dbl_unc(rand(1, 3), 'a(:, :, :, :, :)');
compare_ans_dbl_unc(rand(3, 1), 'a(:, :, :, 1, :)');


compare_ans_dbl_unc(rand(3, 1), 'a(:, :, :, [], :)');
compare_ans_dbl_unc(rand(3, 1), 'a(:, :, :, [], [])');
compare_ans_dbl_unc(rand(3, 1), 'a([], :, :, [], :)');
%% 4. Linear Indexing with a Matrix
% This is a very special case

compare_ans_dbl_unc(rand(9, 1), 'a([2 3; 4 5])');
compare_ans_dbl_unc(rand(3, 3), 'a([2 3; 4 5])');
compare_ans_dbl_unc(rand(9, 1), 'a([2 3; 4 5; 6 7])');

% Three dimensional arguments are difficult to implement with
% compare_ans_dbl_unc.
a = zeros(5, 5, 5); a(:) = 0.1*1:0.1:0.1*numel(a); ...
b = zeros(2, 3, 4); b(:) = 1:numel(b); ...
a_dbl = double(a);
a_unc = unc(a);
% MATLAB R2018a an earlier workaround
temp = a_dbl(b) == double(a_unc(b));
if all(temp(:))
    fprintf('PASSED: same result.\n');
else
    fprintf('FAILED!\n');
end
%% 5. Logical Indexing
% TODO Addressing 2d matrix as first parameter!

compare_ans_dbl_unc(rand(9, 1), 'a([2 3; 4 5] > 2)');
compare_ans_dbl_unc(rand(3, 3), 'a([2 3; 4 5] > 2)');
compare_ans_dbl_unc(rand(9, 1), 'a([2 3; 4 5; 6 7] > 3)');

compare_ans_dbl_unc([1 5 2 4 3], 'a(logical([0 1 1 0 0]))');
compare_ans_dbl_unc([1 5 2 4 3], 'a(logical([0 1 1 0 0]''))');
compare_ans_dbl_unc([1 5 2 4 3]', 'a(logical([0 1 1 0 0]))');
compare_ans_dbl_unc([1 5 2 4 3]', 'a(logical([0 1 1 0 0]''))');

compare_ans_dbl_unc([1 5 2 4 3], 'a(logical([0 1 1 0]))');
compare_ans_dbl_unc([1 5 2 4 3], 'a(logical([0 1 1 0 0 0]))');
compare_ans_dbl_unc([1 5 2 4 3], 'a(logical([1 1 1 1 1 1]))', 'Accept', 'differentErrors'); % Different error messages accepted for now.

compare_ans_dbl_unc(rand(3, 1), 'a(a>0.5)');
compare_ans_dbl_unc(magic(3), 'a(a>3)');
compare_ans_dbl_unc(magic(3), 'a(a>0)');
compare_ans_dbl_unc(magic(3), 'a(a(:)>3)');
%% 6. Invalid Parameters
% This case is handled by Matlab directly.

compare_ans_dbl_unc([], 'a()');
compare_ans_dbl_unc([], 'a(:, )');

compare_ans_dbl_unc(rand(2, 3, 4), 'a()');
compare_ans_dbl_unc(rand(2, 3, 4), 'a(, :)');
compare_ans_dbl_unc(rand(2, 3, 4), 'a(:, )');
compare_ans_dbl_unc(rand(2, 3, 4), 'a(, :, :)');
compare_ans_dbl_unc(rand(2, 3, 4), 'a(:, , :)');
compare_ans_dbl_unc(rand(2, 3, 4), 'a(:, :, )');

% Incorrect indices
compare_ans_dbl_unc(rand(2, 3, 4), 'a(''d'')');
compare_ans_dbl_unc(rand(1, 100), 'a(''d'')');
compare_ans_dbl_unc(rand(2, 3, 4), 'a(2.3)');
compare_ans_dbl_unc(rand(2, 3, 4), 'a(-4)');
compare_ans_dbl_unc(rand(2, 3, 4), 'a(0)');
compare_ans_dbl_unc(rand(2, 3, 4), 'a(2, 1.1:3.1, :)', 'Accept', 'uncError');  % double throws a warning, unc an error. This difference is accepted.
%% 7. Empty results

compare_ans_dbl_unc(rand(2, 3, 4), 'a()');
compare_ans_dbl_unc(rand(2, 3, 4), 'a([])');
compare_ans_dbl_unc(rand(2, 3, 4), 'a([], [])');
compare_ans_dbl_unc(rand(2, 3, 4), 'a([], [], [])');
compare_ans_dbl_unc(rand(2, 3, 4), 'a([], [], [], [])');

compare_ans_dbl_unc(rand(2, 3, 4), 'a([], :, [], [])');
compare_ans_dbl_unc(rand(2, 3, 4), 'a([], :, [], [], [])');
compare_ans_dbl_unc(rand(2, 3, 4), 'a([], :, [], :, [])');

%% 8. Bugs in 2.4.8

compare_ans_dbl_unc(rand(), 'a(1, 1)');
compare_ans_dbl_unc(rand(), 'a(1, 1, 1)');
