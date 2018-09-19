classdef KarnaughTest < matlab.unittest.TestCase
    properties
    end
        
    methods (Test)
        function testBinary(testCase)
            testCase.verifyError(@()karnaugh([1 0 2]), 'GL:BinaryInput')
        end
    end
end