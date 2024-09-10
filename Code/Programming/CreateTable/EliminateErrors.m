% function Eliminate systematic errors
%% Determine whether the result is close to zero
function result  = EliminateErrors(input)
% Input parameters:
%   input - A plural
%
% Output parameters:
%   result - After eliminating the error caused by the system, 
%            the return value is still a complex number
%---------------------------------------------
threshold = 1e-10;
% imag
if abs(real(input)) < threshold
    input=complex(0,imag(input));
end
% real
if abs(imag(input)) < threshold
    input=complex(real(input),0);
end
result  = input;

end