function kMat = karnaughMap( truthTable, outputSize, columnIndex, varargin)
%% Generates a Karnaugh Map matrix from some truthtable and chosen output column
% truthTable - a binary matrix, "missing" rows will be treated as don't cares
% ouputSize - array specifying how many variables to 


%% Validate Inputs
%%
% Invaid truth table
[tr tc] = size(truthTable);
isEmpty = sum(tr + tc) == 0;
numVars = sum(outputSize);

if (all(truthTable(:) <= 1 & truthTable(:) >= 0) == 0)
    error('KMAP:BinaryInput', 'Binary values only. Discard rows with don''t cares.')
end
if (tr > 2^(tc - 1))
    error('KMAP:InvalidRowCount', 'Truth table contains too many rows when excluding chosen column.')
end

% Invalid output size
[or oc] = size(outputSize);
if (or ~= 1 || oc ~= 2)
    error('KMAP:InvalidOutputSize', 'Output size must be a 1 by 2 matrix.')
end
if (numVars > 26)
    error('KMAP:RestrictOutputSize', 'Custom labels must be provided for sizes greather than 26.')
end
if (~isEmpty && numVars ~= tc - 1)
    error('KMAP:InvalidNumVars', 'Number of variables must be one less than the number of columns of the truth table.')
end

% Invalid column
if (columnIndex < 1 || columnIndex > numVars + 1)
    error('KMAP:InvalidColumnIndex', 'Column index must fall within the number of columns of the truth table.')
end

numvarargs = length(varargin);
optargs = {'X'};
optargs(1:numvarargs) = varargin;
[fillerType] = optargs{:};
    
%% Initalize
%%
rowVars = outputSize(1);
colVars = outputSize(2);

rows = 2^rowVars;
cols = 2^colVars;

kMat = cell(rows + 1, cols + 1, 1);
kMat(2:end, 2:end) = {fillerType};

% TODO: custom label
%% Labelings
%%
str = strcat(char(65:64+outputSize(1)), '\', char(65+outputSize(1):64+sum(outputSize)));
kMat(1,1,1) = {str};

% Gray codes
kMat(2:rows+1,1) = cellstr(dec2bin(graycode(0:rows-1),rowVars));
kMat(1,2:cols+1) = cellstr(dec2bin(graycode(0:cols-1),colVars));

if (isEmpty)
    return;
end

%% Checking duplicates
%%
outputEntries = truthTable(:,columnIndex);
trimmedTable = truthTable;
trimmedTable(:,columnIndex) = [];
[trimmedTable, R, L] = unique(trimmedTable, 'rows', 'stable');
outputEntries = outputEntries(R);

dupRowInds = L(hist(L,unique(L))>1);
if (~isempty(dupRowInds))
    warning('Duplicate rows excluding the output column will be removed.');
    trimmedTable(dupRowInds,:) = [];
    outputEntries(dupRowInds) = [];
end
outputEntries=cellstr(num2str(outputEntries));

%% Map Rows to Map
%%
% Mapping output column to a cell array
% rows excluding the columnIndex will be mapped to binary values
rowInds = binArr2Dec(trimmedTable(:,1:rowVars));
colInds = binArr2Dec(trimmedTable(:,rowVars+1:end));

% Performing graycode inverse and offsetting for placement
rowInds = graycodeInv(rowInds) + 2;
colInds = graycodeInv(colInds) + 2;

linearInds = sub2ind([rows + 1, cols + 1], rowInds, colInds);
kMat(linearInds) = outputEntries;
end