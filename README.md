# Karnaugh Map Generator and Solver
Simple scripts to generate a Karnaugh map from a truth table and generate the Boolean expression for it.

### Generator
The karnaughMap script will output a Karnaugh Map based on some specified parameters:
- **sizeMat** (A 1x2 matrix, number of variables to put on the row / column )
- **truthTable** (A truthtable of 1's and 0's that can have "missing rows" which will be replaced by don't cares)
- **columnChoice** (The column in the truth table to place on the Karnaugh Map)

Optional Parameters:
- **optLabels**  (Labels for the KarnaughMap, only ASCII characters allowed)
- **optLogic** (FlipFlop logic will be displayed into seperate matrices except for T flip flop)

### Solver
The genLogic script will perform grouping in powers of 2 for either MinTerm or MaxTerm logic.

Parameters:
- **kMat**  (The Karnaugh map cell array created from the generator)
- **midOrMax** (Put 1 if you want MinTerm logic , 0 if you want MaxTerm logic)

### Usage 
A driver program is provided to play around with and test.
An example of generating a truth table for the or operaiton:

```
A = [0 0 0; 0 1 1; 1 0 1; 1 1 1]
K1 = karnaughMap( [1 , 1] , A , 3 )
genLogic( K1 , 1 )

ans =
A + B
```

