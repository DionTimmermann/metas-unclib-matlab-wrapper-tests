%% Unit Tests for side effectd in the uncLib
% This script tests the various functions of the uncLib for side effects.

global unc;
unc = @LinProp;

no_side_effects_unc(rand(4, 5, 6), 'x=a; x(3, :, 3) = 1;');
no_side_effects_unc(rand(4, 5, 6), 'x=reshape(a, [], 1)');
no_side_effects_unc(rand(4, 5, 6), rand(4, 5, 6), 'x=a.*b');
no_side_effects_unc(rand(4, 5, 6), rand(4, 5, 6), 'x=a+b');
