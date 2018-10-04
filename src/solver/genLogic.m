function logicStr = genLogic(KMapIn, matchValue, rowInds, colInds)
%%
KMapSelect = KMapIn(rowInds, colInds);
isMinTerm = strcmp(matchValue,'1');

fullMatchZero = all(all(strcmp(KMapSelect, '0')));
fullMatchOne = all(all(strcmp(KMapSelect, '1')));
[rows, cols] = size(KMapSelect);

labels = strsplit(KMapIn{1,1}, '\');
rowLabelLen = length(labels{1});
colLabelLen = length(labels{2});

%% For regexp string simplification
cellOp = '*';
groupOp = '+';
if (~isMinTerm)
    cellOp = '+';
    groupOp = '*';
end
regStr = '(^\+*|^\**)|(\+*$|\**$)';

%% All values matched the search term
%%
rowStr = '';
colStr = '';

if (rows == 2^rowLabelLen && cols == 2^colLabelLen)
    if (fullMatchZero)
        logicStr = '0';
        return;
    end
    if (fullMatchOne)
        logicStr = '1';
        return;
    end
end

if (fullMatchZero || fullMatchOne)
    if ((fullMatchZero & isMinTerm) || (fullMatchOne & ~isMinTerm))
        logicStr = '';
        return;
    end
    
    % Must check which portions of the gray code stays the same
    binRowMat = cell2mat( cellfun(@(str) str - '0', KMapIn(rowInds, 1),'un',0) );
    binColMat = cell2mat( cellfun(@(str) str - '0', KMapIn(1, colInds)','un',0) );

    % In case of a single row/column, difference in the graycodes will be 0
    labelRowInds = logical(~diff(binRowMat));
    barRowInds = logical(all(binRowMat == 0));
    labelColInds = logical(~diff(binColMat));
    barColInds = logical(all(binColMat == 0));

    [bRows, ~] = size(binRowMat);
    if (bRows == 1)
        labelRowInds = true(rowLabelLen,1);
        barRowInds = logical(binRowMat == 0);
    end
    [bRows, ~] = size(binColMat);
    if (bRows == 1)
        labelColInds = true(colLabelLen,1);
        barColInds = logical(binColMat == 0);
    end
    
    % Extract label letters that match with graycode positions that
    % don't change
    % In the case of one row/col, we keep all the letters
    
    % In case of one row/col, we only keep "bar" symbols for positions
    % where they are 0 or 1 depending or not if it is a minterm or
    % maxterm expression
    if (~isMinTerm)
        barRowInds = ~barRowInds;
        barColInds = ~barColInds;
    end
    
    if (rows < 2^rowLabelLen)
        bars = repmat('~', 1, rowLabelLen);
        bars(~barRowInds) = ' ';
            
        rowStr = labels{1};
        rowStr(~labelRowInds) = ' ';

        rowStr = cellstr((vertcat(bars, rowStr)'));
        rowStr = rowStr(~(strcmp(rowStr, '~') | strcmp(rowStr, '')));
        rowStr = strjoin(rowStr, cellOp);
    end
    if (cols < 2^colLabelLen)
        bars = repmat('~', 1, colLabelLen);
        bars(~barColInds) = ' ';

        colStr = labels{2};
        colStr(~labelColInds) = ' ';
        
        colStr = cellstr((vertcat(bars, colStr)'));
        colStr = colStr(~(strcmp(colStr, '~') | strcmp(colStr, '')));
        colStr = strjoin(colStr, cellOp);
    end
    
    
    if (~isempty(rowStr))
        rowStr = strcat('(', rowStr);
        if (isempty(colStr))
            rowStr = strcat(rowStr, ')');
        end
    end
    if (~isempty(colStr))
        colStr = strcat(colStr, ')');
        if (isempty(rowStr))
            colStr = strcat('(', colStr);
        end
    end
    
    if (~isempty(rowStr) && ~isempty(colStr))
        logicStr = strjoin({rowStr, colStr}, cellOp);
        return;
    end
else
    %% Divide areas by 2 but also wrapping around
    %%
    %visitedRowInds = [];
    rowDiv = 0;
    colDiv = 0;
    
    % Recusrive sub-dvisions of the original array
    if (rows > 1)
        rowDiv = rows/2;
    end
    if (cols > 1)
        colDiv = cols/2;
    end
    rowStr = '';
    
    
    % Rows may wrap, so we cycle the inner matrix downwards to mimic this
    % tempStr = '';
    minLen = Inf;
    for ii = 1:rowDiv
        rowShiftInds = circshift(rowInds, ii - 1);
        
        rowUpInds = rowShiftInds(1:rowDiv);
        rowUpperStr = genLogic(KMapIn, matchValue, rowUpInds, colInds);
        
        rowLowInds = rowShiftInds(rowDiv+1:end);
        rowLowerStr = genLogic(KMapIn, matchValue, rowLowInds, colInds);
        
        if (~isempty(rowUpperStr))
            if (length(rowUpperStr) < minLen)
                rowStr = rowUpperStr;
                minLen = length(rowUpperStr);
            elseif (length(rowUpperStr) == minLen)
                rowStr = strjoin({rowStr, rowUpperStr}, groupOp);
            end
        end
        
        if (~isempty(rowLowerStr))
            if (length(rowLowerStr) < minLen)
                rowStr = rowLowerStr;
                minLen = length(rowLowerStr);
            elseif (length(rowLowerStr) == minLen)
                rowStr = strjoin({rowStr, rowLowerStr}, groupOp);
            end
        end
    end
    
    tempStr = unique(strsplit(rowStr, groupOp), 'stable');
    tempStr = strjoin(tempStr, groupOp);
    tempStr = regexprep(tempStr, regStr, '');
    rowStr = tempStr;
    
    % Rows may wrap, so we cycle the inner matrix downwards to mimic this
    % tempStr = '';
    for ii = 1:colDiv
        colShiftInds = circshift(colInds, ii - 1);
        
        colLeftInds = colShiftInds(1:colDiv);
        colLeftStr = genLogic(KMapIn, matchValue, rowInds, colLeftInds);
        
        colRightInds = colShiftInds(colDiv+1:end);
        colRightStr = genLogic(KMapIn, matchValue, rowInds, colRightInds);
        
        if (~isempty(colLeftStr))
            if (length(colLeftStr) < minLen)
                rowStr = '';
                colStr = colLeftStr;
                minLen = length(colLeftStr);
            elseif (length(colLeftStr) == minLen)
                colStr = strjoin({colStr, colLeftStr}, groupOp);
            end
        end
        
        if (~isempty(colRightStr))
            if (length(colRightStr) < minLen)
                rowStr = '';
                colStr = colRightStr;
                minLen = length(colRightStr);
            elseif (length(colRightStr) == minLen)
                colStr = strjoin({colStr, colRightStr}, groupOp);
            end
        end
    end
       
    tempStr = unique(strsplit(colStr, groupOp), 'stable');
    tempStr = strjoin(tempStr, groupOp);
    tempStr = regexprep(tempStr, regStr, '');
    colStr = tempStr;
end

%% Combine logic strings from row and columns
%%
tempStr = unique(strsplit(strjoin({rowStr, colStr}, groupOp), groupOp), 'stable');
tempStr = strjoin(tempStr, groupOp);
logicStr = regexprep(tempStr, regStr, '');
logicStr = char(logicStr);

end

