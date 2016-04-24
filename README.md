# KarnaughMapMatlab
Simple scripts to generate a Karnaugh map from a truth table and generate the Boolean expression for it.

### Generator
The karnaughMap script will output a Karnaugh Map based on some specified parameters:
- **sizeMat**  (A 1x2 matrix, whose first entry specifies the number of rows, and second entry specifies number of columns)
- **truthTable** (A truthtable of 1's and 0's that can have "missing rows" which will be replaced by don't cares)
- **columnChoice** (The column in the truth table to place on the Karnaugh Map)

Optional Parameters:
- **optLabels**  (Labels for the KarnaughMap, only ASCII characters allowed)
- **optLogic** (FlipFlop logic will be displayed into seperate matrices, only RS supported for now )

### Solver
The genLogic script will perform grouping in powers of 2 for either MinTerm or MaxTerm logic.

Parameters:
- **kMat**  ( the Karnaugh map cell array created from the generator )
- **midOrMax** ( put 1 if you want MinTerm logic , 0 if you want MaxTerm logic )
