classdef qmElement < handle
    %% Quine-McCluskey Row Element
    
    properties
        checked = 0;
        str;
    end
    
    methods
        %% Constructor
        function obj = qmElement(varargin)
            if (nargin == 2)
                obj.checked = varargin{2};
            end
            obj.str = varargin{1};
        end
        
        %% Set checked flag
        function obj = set.checked(obj, Value)
            obj.checked = Value;
        end
        
        %% Set checked string
        function obj = set.str(obj, Value)
            obj.str = Value;
        end
    end
end

