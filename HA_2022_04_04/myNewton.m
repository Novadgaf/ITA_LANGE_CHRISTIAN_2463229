function [xZero, abortFlag, iters] = myNewton(varargin)
% Function Name: myNewton
%
% Description: gets the root of a real-valued function
%
% Syntax:  [xZero, abortFlag, iters] = myNewton('function', @myPoly, 'derivative', @dmyPoly, 
% 'startValue', 0, 'maxIter', 50, 'feps', 1e-6, 'xeps', 1e-6, 'livePlot', 'off')
%
% Inputs:
%    function - adress of function with input x
%    derivate - x input value of the function func
%    startValue - value between 1-3 to determine the procedure
%    maxIter -  max number of loop iterations
%    feps - epsilon of the y value to 0 before stopping
%    xeps - epsilon of the x difference before stopping
%    livePlot - on / off visualisation of the iterations
%
%
% Outputs:
%    xZero - x value of root point
%    abortFlag - reason of stop
%    iters - amount of iterations
%
% Other m-files required: numDiff.m
%
% $Revision: R2022a$
% $Author: Christian Lange$
% $Date: April 5, 2022$
%% do the varargin
for i = 1:nargin
    if strcmp(varargin{i},'function')
        func = varargin{i+1};
    elseif strcmp(varargin{i},'derivative')
        dfunc = varargin{i+1};
    elseif strcmp(varargin{i},'startValue')
        x0 = varargin{i+1};
    elseif strcmp(varargin{i},'maxIter')
        maxIter = varargin{i+1};
    elseif strcmp(varargin{i},'feps')
        feps = varargin{i+1};
    elseif strcmp(varargin{i},'xeps')
        xeps = varargin{i+1};
    elseif strcmp(varargin{i},'livePlot')
        livePlot = varargin{i+1};   
    end
end

%% check for necessary parameters
if ~exist('func','var')
    error('No valid function');
end
    
if ~exist('x0','var')
    x0 = 0;
    disp(['Using default startvalue: x0 = ',num2str(x0)]);
end

if ~exist('maxIter','var')
    maxIter = 50;
    disp(['Using default maximum iterations: maxIter = ',num2str(maxIter)]);
end

if ~exist('feps','var')
    feps = 1e-6;
    disp(['Using default Feps: feps = ',num2str(feps)]);
end

if ~exist('xeps','var')
    xeps = 1e-6;
    disp(['Using default Xeps: xeps = ',num2str(xeps)]);
end

if ~exist('livePlot','var')
    livePlot = 'off';
    disp(['Using default live Plot: livePlot = ','off']);
end

if exist('dfunc', 'var')
    dfuncExists = true;
else
    dfuncExists = false;
    disp('Using numDiff');
    button = questdlg('Which numDiff procedure do you want to use',...
    'Continue Operation','forward','backward','central','forward');
    if strcmp(button,'forward')
       disp('forward difference')
       numDiffMethod = 1;
    elseif strcmp(button,'backward')
       disp('backward difference')
       numDiffMethod = 2;
    elseif strcmp(button,'central')
       disp('central difference')
       numDiffMethod = 3;
    end
end

%% start of algorithm
if strcmp(livePlot,'on')
   h = figure('Name','Newton visualization');
   ax1 = subplot(2,1,1);
   plot(ax1,0,x0,'bo');
   ylabel('xValue');
   hold on;
   grid on;
   xlim('auto')
   ylim('auto')
   ax2 = subplot(2,1,2);
   semilogy(ax2,0,func(x0),'rx');
   xlabel('Number of iterations')
   ylabel('Function value');
   hold on;
   grid on;
   xlim('auto')
   ylim('auto')
end
xOld = x0;
abortFlag = 'maxIter';
for i = 1:maxIter
    f = func(xOld);
    if abs(f) < feps
        abortFlag = 'feps';
        break;
    end
    
    if dfuncExists
        df = dfunc(xOld);
    else
        df = numDiff(func, xOld, numDiffMethod);
    end
    
    if df == 0
        abortFlag = 'df = 0';
        break;
    end
    xNew = xOld - f/df; 
    if abs(xNew-xOld) < xeps
        abortFlag = 'xeps';
        break;
    end
    xOld = xNew;
    if strcmp(livePlot,'on')
       plot(ax1,i,xNew,'bo');
       semilogy(ax2,i,func(xNew),'rx');
       pause(0.05);
    end
end
iters = i;
xZero = xNew;
end