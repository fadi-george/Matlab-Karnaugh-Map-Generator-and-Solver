classdef KarnaughMapTest < matlab.unittest.TestCase
    properties
    end
        
    methods (Test)
        % Validation of Inputs
        function testBinary(testCase)
            testCase.verifyError(@()karnaughMap([1 0 2], [1 1]), 'KMAP:BinaryInput')
        end
        function testRowCount(testCase)
            testCase.verifyError(...
                @()karnaughMap(...
                    [0 0 1; 0 1 1; 1 0 1; 1 1 1; 1 0 0],...
                    [1 1]...
                ), 'KMAP:InvalidRowCount'...
            );
        end
        function testInvalidOutputSize(testCase)
            testCase.verifyError(...
                @()karnaughMap(...
                    [0 0 0; 0 1 0],...
                    [1 1 3]...
                ), 'KMAP:InvalidOutputSize'...
            );
        end
        function testRestrictOutputSize(testCase)
            testCase.verifyError(...
                @()karnaughMap(...
                    [0 0 0; 0 1 0],...
                    [1 26]...
                ), 'KMAP:RestrictOutputSize'...
            );
        end
        function testInvalidNumVars(testCase)
            testCase.verifyError(...
                @()karnaughMap(...
                    [0 0 0; 0 1 0],...
                    [1 3]...
                ), 'KMAP:InvalidNumVars'...
            );
        end
        
        %% Validation of Outputs
        % Binary inputs
        function testValidKmap(testCase)
            kMapOut = karnaughMap(...
                [0 0 0; 0 1 1; 1 0 1; 1 1 1],...
                [1 1]...
            );
            expected = {
                'A\B',  '0',    '1';
                '0',    '0',    '1';
                '1',    '1',    '1';
            };
            testCase.verifyEqual(kMapOut,expected)
                        
            kMapOut = karnaughMap(...
                [0 0 0; 0 1 1],...
                [1 1]...
            );
            expected = {
                'A\B',  '0',    '1';
                '0',    '0',    '1';
                '1',    'X',    'X';
            };
            testCase.verifyEqual(kMapOut,expected);
        end
        
        function testLargeKMaps(testCase)
            kMapOut = karnaughMap([
                0 0 0 0 1 1;
                0 0 0 1 1 1;
                0 0 0 1 0 1;
                0 1 0 1 1 1;
                1 0 0 0 1 1;
                1 0 0 1 1 1;
                0 0 1 1 1 1;
                0 0 1 0 1 1;
                0 1 1 0 1 1;
                1 1 1 1 1 1;
                1 1 1 0 1 1;
                1 0 1 1 1 1;
            ], [2, 3], '0');
            expected = {
                'AB\CDE',   '000',  '001',  '011',  '010',  '110',  '111',  '101',  '100';
                '00',       '0',    '1',    '1',    '1',    '0',    '1',    '1',    '0';
                '01',       '0',    '0',    '1',    '0',    '0',    '0',    '1',    '0';
                '11',       '0',    '0',    '0',    '0',    '0',    '1',    '1',    '0';
                '10',       '0',    '1',    '1',    '0',    '0',    '1',    '0',    '0';
            };
            testCase.verifyEqual(kMapOut,expected);
        end
        
        % Minterm/Maxterm Strings
        function testMinTermStr(testCase)
            kMapOut = karnaughMap('m(0,4,5,7,8,11,12,15)', [2, 2]);
            expected = {
                'AB\CD',    '00',   '01',   '11',   '10';
                '00',       '1',    '0',    '0',    '0';
                '01',       '1',    '1',    '1',    '0';
                '11',       '1',    '0',    '1',    '0';
                '10',       '1',    '0',    '1',    '0';
            };
            testCase.verifyEqual(kMapOut,expected);
            
            kMapOut = karnaughMap('m(0)', [1, 1], 'X');
            expected = {
                'A\B',  '0',    '1';
                '0',    '1',    'X';
                '1',    'X',    'X';
            };
            testCase.verifyEqual(kMapOut,expected);
        end
        
        function testMinTermDontCareStr(testCase)
            kMapOut = karnaughMap('m(4,6,9,10,11,13)+d(2,12,15)', [2, 2]);
            expected = {
                'AB\CD',    '00',   '01',   '11',   '10';
                '00',       '0',    '0',    '0',    'X';
                '01',       '1',    '0',    '0',    '1';
                '11',       'X',    '1',    'X',    '0';
                '10',       '0',    '1',    '1',    '1';
            };
            testCase.verifyEqual(kMapOut,expected);
        end
    end
end