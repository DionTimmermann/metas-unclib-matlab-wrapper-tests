%% Unit Tests of methods related to complex quantities for uncLib

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
compare_ans_dbl_unc(rand(1, 1), rand(1, 1), 'complex(a, b)');
compare_ans_dbl_unc(rand(1, 1), rand(1, 1), 'complex(double(a), b)');
compare_ans_dbl_unc(rand(1, 1), rand(1, 1), 'complex(a, double(b))');
compare_ans_dbl_unc(rand(1, 1), 0, 'complex(a, b)');
compare_ans_dbl_unc(rand(1, 3), rand(1, 1), 'complex(a, b)');
compare_ans_dbl_unc(rand(1, 3), rand(1, 3), 'complex(a, b)');
compare_ans_dbl_unc(rand(1, 3), rand(1, 3, 1), 'complex(a, b)');
compare_ans_dbl_unc(rand(1, 3), rand(1, 2), 'complex(a, b)');
compare_ans_dbl_unc(rand(1, 3), rand(3, 1), 'complex(a, b)');
compare_ans_dbl_unc(rand(1, 3, 4), rand(1, 1, 1), 'complex(a, b)');
compare_ans_dbl_unc(rand(1, 3, 4), rand(1, 3, 4), 'complex(a, b)');

compare_ans_dbl_unc(rand(1, 1), 'complex(a)');
compare_ans_dbl_unc(0, 'complex(a)');
compare_ans_dbl_unc(rand(1, 3), 'complex(a)');
compare_ans_dbl_unc(rand(3, 1), 'complex(a)');
compare_ans_dbl_unc(rand(1, 3, 4), 'complex(a)');
compare_ans_dbl_unc(rand(1, 1), 'isreal(complex(a))');
compare_ans_dbl_unc(rand(2, 3), 'isreal(complex(a))');
compare_ans_dbl_unc(complex(rand(1, 1), rand(1, 1)), 'isreal(a)');
compare_ans_dbl_unc(complex(rand(2, 3), rand(2, 3)), 'isreal(a)');

% The following test fails due to inconsistencies with the test framework:
% the `assignin()` function used in `compare_ans_dbl_unc()` removes the
% imag part if it is zero. 
%   compare_ans_dbl_unc(complex(rand(1, 1)), 'isreal(a)');
% That incorrect test is replaced by the equaivalent:
%   compare_ans_dbl_unc(rand(1, 1), 'isreal(complex(a))');

%%
