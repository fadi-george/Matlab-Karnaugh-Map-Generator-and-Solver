function kMat = karnaugh( truthTable, outputSize, columnIndex, varargin )
%% Generates a Karnaugh Map matrix from some truthtable and chosen output column
% truthTable - a binary matrix, "missing" rows will be treated as don't cares
% ouputSize - array specifying how many variables to 


%% Validate Inputs
%%
% Invaid truth table
[tr tc] = size(truthTable);
if (all(truthTable(:) < 2) == 0)
    error('KMap:BinaryInput', 'Binary values only. Discard rows with don''t cares.')
end
if (tr > 2^tc)
    error('KMap:InvalidRowCount', 'Truth table length must not be greater than 2^(number of columns).')
end
if (~isequal(size(unique(truthTable, 'rows')), size(truthTable)))
    error('KMap:NonUniqueRows', 'Truth table must not have repeated rows.')
end

% Invalid output size
[or oc] = size(outputSize);
if (or ~= 1 && oc ~= 2)
    error('KMap:InvalidOutputSize', 'Output size must be a 1 by 2 matrix.')
end
if (sum(outputSize) > 26)
    error('KMap:InvalidOutputSize', 'Custom labels must be provided for sizes greather than 26.')
end
if (sum(outputSize) ~= tc - 1)
    error('KMap:InvalidOutputSize', 'Number of variables must be one less than the number of columns of the truth table.')
end

% Invalid column
if (columnIndex < 1 || columnIndex > tc)
    error('KMap:InvalidColumnIndex', 'Column index must fall within the number of columns of the truth table.')
end

% options = varargin{:}


%% Initalize
%%
dontCare = 'X';
rowVars = outputSize(1);
colVars = outputSize(2);

rows = 2^rowVars;
cols = 2^colVars;

kMat = cell(rows + 1, cols + 1, 1)
kMat(2:end, 2:end) = {dontCare};

% TODO: custom label
%% Labelings
%%
str = '';
for ii = 1:outputSize(1)
    str = strcat(str,64+ii);
end
str = strcat(str, '/');
for ii = 1:outputSize(2)
    str = strcat(str,64+oc+ii);
end
kMat(1,1,1) = {str}

% Gray codes
for rr = 2:rows+1
    kMat(rr,1) = {dec2bin(graycode(rr - 2),rowVars)};
end
for cc = 2:cols+1
    kMat(1,cc) = {dec2bin(graycode(cc - 2),colVars)};
end


%% Map Rows to Map
%%
% Mapping output column to a cell array
outputEntries = cellstr(num2str(truthTable(:,columnIndex)));
trimmedTable = truthTable;
trimmedTable(:,columnIndex) = [];

% rows excluding the columnIndex will be mapped to binary values
rowInds = binArr2Dec(trimmedTable(:,1:rowVars));
colInds = binArr2Dec(trimmedTable(:,rowVars+1:end));
rowInds = graycode(rowInds) + 2;
colInds = graycode(colInds) + 2;

linearInds = sub2ind([rows + 1, cols + 1], rowInds, colInds);
kMat(linearInds) = outputEntries;
end

