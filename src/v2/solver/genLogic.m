function logicStr = genLogic(KMapIn, matchValue, rowInds, colInds)
%%
KMapSelect = KMapIn(rowInds, colInds);
isMinTerm = strcmp(matchValue,'1');

fullMatchZero = all(all(strcmp(KMapSelect, '0')));
fullMatchOne = all(all(strcmp(KMapSelect, '1')));
[rows cols] = size(KMapSelect);

labels = strsplit(KMapIn{1,1}, '\');
rowLabelLen = length(labels{1});
colLabelLen = length(labels{2});

%% For regexp string simplification
op = '+';
groupOp = '*';
if (~isMinTerm)
    op = '*';
    groupOp = '+';
end
regStr = strcat('^\',op,'*|','\',op,'*$');

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

if ((fullMatchZero && ~isMinTerm) || (fullMatchOne && isMinTerm))        
    % Must check which portions of the gray code stays the same
    binMat = cell2mat( cellfun(@(str) str - '0', KMapIn(rowInds, 1),'un',0) );

    % In case of a single row, difference in the graycodes will be 0 
    [bRows, ~] = size(binMat);

    labelInds = logical(~diff(binMat));
    barInds = logical(~diff(binMat));
    if (bRows == 1)
        labelInds = true(rowLabelLen,1);
        barInds = ~logical(binMat);
    end

    % Extract label letters that match with graycode positions that
    % don't change
    % In the case of one row/col, we keep all the letters
    rowStr = labels{1};
    rowStr(~labelInds) = ' ';

    % In case of one row/col, we only keep "bar" symbols for positions
    % where they are 0 or 1 depending or not if it is a minterm or
    % maxterm expression
    bars = repmat('~', 1, rowLabelLen);
    %if (~isMinTerm)
    %    barInds = ~barInds;
    %end
    bars(~barInds) = ' ';
    
    rowStr = cellstr((vertcat(bars, rowStr)'));
    rowStr = rowStr(~(strcmp(rowStr, '~') | strcmp(rowStr, '')));
    rowStr = strjoin(rowStr, groupOp);
    rowStr = strcat('(', rowStr, ')');
    
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
    rowCellStrs = {rowStr};
    
    
    % Rows may wrap, so we cycle the inner matrix downwards to mimic this
    % tempStr = '';
    minLen = Inf;
    for ii = 1:rowDiv
        rowShiftInds = circshift(rowInds, ii - 1);
        %colShiftInds

        rowUpInds = rowShiftInds(1:rowDiv);
        %isTopVisited = all(ismember(rowUpInds, visitedRowInds));
        %rowUpperStr = '';
        %if (~isTopVisited)
            rowUpperStr = genLogic(KMapIn, matchValue, rowUpInds, colInds);
        %    if (~isempty(rowUpperStr))
        %        visitedRowInds = cat(1, visitedRowInds, rowUpInds');
        %    end
        %end

        rowLowInds = rowShiftInds(rowDiv+1:end);
        %isBotVisited = all(ismember(rowLowInds, visitedRowInds));
        %rowLowerStr = '';
        %if (~isBotVisited)
            rowLowerStr = genLogic(KMapIn, matchValue, rowLowInds, colInds);
        %    if (~isempty(rowLowerStr))
        %        visitedRowInds = cat(1, visitedRowInds, rowLowInds');
        %    end
        %end

        if (~isempty(rowUpperStr))
            if (length(rowUpperStr) < minLen)
                rowCellStrs = {};
                rowCellStrs(end+1) = {rowUpperStr};
                %tempStr = rowUpperStr;
                minLen = length(rowUpperStr);
            elseif (length(rowUpperStr) == minLen)
                rowCellStrs(end+1) = {rowUpperStr};
                %tempStr = strjoin(unique({tempStr, rowUpperStr}), op)
                %tempStr = regexprep(tempStr, regStr, '');   
            end
        end
        
        if (~isempty(rowLowerStr))
            if (length(rowLowerStr) < minLen)
                rowCellStrs = {};
                rowCellStrs(end+1) = {rowLowerStr};
                %tempStr = rowLowerStr;
                minLen = length(rowLowerStr);
            elseif (length(rowLowerStr) == minLen)
                rowCellStrs(end+1) = {rowLowerStr};
                %tempStr = strjoin(unique({tempStr, rowLowerStr}), op)
                %tempStr = regexprep(tempStr, regStr, '');                   
            end
        end
        
    end
    
    rowCellStrs = unique(rowCellStrs);
    tempStr = strjoin(rowCellStrs, op);
    tempStr = regexprep(tempStr, regStr, '');
    rowStr = tempStr;

end

%% Combine logic strings from row and columns
%
rowStr = char(rowStr);
colStr = char(colStr);

logicStr = strjoin({rowStr, colStr}, op);
logicStr = regexprep(logicStr, regStr, '');

logicStr = char(logicStr);

end

