%% Unit Tests of size for uncLib
% This script tests the behavior of the function size, which determines the 
% number of dimensions of a variables. The scipt compares the output and error 
% messages of size on double and unc variables. It uses the function

%compare_ans_dbl_unc(a, 'command');
%% 
% where the first parameter defines the values of the variable a. The second 
% parameter is code that is executed with after the variable has been defined. 
% The function first casts a as a double and exectes the code. It then casts a 
% as an unc variable and executes the code again. The behavior (error messages 
% and returned value, i.e. the value of ans) are compared.
% 
% The global variable unc determines which type of unc varaible is used for 
% the testing.

global unc;
unc = @LinProp;

% The Behaviour of MATLAB changed in version 9.7 (2019b), thus we accept
% different errors.
if verLessThan('matlab', '9.7')
    acceptDoubleError = 'doubleError';
    acceptDifferentErrors = 'differentErrors';
else
    acceptDoubleError = [];
    acceptDifferentErrors = [];
end

%% 1. No Dimensional arguments

% The following code compares the value of ans after
%   tmp = rand(1, 3);
%   a = double(tmp);
%   a(:, :);
% and this
%   a = unc(tmp);
%   a(:, :);
compare_ans_dbl_unc(rand(1, 3), 'size(a)');
compare_ans_dbl_unc([], 'size(a)');
compare_ans_dbl_unc(3, 'size(a)');
compare_ans_dbl_unc(zeros(1, 1), 'size(a)');
compare_ans_dbl_unc(1:3, 'size(a)');
compare_ans_dbl_unc([1 2 3], 'size(a)');
compare_ans_dbl_unc([1 2 3]', 'size(a)');
compare_ans_dbl_unc(rand(1, 2, 3, 4, 5), 'size(a)');
compare_ans_dbl_unc(rand(5, 1, 1, 1), 'size(a)');
compare_ans_dbl_unc(rand(5, 1, 1, 1, 5), 'size(a)');
%% 2. dim Vector

compare_ans_dbl_unc(rand(1, 3), 'size(a, [1 2])', 'Accept', acceptDoubleError);
compare_ans_dbl_unc(rand(1, 3), 'size(a, [1 3])', 'Accept', acceptDoubleError);
compare_ans_dbl_unc(rand(1, 3), 'size(a, [3 1])', 'Accept', acceptDoubleError);
compare_ans_dbl_unc(rand(1, 3), 'size(a, [3;1])', 'Accept', acceptDoubleError);
%% 3. nargout Vector and dim Vector

compare_ans_dbl_unc(rand(2, 3, 4), '[ans, ~] = size(a, [1 2]);', 'Accept', acceptDoubleError);
compare_ans_dbl_unc(rand(2, 3, 4), '[~, ans, ~] = size(a, [1 2]);', 'Accept', acceptDifferentErrors);
compare_ans_dbl_unc(rand(2, 3, 4), '[~, ans, ~] = size(a, [1 2, 5, 7]);', 'Accept', acceptDifferentErrors);
%% 4. nargout Vector

compare_ans_dbl_unc(rand(2, 3, 4, 5, 6), '[~, ans] = size(a);');
compare_ans_dbl_unc(rand(2, 3, 4, 5, 6), '[~, ans] = size(a);');
compare_ans_dbl_unc(rand(2), '[~, ans] = size(a);');
compare_ans_dbl_unc(rand(2), '[~, ~, ans] = size(a);');
%% 3. varargin and illegal dimensions

compare_ans_dbl_unc(rand(2, 3, 4), 'size(a, 1, 2);', 'Accept', acceptDoubleError);
compare_ans_dbl_unc(rand(2, 3, 4), 'size(a, 1, 2, 3, 4);', 'Accept', acceptDoubleError);
compare_ans_dbl_unc(rand(2, 3, 4), 'size(a, 1, [2, 3, 4]);', 'Accept', acceptDifferentErrors);
compare_ans_dbl_unc(rand(2, 3, 4), 'size(a, 1, {2});', 'Accept', acceptDifferentErrors);
compare_ans_dbl_unc(rand(2, 3, 4), 'size(a, 0);', 'Accept', acceptDifferentErrors);
compare_ans_dbl_unc(rand(2, 3, 4), 'size(a, -1);', 'Accept', acceptDifferentErrors);
compare_ans_dbl_unc(rand(2, 3, 4), 'size(a, 1.1);', 'Accept', acceptDifferentErrors);