%% Unit Tests of addition and subtraction for uncLib
% This script tests the behavior of addition and subtraction in the UncLib.
% 
% The global variable unc determines which type of unc varaible is used for 
% the testing.

global unc;
unc = @LinProp;
%% Bugs in UncLib
% Version 2.4.9

% Flag to account for some error messages becomming more specific over time. 
if verLessThan('matlab', '9.10') % Error messages changed in 2021a
    accept = 'differentErrors';
else
    accept = [];
end

compare_ans_dbl_unc([], [], 'a=reshape(a, 1, 0); a+b;');
compare_ans_dbl_unc([], [], 'a=reshape(a, 1, 0); a-b;');

%%
compare_ans_dbl_unc(rand(1,1), rand(1,1), 'a+b;');
compare_ans_dbl_unc(rand(1,3), rand(3,1), 'a+b;');
compare_ans_dbl_unc(rand(3,1), rand(1,3), 'a+b;');
compare_ans_dbl_unc(rand(3,3), rand(3,3), 'a+b;');
%%
compare_ans_dbl_unc(rand(1,1), rand(1,1), 'a-b;');
compare_ans_dbl_unc(rand(1,3), rand(3,1), 'a-b;');
compare_ans_dbl_unc(rand(3,1), rand(1,3), 'a-b;');
compare_ans_dbl_unc(rand(3,3), rand(3,3), 'a-b;');
%%
compare_ans_dbl_unc(rand(1,3), rand(4,1), 'a+b;');
compare_ans_dbl_unc(rand(3,1), rand(1,4), 'a+b;');
compare_ans_dbl_unc(rand(3,3), rand(4,4), 'a+b;', 'Accept', accept);
%%
compare_ans_dbl_unc(rand(1,3), rand(4,1), 'a-b;');
compare_ans_dbl_unc(rand(3,1), rand(1,4), 'a-b;');
compare_ans_dbl_unc(rand(3,3), rand(4,4), 'a-b;', 'Accept', accept);