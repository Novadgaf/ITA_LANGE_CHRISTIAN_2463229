classdef GradientDescentOptimizer < matlab.mixin.SetGet
    %GRADIENTDESCENTOPTIMIZER 
    % Class to perform the training for a lineare regression Model
      
    properties (Access = private)
        costHistory
        learningRate
        maxIterations
    end
    
    methods (Access = public)
        function obj = GradientDescentOptimizer(varargin)
        % Function Name: LinearRegressionDataFormatter
        %
        % Description: Construct an instance of this class
        %
        % Syntax:  obj = LinearRegressionModel('Data',dataForLinearRegression,'Optimizer',gradientDescentOptimizer);

        %
        % Inputs:
        %    LearningRate - alpha
        %    MaxIterations - maximum of iterations
        %
        %
        % Outputs:
        %    obj - callable object
        %
        % $Revision: R2022a$
        % $Author: Christian Lange$
        % $Date: April 12, 2022$        
          
            % ========= YOUR CODE HERE =========
            % perform the varargin
            for i = 1:nargin
                if strcmp(varargin{i},'LearningRate')
                    alpha = varargin{i+1};
                elseif strcmp(varargin{i},'MaxIterations')
                    maxIters = varargin{i+1};
                end
            end

            obj.setLearningRate(alpha);
            obj.setMaxNumOfIterations(maxIters);
            
        end

        function h = runTraining(obj, linearRegressionModel)
        % Function Name: runTraining
        %
        % Description: plots costs improvement and sets optimal theta
        %
        % Syntax:  h = runTraining(obj, linearRegressionModel)
        %
        % Inputs:
        %    obj - GradientDescentOptimizer object 
        %    linearRegressionModel - linearRegressionModelObject
        %
        %
        % Outputs:
        %    h - figure
        %
        % $Revision: R2022a$
        % $Author: Christian Lange$
        % $Date: April 12, 2022$  
            [alpha,maxIters,theta,X,y,m,costOverIters] = obj.getLocalsForTraining(linearRegressionModel);
                      
            % ========= YOUR CODE HERE =========
            % perform the optimization (by debugging please check the purpose of local variable X)
            % loop over theta-update-rule (maxIters): 
            %   vectorized updaterule can be implemented in one line of code
            %   update theta property of linearRegressionModel (we want to call the cost function in the next step)
            %   compute current costs and save them to costOverIters
            % end
            
            for i = 1:maxIters
                theta = theta - (alpha/m) * (X'*(linearRegressionModel.hypothesis() - y));
                linearRegressionModel.setTheta(theta(1),theta(2));
                costOverIters(i) = linearRegressionModel.costFunction();
            end
            obj.costHistory = costOverIters;
            linearRegressionModel.setThetaOptimum(theta(1),theta(2));
            h = obj.showTrainingResult();
        end
        
        function h = showTrainingResult(obj)
           h = figure('Name','Costs over Iterations during training');
           plot(obj.costHistory,'x-');
           xlabel('Iterations'); ylabel('costs');
           grid on;
           xlim([2500 obj.maxIterations]);
        end
        
        function setLearningRate(obj, alpha)
           obj.learningRate = alpha;
        end
        
        function setMaxNumOfIterations(obj, maxIters)
            obj.maxIterations = maxIters;
        end
    
    end
    
    methods (Access = private) 
       function [alpha,maxIters,theta,X,y,m,costOverIters] = getLocalsForTraining(obj,linearRegressionModel)
            m = linearRegressionModel.trainingData.numOfSamples;
            theta = linearRegressionModel.theta;
            X = [ones(m,1) linearRegressionModel.trainingData.feature];
            alpha = obj.learningRate;
            y = linearRegressionModel.trainingData.commandVar;
            costOverIters = zeros(obj.maxIterations, 1);
            maxIters = obj.maxIterations;
        end 
    end
end

