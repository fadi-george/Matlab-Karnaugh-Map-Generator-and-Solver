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
    end
end