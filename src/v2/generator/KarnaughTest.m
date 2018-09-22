classdef KarnaughTest < matlab.unittest.TestCase
    properties
    end
        
    methods (Test)
        % Validation of Inputs
        function testBinary(testCase)
            testCase.verifyError(@()karnaugh([1 0 2], [1 1], 1), 'KMAP:BinaryInput')
        end
        function testRowCount(testCase)
            testCase.verifyError(...
                @()karnaugh(...
                    [0 0 1; 0 1 1; 1 0 1; 1 1 1; 1 0 0],...
                    [1 1],...
                    1....
                ), 'KMAP:InvalidRowCount'...
            );
        end
        function testInvalidOutputSize(testCase)
            testCase.verifyError(...
                @()karnaugh(...
                    [0 0 0; 0 1 0],...
                    [1 1 3],...
                    1....
                ), 'KMAP:InvalidOutputSize'...
            );
        end
        function testRestrictOutputSize(testCase)
            testCase.verifyError(...
                @()karnaugh(...
                    [0 0 0; 0 1 0],...
                    [1 26],...
                    1....
                ), 'KMAP:RestrictOutputSize'...
            );
        end
        function testInvalidNumVars(testCase)
            testCase.verifyError(...
                @()karnaugh(...
                    [0 0 0; 0 1 0],...
                    [1 3],...
                    1....
                ), 'KMAP:InvalidNumVars'...
            );
        end
        function testInvalidColumnIndex(testCase)
            testCase.verifyError(...
                @()karnaugh(...
                    [0 0 0; 0 1 0],...
                    [1 1],...
                    4....
                ), 'KMAP:InvalidColumnIndex'...
            );
        end
        
        % Validation of Outputs
        function testValidKmap(testCase)
            kMapOut = karnaugh(...
                [0 0 0; 0 1 1; 1 0 1; 1 1 1],...
                [1 1],...
                3....
            );
            expected = {
                'A\B',  '0',    '1';
                '0',    '0',    '1';
                '1',    '1',    '1';
            };
            testCase.verifyEqual(kMapOut,expected)
            
            
            kMapOut = karnaugh(...
                [0 0 0; 0 1 1; 1 0 1; 1 1 1],...
                [1 1],...
                1....
            );
            expected = {
                'A\B',  '0',    '1';
                '0',    '0',    '1';
                '1',    'X',    'X';
            };
            testCase.verifyEqual(kMapOut,expected)
        end
    end
end