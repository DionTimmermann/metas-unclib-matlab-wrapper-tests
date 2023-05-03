%% Unit Tests related to the permute function

% The global variable unc determines which type of unc varaible is used for 
% the testing.

global unc;
unc = @LinProp;
%% 1. Tests

% The following code compares the value of ans after
%   tmp = rand(1, 3);
%   a = double(tmp);
%   a(:, :);
% and this
%   a = unc(tmp);
%   a(:, :);

% Test scalars
for order = perms(1:3)'
    compare_ans_dbl_unc(rand(), order, 'permute(a, double(b))');
end

% Test matricies
for order = perms(1:5)'
    compare_ans_dbl_unc(rand(2, 3, 4), order, 'permute(a, double(b))');
end

% Test that trailing dimensions are removed correctly
for order = perms(1:4)'
    compare_ans_dbl_unc(rand(), order, 'permute(a, double(b))');
end

%% 2. Error Messages
compare_ans_dbl_unc(rand(2, 3, 4), [1 2], 'permute(a, double(b))');

compare_ans_dbl_unc(rand(), [], 'permute(a, double(b))');
compare_ans_dbl_unc(rand(), [0, 1], 'permute(a, double(b))');
compare_ans_dbl_unc(rand(), [-1, 1], 'permute(a, double(b))');
compare_ans_dbl_unc(rand(), [1, 1], 'permute(a, double(b))');
compare_ans_dbl_unc(rand(), [1, 1.5], 'permute(a, double(b))');
compare_ans_dbl_unc(rand(), [1, 1.6], 'permute(a, double(b))');

%% 3. Dependent Functions

compare_ans_dbl_unc(rand(2, 3, 4), 'pagetranspose(a)');
compare_ans_dbl_unc(rand(2, 3, 4), [2, 1, 3], 'ipermute(a, double(b))');
