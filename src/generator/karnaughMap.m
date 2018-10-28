function kMat = karnaughMap(truthTableOrStr, outputSize, varargin)
%% Generates a Karnaugh Map matrix from some truthtable and chosen output column
% truthTable - a binary matrix, "missing" rows will be treated as don't cares
% ouputSize - array specifying how many variables to 


%% Validate Inputs
%%
truthTable = truthTableOrStr;
numVars = sum(outputSize);

numvarargs = length(varargin);
optargs = {'X'};

if (ischar(truthTableOrStr))
    % Non-valid string
    if (isempty(regexp(truthTableOrStr, '^(m|M)\((\d+)(,\s*\d+)*\)(\s*\+\s*(d)\((\d+)(,\s*\d+)*\))*$')))
        error(...
        'KMAP:InvalidStr',...
        'Function string must begin with "m" (for minterm) or "M" (for maxterm) followed by numbers (comma seperated) enclosed in paranthesis.' ...
        );
    else
        % Extract minterms/maxterms and dont-cares if provided
        matchCell = regexp(truthTableOrStr, '(\d+)(,\s*\d+)*', 'match');
        dontCares = [];
        
        [truthTable, I, J] = unique(str2num(matchCell{1}));
        if (length(matchCell) == 2)
            [dontCares, DI, DJ] = unique(str2num(matchCell{2}));
        end
        
        isMinTerm = 1;
        outputCol = ones(length(truthTable),1);
        optargs{1} = '0';
        if (truthTableOrStr(1) == 'M')
            isMinTerm = 0;
            outputCol = outputCol - 1;
            optargs{1} = '1';
        end
        
        % transforming numbers from string to binary representation
        if (length(I) ~= length(J))
            warning('Minterm/Maxterm string contains duplicate values.');
        end
        if (length(matchCell) == 2 && length(DI) ~= length(DJ))
            warning('Don''''t cares string contains duplicate values.');
        end
        if (intersect(a,b))
            error('KMAP:Duplicates', 'Minterm/maxterms contain one or more matching values with don''''t cares');
        end
        truthTable = str2double(num2cell(dec2bin(truthTable)));
        dontCares = str2double(num2cell(dec2bin(dontCares)));
        
        % padding with output column
        truthTable = [truthTable outputCol];
    end
end

% Invaid truth table
[tr tc] = size(truthTable);
isEmpty = sum(tr + tc) == 0;

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
b
if (isEmpty)
    return;
end

%% Checking duplicates
%%
outputEntries = truthTable(:,end);
trimmedTable = truthTable;
trimmedTable(:,end) = [];
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
% rows excluding the last column will be mapped to binary values
rowInds = binArr2Dec(trimmedTable(:,1:rowVars));
colInds = binArr2Dec(trimmedTable(:,rowVars+1:end));

% Performing graycode inverse and offsetting for placement
rowInds = graycodeInv(rowInds) + 2;
colInds = graycodeInv(colInds) + 2;

linearInds = sub2ind([rows + 1, cols + 1], rowInds, colInds);
kMat(linearInds) = outputEntries;
end