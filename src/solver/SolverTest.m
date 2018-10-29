classdef SolverTest < matlab.unittest.TestCase
    properties
    end
        
    methods (Test)
        %% Validation of Inputs
        function testInvalidSize(testCase)
            K = {
                'A\B',  '0',    '0',    '0';
                '0',    '1',    '1',    '1';
                '0',    '1',    '1',    '1';
            };
            testCase.verifyError(@()solver(K), 'SOLVER:InvalidSize');
        end
        function testInvalidInput(testCase)
            K = {
                'AB',   '0',    '1';
                '0',    '1',    '1';
                '1',    '1',    '1';
            };
            testCase.verifyError(@()solver(K), 'SOLVER:InvalidLabels');
        end
        
        %% Validation of Outputs
        %% All Ones
        function testOnes(testCase)
            K = {
                'A\B',  '0',    '1';
                '0',    '1',    '1';
                '1',    '1',    '1';
            };
            verifyEqual(testCase, solver(K), '1');
            verifyEqual(testCase, solver(K,'maxterm'), '1');
            
            K = {
                'A\BC', '00',   '01',   '11',   '10';
                '0',    '1',    '1',    '1',    '1';
                '1',    '1',    '1',    '1',    '1';
            };
            verifyEqual(testCase, solver(K), '1');
            verifyEqual(testCase, solver(K,'maxterm'), '1');
            
            K = {
                'AB\CD', '00',   '01',   '11',   '10';
                '00',   '1',    '1',    '1',    '1';
                '01',   '1',    '1',    '1',    '1';
                '11',   '1',    '1',    '1',    '1';
                '10',   '1',    '1',    '1',    '1';
            };
            verifyEqual(testCase, solver(K), '1');
            verifyEqual(testCase, solver(K,'maxterm'), '1');
        end
        
        %% All Zeros
        function testZeros(testCase)
            K = {
                'A\B',  '0',    '1';
                '0',    '0',    '0';
                '1',    '0',    '0';
            };
            verifyEqual(testCase, solver(K), '0');
            verifyEqual(testCase, solver(K,'maxterm'), '0');
            
            K = {
                'A\BC', '00',   '01',   '11',   '10';
                '0',    '0',    '0',    '0',    '0';
                '1',    '0',    '0',    '0',    '0';
            };
            verifyEqual(testCase, solver(K), '0');
            verifyEqual(testCase, solver(K,'maxterm'), '0');
            
            K = {
                'AB\CD', '00',   '01',   '11',   '10';
                '00',   '0',    '0',    '0',    '0';
                '01',   '0',    '0',    '0',    '0';
                '11',   '0',    '0',    '0',    '0';
                '10',   '0',    '0',    '0',    '0';
            };
            verifyEqual(testCase, solver(K), '0');
            verifyEqual(testCase, solver(K,'maxterm'), '0');
        end
        
        %% Upper Half of Ones
        function testUpper(testCase)
            K = {
                'A\B',  '0',    '1';
                '0',    '1',    '1';
                '1',    '0',    '0';
            };
            verifyEqual(testCase, solver(K), '(~A)');
            verifyEqual(testCase, solver(K,'maxterm'), '(~A)');
            
            K = {
                'A\BC', '00',   '01',   '11',   '10';
                '0',    '1',    '1',    '1',    '1';
                '1',    '0',    '0',    '0',    '0';
            };
            verifyEqual(testCase, solver(K), '(~A)');
            verifyEqual(testCase, solver(K,'maxterm'), '(~A)');
            
            K = {
                'AB\CD', '00',   '01',   '11',   '10';
                '00',   '1',    '1',    '1',    '1';
                '01',   '1',    '1',    '1',    '1';
                '11',   '0',    '0',    '0',    '0';
                '10',   '0',    '0',    '0',    '0';
            };
            verifyEqual(testCase, solver(K), '(~A)');
            verifyEqual(testCase, solver(K,'maxterm'), '(~A)');
        end
        
        %% Lower Half of Ones
        function testLower(testCase)
            K = {
                'A\B',  '0',    '1';
                '0',    '0',    '0';
                '1',    '1',    '1';
            };
            verifyEqual(testCase, solver(K), '(A)');
            verifyEqual(testCase, solver(K,'maxterm'), '(A)');
            
            K = {
                'A\BC', '00',   '01',   '11',   '10';
                '0',    '0',    '0',    '0',    '0';
                '1',    '1',    '1',    '1',    '1';
            };
            verifyEqual(testCase, solver(K), '(A)');
            verifyEqual(testCase, solver(K,'maxterm'), '(A)');
            
            K = {
                'AB\CD',    '00',   '01',   '11',   '10';
                '00',       '0',    '0',    '0',    '0';
                '01',       '0',    '0',    '0',    '0';
                '11',       '1',    '1',    '1',    '1';
                '10',       '1',    '1',    '1',    '1';
            };
            verifyEqual(testCase, solver(K), '(A)');
            verifyEqual(testCase, solver(K,'maxterm'), '(A)');
        end
        
        %% Left Column Half of Ones
        function testLeftSplit(testCase)
            K = {
                'A\B',  '0',    '1';
                '0',    '1',    '0';
                '1',    '1',    '0';
            };
            verifyEqual(testCase, solver(K), '(~B)');
            verifyEqual(testCase, solver(K,'maxterm'), '(~B)');
            
            K = {
                'A\BC', '00',   '01',   '11',   '10';
                '0',    '1',    '1',    '0',    '0';
                '1',    '1',    '1',    '0',    '0';
            };
            verifyEqual(testCase, solver(K), '(~B)');
            verifyEqual(testCase, solver(K,'maxterm'), '(~B)');
            
            K = {
                'AB\CD',    '00',   '01',   '11',   '10';
                '00',       '1',    '1',    '0',    '0';
                '01',       '1',    '1',    '0',    '0';
                '11',       '1',    '1',    '0',    '0';
                '10',       '1',    '1',    '0',    '0';
            };
            verifyEqual(testCase, solver(K), '(~C)');
            verifyEqual(testCase, solver(K,'maxterm'), '(~C)');
        end
        
        %% Right Column Half of Ones
        function testRightSplit(testCase)
            K = {
                'A\B',  '0',    '1';
                '0',    '0',    '1';
                '1',    '0',    '1';
            };
            verifyEqual(testCase, solver(K), '(B)');
            verifyEqual(testCase, solver(K,'maxterm'), '(B)');
            
            K = {
                'A\BC', '00',   '01',   '11',   '10';
                '0',    '0',    '0',    '1',    '1';
                '1',    '0',    '0',    '1',    '1';
            };
            verifyEqual(testCase, solver(K), '(B)');
            verifyEqual(testCase, solver(K,'maxterm'), '(B)');
            
            K = {
                'AB\CD',    '00',   '01',   '11',   '10';
                '00',       '0',    '0',    '1',    '1';
                '01',       '0',    '0',    '1',    '1';
                '11',       '0',    '0',    '1',    '1';
                '10',       '0',    '0',    '1',    '1';
            };
            verifyEqual(testCase, solver(K), '(C)');
            verifyEqual(testCase, solver(K,'maxterm'), '(C)');
        end
        
        %% Row Wrapping
        function testRowWrap(testCase)
            K = {
                'AB\CD',    '00',   '01',   '11',   '10';
                '00',       '1',    '1',    '1',    '1';
                '01',       '0',    '0',    '0',    '0';
                '11',       '0',    '0',    '0',    '0';
                '10',       '1',    '1',    '1',    '1';
            };
            verifyEqual(testCase, solver(K), '(~B)');
            verifyEqual(testCase, solver(K,'maxterm'), '(~B)');
        end
        
        %% Row Strips
        function testColumnWrap(testCase)
            K = {
                'AB\CD',    '00',   '01',   '11',   '10';
                '00',       '1',    '1',    '1',    '1';
                '01',       '0',    '0',    '0',    '0';
                '11',       '1',    '1',    '1',    '1';
                '10',       '0',    '0',    '0',    '0';
            };
            verifyEqual(testCase, solver(K), '(~A*~B)+(A*B)');
            verifyEqual(testCase, solver(K,'maxterm'), '(A+~B)*(~A+B)');
        end
        
        %% Row Strips
        function testRowStrips(testCase)
            K = {
                'AB\CD',    '00',   '01',   '11',   '10';
                '00',       '1',    '1',    '1',    '1';
                '01',       '0',    '0',    '0',    '0';
                '11',       '1',    '1',    '1',    '1';
                '10',       '0',    '0',    '0',    '0';
            };
            verifyEqual(testCase, solver(K), '(~A*~B)+(A*B)');
            verifyEqual(testCase, solver(K,'maxterm'), '(A+~B)*(~A+B)');
    
            K = {
                'AB\CD',    '00',   '01',   '11',   '10';
                '00',       '0',    '0',    '0',    '0';
                '01',       '1',    '1',    '1',    '1';
                '11',       '0',    '0',    '0',    '0';
                '10',       '1',    '1',    '1',    '1';
            };
            verifyEqual(testCase, solver(K), '(~A*B)+(A*~B)');
            verifyEqual(testCase, solver(K,'maxterm'), '(A+B)*(~A+~B)');
        end
        
        %% Coluumn Strips
        function testColumnStrips(testCase)
            K = {
                'AB\CD',    '00',   '01',   '11',   '10';
                '00',       '1',    '0',    '1',    '0';
                '01',       '1',    '0',    '1',    '0';
                '11',       '1',    '0',    '1',    '0';
                '10',       '1',    '0',    '1',    '0';
            };
            verifyEqual(testCase, solver(K), '(~C*~D)+(C*D)');
            verifyEqual(testCase, solver(K,'maxterm'), '(C+~D)*(~C+D)');
            
            K = {
                'AB\CD',    '00',   '01',   '11',   '10';
                '00',       '0',    '1',    '0',    '1';
                '01',       '0',    '1',    '0',    '1';
                '11',       '0',    '1',    '0',    '1';
                '10',       '0',    '1',    '0',    '1';
            };
            verifyEqual(testCase, solver(K), '(~C*D)+(C*~D)');
            verifyEqual(testCase, solver(K,'maxterm'), '(C+D)*(~C+~D)');
        end
        
        %% Wrap Around
        function testWrapAround(testCase)
            K = {
                'AB\CD',    '00',   '01',   '11',   '10';
                '00',       '1',    '0',    '0',    '1';
                '01',       '0',    '0',    '0',    '0';
                '11',       '0',    '0',    '0',    '0';
                '10',       '1',    '0',    '0',    '1';
            };
            verifyEqual(testCase, solver(K), '(~B*~D)');
            verifyEqual(testCase, solver(K,'maxterm'), '(~D)*(~B)');
            
            
            K = {
                'AB\CD',    '00',   '01',   '11',   '10';
                '00',       '1',    '1',    '1',    '1';
                '01',       '1',    '0',    '0',    '1';
                '11',       '1',    '0',    '0',    '1';
                '10',       '1',    '1',    '1',    '1';
            };
            verifyEqual(testCase, solver(K), '(~B)+(~D)');
            verifyEqual(testCase, solver(K,'maxterm'), '(~B+~D)');
        end
        
        %% Inner
        function testInner(testCase)
            K = {
                'AB\CD',    '00',   '01',   '11',   '10';
                '00',       '0',    '0',    '0',    '0';
                '01',       '0',    '1',    '1',    '0';
                '11',       '0',    '1',    '1',    '0';
                '10',       '0',    '0',    '0',    '0';
            };
            verifyEqual(testCase, solver(K), '(B*D)');
            verifyEqual(testCase, solver(K,'maxterm'), '(B)*(D)');
        end
        
        %% CheckerBoard
        function testCheckerboard(testCase)
            K = {
                'A\B',  '0',    '1';
                '0',    '0',    '1';
                '1',    '1',    '0';
            };
            verifyEqual(testCase, solver(K), '(~A*B)+(A*~B)');
            verifyEqual(testCase, solver(K,'maxterm'), '(A+B)*(~A+~B)');
            
            K = {
                'AB\CD',    '00',   '01',   '11',   '10';
                '00',       '1',    '0',    '1',    '0';
                '01',       '0',    '1',    '0',    '1';
                '11',       '1',    '0',    '1',    '0';
                '10',       '0',    '1',    '0',    '1';
            };
            
            verifyEqual(testCase, solver(K), '(~A*~B*~C*~D)+(~A*~B*C*D)+(~A*B*~C*D)+(~A*B*C*~D)+(A*~B*~C*D)+(A*~B*C*~D)+(A*B*~C*~D)+(A*B*C*D)');
            verifyEqual(testCase, solver(K,'maxterm'), '(A+B+C+~D)*(A+B+~C+D)*(A+~B+C+D)*(A+~B+~C+~D)*(~A+B+C+D)*(~A+B+~C+~D)*(~A+~B+C+~D)*(~A+~B+~C+D)');
        end
    end
end