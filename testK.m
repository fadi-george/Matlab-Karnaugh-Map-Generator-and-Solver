clc;
%% Usage of Karnaugh Map generator and solver
%%
% Some truth table
% Let leftmost column be some input, the next three columns be the present state, and the
% next three columns be the next state values
A = [0 0 0 0    0 0 1;
     0 0 0 1    0 1 1;
     0 0 1 0    1 0 0;
     0 0 1 1    1 0 1;
     0 1 0 0    1 1 0;
     0 1 0 1    0 0 0;
     0 1 1 0    0 0 0;

     1 0 0 0    0 1 0;
     1 0 0 1    1 0 0;
     1 0 1 0    0 1 1;
     1 0 1 1    1 1 0; 
     1 1 0 0    1 0 1;
     1 1 0 1    0 0 0;
     1 1 1 0    0 0 0]

% Create a Karnaugh Map for the 5th column in the truth table
% Put 1 variable on the left side, 3 variables on the top
K1 = karnaughMap( [1 , 3] , A , 5 )
% Generate logic for Karnaugh map above , second paramter is optional and will default to MinTerm logic
genLogic( K1 )

% Same as above with different letters than the default ones and a different size
K2 = karnaughMap( [2 , 2] , A , 5 , {'X','Y','Z','W'} )
genLogic( K2 )

% Create Reset-Set matrices for the 5th column , will use the 2nd column as
% the present state
K1 = karnaughMap( [2 , 2] , A , 5 , {} , {'RS',2} );
R1 = K1(:,:,1)
S1 = K1(:,:,2)
genLogic(R1 , 1)
genLogic(S1 , 0)

