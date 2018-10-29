classdef qmElement < handle
    %% Quine-McCluskey Row Element
    
    properties
        checked = 0;
        indStr;
        binStr;
    end
    
    methods
        %% Constructor
        function obj = qmElement(varargin)
            if (nargin == 3)
                obj.checked = varargin{3};
            elseif (nargin == 2)
                obj.binStr = varargin{2};
            end
            obj.indStr = varargin{1};
        end
        
        %% Set checked flag
        function obj = set.checked(obj, Value)
            obj.checked = Value;
        end
        
        %% Set ind string
        function obj = set.indStr(obj, Value)
            obj.indStr = Value;
        end
        
        %% Set binary diff string
        function obj = set.binStr(obj, Value)
            obj.binStr = Value;
        end
        
        %% Generate string representations with some characters
        function str = genStr(obj, labels, isMinTerm)
            bStr = obj.binStr;
            if (length(labels) ~= length(bStr))
                error('QMElem: Invalid number of characters to use for labels.');
            end
            
            % strcmp(bStr, repmat('-', length(labels), 1)
            %obj.indStr
            %length(obj.indStr)
            %2^(length(labels) + 1) - 1
            if (length(obj.indStr) == 2^(length(labels) + 1) - 1)
                if (isMinTerm)
                    str = '1';
                else
                    str = '0';
                end
            else
                str = labels;
                bars = repmat('~', 1, length(bStr));

                % Matching labels to binary positions
                str(bStr == '-') = ' ';

                % adding "bars" (negations) if needed
                barMatchVal = '1';
                groupOp = '+';

                if (isMinTerm)
                    barMatchVal = '0';
                    groupOp = '*';
                end
                bars(bStr ~= barMatchVal) = ' ';

                % stripping empty chars
                temp = strtrim(cellstr(vertcat(bars,str)'));
                temp(strcmp('',temp)) = [];
                str = strjoin(temp, groupOp);
                str = strcat('(', str, ')');    
            end
        end
    end
end

