function kMat = karnaugh( truthTable, outputSize, varargin )
%% Generates a Karnaugh Map matrix from some truthtable and chosen output column
% truthTable - a binary matrix, "missing" rows will be treated as don't cares
% ouputSize - array specifying how many variables to 


%% Validate Inputs
%%
% Invaid truth table
[tl tw] = size(truthTable);
if (all(truthTable(:) < 2) == 0)
    error('KMap:BinaryInput', 'Binary values only. Discard rows with don''t cares.')
end
if (tl > 2^tw)
    error('KMap:InvalidRowCount', 'Truth table length must not be greater than 2^(number of columns).')
end

% Invalid output size
[ol ow] = size(outputSize);
if (ol ~= 1 && ow ~= 2)
    error('KMap:InvalidOutputSize', 'Output size must be a 1 by 2 matrix.')
end
if (sum(outputSize) > 26)
    error('KMap:InvalidOutputSize', 'Custom labels must be provided for sizes greather than 26.')
end
if (sum(outputSize) ~= tw - 1)
    error('KMap:InvalidOutputSize', 'Number of variables must be one less than the number of columns of the truth table.')
end

% options = varargin{:}


%% Initalize
%%
dontCare = 'X';
rows = 2^outputSize(1);
cols = 2^outputSize(2);

kMat = cell(rows + 1, cols + 1, 1)
kMat(2:end, 2:end) = {dontCare};

% TODO: custom label
%% Labelings
%%
str = ''
for ii = 1:outputSize(1)
    str = strcat(str,64+ii);
end
str = strcat(str, '/');
for ii = 1:outputSize(2)
    str = strcat(str,64+ol+ii);
end
kMat(1,1,1) = {str}




end

