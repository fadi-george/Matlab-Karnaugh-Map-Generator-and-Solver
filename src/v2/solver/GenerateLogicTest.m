classdef GenerateLogicTest < matlab.unittest.TestCase
    properties
    end
    
%     methods (Setup)
%         import matlab.unittest.fixtures.PathFixture
%         estCase.applyFixture(PathFixture('../'));
%     end
    
    methods (Test)
        function testBinary(testCase)
            testCase.verifyError(@()generateLogic([1 0 2]), 'GL:BinaryInput')
        end
    end
end