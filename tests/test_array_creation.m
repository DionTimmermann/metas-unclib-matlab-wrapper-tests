%% Unit Tests for array creation with the UncLib

global unc;
unc = @LinProp;
%% Bugs in UncLib
% Version 2.4.9


compare_dbl_unc('type(zeros(1))');
compare_dbl_unc('type(zeros(2))');
compare_dbl_unc('type(zeros(2, 2))');

compare_dbl_unc('zeros(1, char(type))');    % char(type) converts the handle into a string of the class name.
compare_dbl_unc('zeros(2, char(type))');
compare_dbl_unc('zeros(2, 2, char(type))');

compare_dbl_unc('ones(1, char(type))');    % char(type) converts the handle into a string of the class name.
compare_dbl_unc('ones(2, char(type))');
compare_dbl_unc('ones(2, 2, char(type))');

compare_dbl_unc('eye(1, char(type))');    % char(type) converts the handle into a string of the class name.
compare_dbl_unc('eye(2, char(type))');
compare_dbl_unc('eye(2, 2, char(type))');

compare_dbl_unc('nan(1, char(type))');    % char(type) converts the handle into a string of the class name.
compare_dbl_unc('nan(2, char(type))');
compare_dbl_unc('nan(2, 2, char(type))');

compare_dbl_unc('type(zeros(0, 1, 2, 0, 3))');
compare_dbl_unc('zeros(0, 1, 2, 0, 3, char(type))');