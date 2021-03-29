# Karnaugh Map Generator and Solver
Simple scripts to generate a Karnaugh map from a truth table matrix or string and generate the Boolean expression for it.

## Startup
It is recommended to run the "runMe" script to add scripts to the path.

### Generator
The karnaughMap script will output a Karnaugh Map based on some specified parameters:
- **truthTableOrStr** (A truthtable of 1's and 0's that can have "missing rows" which will be replaced by don't cares).  
    Can also a be a string of the format: 'm' (for minterm) or 'M' for (maxterm) followed by parentheses enclosed comma seperated numbers
    with the addition of optional dont care string of a similar format.  
    It will assume the last column to be the output.)  
    
    e.g. ``[0 0 0; 0 1 1; 1 0 1; 1 1 1]``  ("or" truth table)  
    e.g. ``'m(1,2,3)'`` (same as above)  
    e.g. ``'m(0)+d(3)'`` (1 at index 0, 'X' at index 3)  
    
- **outputSize** (Number of variables to place for the rows and columns)  

    e.g. [1 2] will generate 2 x 4 Karnaugh Map with the first row and column contain graycode labels
    with the rows alternating from 0 to 1, and the columns alternating from '00' to '10'.)
    ```
    {
        'A\BC', '00',   '01',   '11',   '10';
        '0',    '1',    '1',    '0',    '0';
        '1',    '1',    '1',    '0',    '0';
    };
    ```
    
Optional Parameters:
- **fillerType** (If string or table contains "missing rows", it will populate the rest of the table
    with 'X' (don't cares) by default unless it is supplied a different character ('0', '1', etc))

### Solver
The solver will utilize the Quine-McCluskey for generating a solution to a given K-Map (generated from the KarnaughMap method).

Parameters:
- **KMap**  (The Karnaugh map cell array created from the generator)

Optional Parameters:
- **type** (Put 'minterm' if you want MinTerm logic , 'maxterm' if you want MaxTerm logic).  
    By default, it will some for MinTerm logic.

### Usage 
Run the 'runMe' command to add scripts to path.
```
runMe
```

Generate a Karnaugh Map cell from some truth-table.
```
TruthTable = [0 0 0; 0 1 1; 1 0 1; 1 1 1];
OR = karnaughMap(TruthTable, [1 1])
```
Outputs:
```
OR =

  3×3 cell array

    {'A\B'}    {'0'}    {'1'}
    {'0'  }    {'0'}    {'1'}
    {'1'  }    {'1'}    {'1'}
```
Now we run the solver program:
```
solver(OR)
```
Outputs:
```
ans =

    '(B)+(A)'
```
Maxterm Logic:
```solver
solver(OR, 'maxterm')

ans =

    '(A+B)'
```
