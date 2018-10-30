function kMat = karnaughMap(truthTableOrStr, outputSize, varargin)
%% Generates a Karnaugh Map matrix from some truthtable and chosen output column
% truthTable    - truthTableOrStr: a binary matrix, "missing" rows will be treated as don't cares
%               e.g. [0 0 0; 0 1 1; 1 0 1; 1 1 1] ("or" operation)
%               
%               or a string beginning or "m" (for minterms) or "M" for
%               matrixs and comma seperated numbers enclosed in parentheses
%               dont cares can also be included in a similar fashion
%               (starts with "d" and uses comma seperated values enclosed
%               in parentheses)
%               e.g. 'm(1,2,3)' ("or" operation)
%               e.g. 'm(0)+d(3)' 
%
%               - outputSize: the number of variables to use for rows and
%               columns
%               e.g. [1, 2] will construct a table two graycode rows long
%               and four graycode columns wide
%
%               - optionals:
%               -- fillerType: If string or table contains "missing rows",
%               it will populate the rest of the table with don't cares by
%               default unless it is provided with a different a character
%               e.g. '0' will fill the rest of karnaugh map with zeros
%               


%% Validate Inputs
%%
truthTable = truthTableOrStr;
numVars = sum(outputSize);

numvarargs = length(varargin);
optargs = {'X'};

if (ischar(truthTableOrStr))
    % Non-valid string
    if (isempty(regexp(truthTableOrStr, '^(m|M)\((\d+)(,\s*\d+)*\)(\s*\+\s*(d)\((\d+)(,\s*\d+)*\))*$', 'once')))
        error(...
        'KMAP:InvalidStr',...
        'Function string must begin with "m" (for minterm) or "M" (for maxterm) followed by numbers (comma seperated) enclosed in parentheses.' ...
        );
    else
        % Extract minterms/maxterms and dont-cares if provided
        matchCell = regexp(truthTableOrStr, '(\d+)(,\s*\d+)*', 'match');
        dontCares = [];
        
        [truthTable, I, J] = unique(str2num(matchCell{1}));
        if (length(matchCell) == 2)
            [dontCares, DI, DJ] = unique(str2num(matchCell{2}));
        end
        
        outputCol = repmat({'1'}, length(truthTable), 1);
        optargs{1} = '0';
        if (truthTableOrStr(1) == 'M')
        outputCol = repmat({'0'}, length(truthTable), 1);
            optargs{1} = '1';
        end
        
        % transforming numbers from string to binary representation
        if (length(I) ~= length(J))
            warning('Minterm/Maxterm string contains duplicate values.');
        end
        if (length(matchCell) == 2 && length(DI) ~= length(DJ))
            warning('Don''''t cares string contains duplicate values.');
        end
        if (intersect(truthTable, dontCares))
            error('KMAP:Duplicates', 'Minterm/maxterms contain one or more matching values with don''''t cares');
        end
        
        % Combine with dontcares (if they exist)
        truthTable = [num2cell(dec2bin(truthTable, numVars)) outputCol];
        if (~isempty(dontCares))
            dontCareOutput = repmat({'X'}, length(dontCares), 1);
            truthTable = [truthTable; num2cell(dec2bin(dontCares, numVars)) dontCareOutput];
        end
    end

% TODO: Allow cell input
%elseif (iscell(truthTableOrStr))
    
else
    if (all(truthTable(:) <= 1 & truthTable(:) >= 0) == 0)
        error('KMAP:BinaryInput', 'Binary values only. Discard rows with don''t cares.')
    end
    % Convesrion to cell of strings
   truthTable = arrayfun(@num2str, truthTable, 'UniformOutput', false);
end

% Additional Validation
% Invaid truth table
[tr tc] = size(truthTable);
isEmpty = sum(tr + tc) == 0;

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
if (isEmpty)
    return;
end

%% Checking duplicates
%%
outputEntries = truthTable(:,end);
trimmedTable = truthTable;
trimmedTable(:,end) = [];
[~, R, L] = unique(cell2mat(trimmedTable), 'rows', 'stable');
trimmedTable = trimmedTable(R,:);
outputEntries = outputEntries(R);

dupRowInds = L(hist(L,unique(L))>1);
if (~isempty(dupRowInds))
    warning('Duplicate rows excluding the output column will be removed.');
    trimmedTable(dupRowInds,:) = [];
    outputEntries(dupRowInds) = [];
end

%% Map Rows to Map
%%
% Mapping output column to a cell array
% rows excluding the last column will be mapped to binary values
tempRows = cell2mat(trimmedTable(:,1:rowVars)) - '0';
rowInds = binArr2Dec(tempRows);

tempCols = cell2mat(trimmedTable(:,rowVars+1:end)) - '0';
colInds = binArr2Dec(tempCols);

% Performing graycode inverse and offsetting for placement
rowInds = graycodeInv(rowInds) + 2;
colInds = graycodeInv(colInds) + 2;

linearInds = sub2ind([rows + 1, cols + 1], rowInds, colInds);
kMat(linearInds) = outputEntries;
end