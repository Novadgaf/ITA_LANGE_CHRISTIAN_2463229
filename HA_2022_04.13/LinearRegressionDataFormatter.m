classdef LinearRegressionDataFormatter < matlab.mixin.SetGet
    %DATAPRERPERATOR Class to model the training data for lineare
    %regression model object
   
    properties (Access = public)
        feature
        featureName
        commandVar
        commandVarName
        numOfSamples
    end
    
    properties (Access = private)
        data
    end
    
    methods (Access = public)
        function obj = LinearRegressionDataFormatter(varargin)
        % Function Name: LinearRegressionDataFormatter
        %
        % Description: Construct an instance of this class
        %
        % Syntax:  obj =
        % LinearRegressionDataFormatter('Data','TempearatureMeasurement.mat','Feature','T3','CommandVar','T4');
        %
        % Inputs:
        %    Data - Name of Data file
        %    Feature - name of feature
        %    CommandVar - name of commandVar
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
                if strcmp(varargin{i},'Data')
                    obj.data = importdata(varargin{i+1});
                elseif strcmp(varargin{i},'Feature')
                    obj.featureName = varargin{i+1};
                elseif strcmp(varargin{i},'CommandVar')
                    obj.commandVarName = varargin{i+1};
                end
            end
            
            obj.mapFeature();
            obj.mapCommandVar();
            obj.mapNumOfSamples();
        end
    end
    
    methods (Access = private)
        function mapFeature(obj)
            obj.feature = obj.data.(obj.featureName);
        end
        
        function mapCommandVar(obj)
            obj.commandVar = obj.data.(obj.commandVarName);
        end
        
        function mapNumOfSamples(obj)
           obj.numOfSamples = length(obj.feature); 
        end
    end
end

