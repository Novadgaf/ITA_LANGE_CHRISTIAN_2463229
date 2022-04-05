function y = numDiff(func, x, method)
%Function Name: numDiff
%
%Description: gets the y value of the derivate of a given function
%
% Syntax:  y = function_name(@myPoly,0,1)
%
% Inputs:
%    func - adress of function with input x
%    x - x input value of the function func
%    method - value between 1-3 to determine the procedure
%
% Outputs:
%    y - y value of the derivate of the function func in x 
%
% Other m-files required: none
%
% $Revision: R2022a$
% $Author: Christian Lange$
% $Date: April 5, 2022$
%% determine the procedure
switch method
    case 1
        %forward difference
        h = 10^(-8);
        y = (func(x+h)-func(x))/h;
    case 2
        %backward difference
        h = 10^(-8);
        y = (func(x)-func(x-h))/h;

    case 3
        %central difference
        h = 10^(-6);
        y = (func(x+h)-func(x-h))/h;
    otherwise
        disp('Error');
end

end