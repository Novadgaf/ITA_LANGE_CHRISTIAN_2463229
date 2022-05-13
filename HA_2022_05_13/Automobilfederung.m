classdef Automobilfederung < handle
    % Automobilfederung 
    % Class to calculate the suspension of a car
    properties
        c1 {mustBeNumeric}
        c2 {mustBeNumeric}
        d2 {mustBeNumeric}
        m1 {mustBeNumeric}
        m2 {mustBeNumeric}
        u
        A {mustBeNumeric}
        B {mustBeNumeric}
        tsimout {mustBeNumeric}
        ysimout {mustBeNumeric}
    end
    methods (Access = public)
        function obj = Automobilfederung(varargin)
        % Function Name: Automobilfederung
        %
        % Description: Construct an instance of this class
        %
        % Syntax:  obj = Automobilfederung('c1',c1Data'c2',c2Data,'d2',d2Data,'m1',m1Data,'m2',m2Data,'u',uData);
        %
        %
        % Inputs:
        %    c1, c2, d2, m1, m2, u
        %   
        %
        % Outputs:
        %    obj - callable object
        %
        % $Revision: R2022a$
        % $Author: Christian Lange$
        % $Date: May 13, 2022$    
            for i = 1:2:nargin
                if strcmp(varargin{i},'c1')
                    obj.c1 = varargin{i+1};
                elseif strcmp(varargin{i},'c2')
                    obj.c2 = varargin{i+1};
                elseif strcmp(varargin{i},'d2')
                    obj.d2 = varargin{i+1};
                elseif strcmp(varargin{i},'m1')
                    obj.m1 = varargin{i+1};
                elseif strcmp(varargin{i},'m2')
                    obj.m2 = varargin{i+1};
                elseif strcmp(varargin{i},'u')
                    if isa(varargin{i+1},'function_handle')
                        obj.u = varargin{i+1};
                    else
                        error("u seems not to be a function handle");
                    end
                else
                    warning("Invalid property: "+varargin{i});
                end
            end
            obj.calcSystemMartixA();
            obj.calcInputMatixB();
        end
        function sim(obj, varargin)
        % Function Name: sim
        %
        % Description: simulates usecase
        %
        % Syntax:  sim(obj, 't0',t0Data'tfinal',tfinalData,'y0',y0Data,'stepsize',stepsizeData);
        %
        %
        % Inputs:
        %    obj        - object of Automobilfederung
        %    t0         - start
        %    tfinal     - end
        %    y0         - y Matrix
        %    stepsize   - resolution of steps
        %
        % Outputs:
        %    
        %
        % $Revision: R2022a$
        % $Author: Christian Lange$
        % $Date: May 13, 2022$    
            t = 0;
            tfinal = 10;
            h = 0.01;
            y = [0; 0; 0; 0];
            for i = 1:2:nargin-1
                % ========= YOUR CODE HERE =========
                % perform the varargin: overwrite the defaults
                if strcmp(varargin{i},'t0')
                    t = varargin{i+1};
                elseif strcmp(varargin{i},'tfinal')
                    tfinal = varargin{i+1};
                elseif strcmp(varargin{i},'y0')
                    y = varargin{i+1}';
                elseif strcmp(varargin{i},'stepsize')
                    h = varargin{i+1};
                else
                    warning("Invalid property line 57 autofed: "+varargin{i});
                end
            end
            tout = zeros(ceil((tfinal-t)/h)+1,1);
            yout = zeros(ceil((tfinal-t)/h)+1,length(y));
            tout(1) = t;
            yout(1,:) = y';
            step = 1;
            while (t < tfinal)
                step = step + 1;
                if t + h > tfinal
                    % ========= YOUR CODE HERE =========
                    % h = 
                    h = tfinal - t;
                end
                % ========= YOUR CODE HERE =========
                % calculate the slopes
                k1 = obj.rhs(t,y);
                k2 = obj.rhs(t+h/2,y+(h/2)*k1);
                k3 = obj.rhs(t+h/2,y+(h/2)*k2);
                k4 = obj.rhs(t+h,y+h*k3);
                % calculate the ynew
                ynew = y + ((1/6)*k1 + (1/3)*k2 + (1/3)*k3 + (1/6)*k4)*h;
                t = t + h;
                y = ynew;
                tout(step) = t;
                yout(step,:) = y';
                obj.tsimout = tout;
                obj.ysimout = yout;
            end
        end
        function fig = visualizeResults(obj)
        % Function Name: visualizeResults
        %
        % Description: visualizes the results of the simultation
        %
        % Syntax:  fig = visualizeResults(obj);
        %
        %
        % Inputs:
        %    obj - object of Automobilfederung
        %   
        %
        % Outputs:
        %    fig - figure with the results
        %
        % $Revision: R2022a$
        % $Author: Christian Lange$
        % $Date: May 13, 2022$    
            fig = figure('Name','Ergebnisse der Simulation');
            subplot(2,1,1);
            plot(obj.tsimout,obj.ysimout(:,1),'s-',...
                 obj.tsimout,obj.ysimout(:,3),'x-')
            grid on;
            ylabel('Höhe in m');
            legend('Karosserie','Rad');
            title("Position der Zustände | stepsize = "+num2str(obj.tsimout(2)-obj.tsimout(1)))
            subplot(2,1,2);
            plot(obj.tsimout,obj.ysimout(:,2),'s-',...
                 obj.tsimout,obj.ysimout(:,4),'x-')
            grid on;
            ylabel('Geschwindigkeit in m/s');
            xlabel('Simulationszeit in s');
            legend('Karosserie','Rad');
            title("Geschwindigkeit der Zustände | stepsize = "+num2str(obj.tsimout(2)-obj.tsimout(1)))
        end
    end
    methods (Access = private)
        function calcInputMatixB(obj)
        % Function Name: calcInputMatixB
        %
        % Description: calculates the B Matrix
        %
        % Syntax:  calcInputMatixB(obj);
        %
        %
        % Inputs:
        %    obj - object of Automobilfederung
        %   
        %
        % Outputs:
        %    
        %
        % $Revision: R2022a$
        % $Author: Christian Lange$
        % $Date: May 13, 2022$    
            % ========= YOUR CODE HERE =========
            % obj.B = 
            obj.B = [0;0;0;obj.c1/obj.m1];
        end
        function calcSystemMartixA(obj)
        % Function Name: calcInputMatixA
        %
        % Description: calculates the A Matrix
        %
        % Syntax:  calcInputMatixB(obj);
        %
        %
        % Inputs:
        %    obj - object of Automobilfederung
        %   
        %
        % Outputs:
        %    
        %
        % $Revision: R2022a$
        % $Author: Christian Lange$
        % $Date: May 13, 2022$    
            % ========= YOUR CODE HERE =========
            % obj.A = 
            obj.A = [0,1,0,0;...
                    -obj.c2/obj.m2, -obj.d2/obj.m2, obj.c2/obj.m2, obj.d2/obj.m2;...
                    0, 0, 0, 1;...
                    obj.c2/obj.m1, obj.d2/obj.m1, -(obj.c1+obj.c2)/obj.m1, -obj.d2/obj.m1];
        end
        function xdot = rhs(obj, t, x)
        % Function Name: rhs
        %
        % Description: calculates x dot
        %
        % Syntax:  rhs(obj, t, x);
        %
        %
        % Inputs:
        %    obj    - object of Automobilfederung
        %    t      - current t
        %    x      - y 
        %
        % Outputs:
        %    
        %
        % $Revision: R2022a$
        % $Author: Christian Lange$
        % $Date: May 13, 2022$    
            x = x(:);
            xdot = obj.A*x + obj.B*obj.u(t);
            
        end
    end
end