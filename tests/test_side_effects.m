%% Unit Tests for side effectd in the uncLib
% This script tests the various functions of the uncLib for side effects.
% 
% This script uses the function no_side_effects_unc(), which is passed up to 
% 5 variables named a, b, c, d, and e and a command to execute. The function casts 
% the variables as unc and executes the code. It then checks if any of the five 
% variables have changed value, based on a copy of each variable before the code 
% was executed.

global unc;
unc = @LinProp;
%% 1. Not accepted side effects
% These are functions whose code looks like they might return the same object 
% as they were passed, i.e. that might produce side effects.

no_side_effects_unc(rand(2, 2), 'x=reshape(a, [], 1)');
no_side_effects_unc(rand(2, 2), 'x=reshape(a, size(a))');
no_side_effects_unc(rand(), 'x=reshape(a, size(a))');
no_side_effects_unc(rand(), 'x=repmat(a, 2, 2); x(1) = 1;');
no_side_effects_unc(rand(), 'x=repmat(a, 1, 1); x(1) = 1;');
no_side_effects_unc(rand(2, 2), 'x=[a a]; x(1) = 1;');
no_side_effects_unc(rand(2, 2), 'x=[a; a]; x(1) = 1;');
no_side_effects_unc(rand(2, 2), 'x=+a; x(1) = 0;');
no_side_effects_unc(rand(2, 2), 'x=-a; x(1) = 0;');
no_side_effects_unc(rand(2, 2), 'x=complex(a); x(1) = 0;');
no_side_effects_unc(rand(2, 2)*(1+1j), 'x=complex(a); x(1) = 0;');
no_side_effects_unc(rand(2, 2), 'x=real(a); x(1) = 0;');
no_side_effects_unc(rand(2, 2)*(1+1j), 'x=real(a); x(1) = 0;');
no_side_effects_unc(rand(2, 2), 'x=imag(a); x(1) = 0;');
no_side_effects_unc(rand(2, 2)*(1j), 'x=imag(a); x(1) = 0;');
no_side_effects_unc(rand(2, 2), 'x=conj(a); x(1) = 0;');
no_side_effects_unc(rand(2, 2)*(1+1j), 'x=conj(a); x(1) = 0;');
no_side_effects_unc(rand(2, 2), 'x=a''; x(1) = 0;');
no_side_effects_unc(rand(2, 2)*(1+1j), 'x=a''; x(1) = 0;');
no_side_effects_unc(rand(2, 2), 'x=abs(a); x(1) = 0;');
no_side_effects_unc(exp(ones(2, 2)), 'x=abs(a); x(1) = 0;');
no_side_effects_unc(rand(2, 1), 'x=diag(a); x(1) = 0;');
%% 2. Accepted side effects

no_side_effects_unc(rand(2, 2), 'x=a; x(1) = 1;', 'Accept', 'sideEffect');
no_side_effects_unc(rand(4, 5, 6), 'x=unc(a); x(1) = 1;', 'Accept', 'sideEffect');
no_side_effects_unc(rand(4, 5, 6), 'x=[a]; x(1) = 1;', 'Accept', 'sideEffect');