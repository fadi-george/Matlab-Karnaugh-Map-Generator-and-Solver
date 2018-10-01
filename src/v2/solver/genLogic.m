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
    
    rowStr = strip(cellstr((vertcat(bars, rowStr)')));
    rowStr = rowStr(~(strcmp(rowStr, '~') | strcmp(rowStr, '')));
    rowStr = strjoin(rowStr, groupOp);
    rowStr = strcat('(', rowStr, ')');
    
else
    %% Divide areas by 2 but also wrapping around
    %%
    rowDiv = 0;
    colDiv = 0;
    rowOffset = 0;
    colOffset = 0;
    
    % Recusrive sub-dvisions of the original array
    if (rows > 1)
        rowDiv = rows/2;
    end
    if (cols > 1)
        colDiv = cols/2;
    end
    
    % Optimize for wraps
%     minRowInd = min(rowInds);
%     maxRowInd = max(rowInds);
%     minColInd = min(colInds);
%     maxColInd = max(colInds);
%    
%     if (rows > 1)
%         if (minRowInd == 2 && maxRowInd == rows + 1)
%             if (KMapIn{minRowInd,minColInd} == matchValue && KMapIn{maxRowInd,minColInd} == matchValue)
%                 rowUpCount = 1;
%                 rowDownCount = 1;
% 
%                 k = 1;
%                 while (KMapIn{minRowInd + k,minColInd} == matchValue)
%                     k = k + 1;
%                     rowDownCount = rowDownCount + 1;
%                     if (rowDownCount == rowDiv)
%                         break;
%                     end
%                 end
%                 
%                 k = 1;
%                 while (KMapIn{maxRowInd - k,minColInd} == matchValue)
%                     k = k + 1;
%                     rowUpCount = rowUpCount + 1;
%                     if (rowUpCount == rowDiv)
%                         break;
%                     end
%                 end
%                 
%                 rowOffset = min(rowUpCount, rowDownCount);
%                 if (rowUpCount < rowDownCount)
%                     rowOffset = -rowOffset;
%                 end
%             end 
%         end
%     end
%     if (cols > 1)
%         if (minColInd == 2 && maxColInd == cols + 1)
%             if (KMapIn{minRowInd,minColInd} == matchValue && KMapIn{minRowInd,maxColInd} == matchValue)
%                 colRightCount = 1;
%                 colLeftCount = 1;
% 
%                 k = 1;
%                 while (KMapIn{minRowInd, minColInd + k} == matchValue)
%                     k = k + 1;
%                     colRightCount = colRightCount + 1;
%                     if (colRightCount == colDiv)
%                         break;
%                     end
%                 end
%                 
%                 k = 1;
%                 while (KMapIn{maxRowInd, maxColInd - k} == matchValue)
%                     k = k + 1;
%                     colLeftCount = colLeftCount + 1;
%                     if (colLeftCount == colDiv)
%                         break;
%                     end
%                 end
%                 
%                 colOffset = min(colRightCount, colLeftCount);
%                 if (colRightCount < colLeftCount)
%                     colOffset = -colOffset;
%                 end
%             end 
%         end
%     end

    visitedRowInds = [];
    % Rows may wrap, so we cycle the inner matrix downwards to mimic this
    for ii = 1:rowDiv
        rowShiftInds = circshift(rowInds, ii - 1 + rowOffset);
        %colShiftInds

        rowUpInds = rowShiftInds(1:rowDiv);
        isTopVisited = all(ismember(rowUpInds, visitedRowInds));
        rowUpperStr = '';

        if (~isTopVisited)
            rowUpperStr = genLogic(KMapIn, matchValue, rowUpInds, colInds);
            visitedRowInds = cat(1, visitedRowInds, rowUpInds);
        end

        rowLowInds = rowShiftInds(rowDiv+1:end);
        isBotVisited = all(ismember(rowLowInds, visitedRowInds));
        rowLowerStr = '';

        if (~isBotVisited)
            rowLowerStr = genLogic(KMapIn, matchValue, rowLowInds, colInds);
            visitedRowInds = cat(1, visitedRowInds, rowLowInds);
        end

        rowStr = strjoin({rowStr, rowUpperStr, rowLowerStr}, op);
        rowStr = regexprep(rowStr, regStr, '');
    end

end

%% Combine logic strings from row and columns
%
rowStr = char(rowStr);
colStr = char(colStr);

logicStr = strjoin({rowStr, colStr}, op);
logicStr = regexprep(logicStr, regStr, '');

logicStr = char(logicStr);

end

