function logicStr = genLogic(KMapIn, matchValue, rowInds, colInds)
%%
KMapSelect = KMapIn(rowInds, colInds);
isMinTerm = strcmp(matchValue,'1');

fullMatch = all(all(strcmp(KMapSelect, matchValue)));
%fullMatchZero = all(all(strcmp(KMapSelect, '0')));
%fullMatchOne = all(all(strcmp(KMapSelect, '1')));
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
            
if (fullMatch)
    % 1s or 0s in every row
    if (rows == 2^rowLabelLen && cols == 2^colLabelLen)
        rowStr = strcat('(', matchValue, ')');

        
    % Must check which portions of the gray code stays the same
    else
        binMat = cell2mat( cellfun(@(str) str - '0', KMapIn(rowInds, 1),'un',0) );
        
        % In case of a single row, difference in the graycodes will be 0 
        [bRows, ~] = size(binMat);
        
        labelInds = logical(~diff(binMat));
        barInds = logical(~diff(binMat));
        if (bRows == 1)
            labelInds = true(rowLabelLen,1);
            barInds = logical(binMat);
        end
        
        % Extract label letters that match with graycode positions that
        % don't change
        % In the case of one row/col, we keep all the letters
        rowStr = labels{1}(labelInds);
        
        % In case of one row/col, we only keep "bar" symbols for positions
        % where they are 0 or 1 depending or not if it is a minterm or
        % maxterm expression
        bars = repmat('~', 1, rowLabelLen);
        if (isMinTerm)
            barInds = ~barInds;
            bars = pad(bars(barInds),length(rowStr));
        end
        rowStr = strjoin(strip(cellstr((vertcat(bars, rowStr)'))), groupOp);
        rowStr = strcat('(', rowStr, ')');
        
    end
    
    % 1s or 0s in every col
%     if (cols - 1 == 2^colLabelLen)
%         if (isMinTerm)
%             colStr = '(1)';
%         end
%     end
    
else
    %% Divide areas by 2 but also wrapping around
    %%
    if (rows > 1)
        rowDiv = rows/2;

        % Rows may wrap, so we cycle the inner matrix downwards to mimic this
        for ii = 1:rowDiv
            rowShiftInds = circshift(rowInds, ii - 1);
            rowUpperStr = genLogic(KMapIn, matchValue, rowShiftInds(1:rowDiv), colInds);
            rowLowerStr = genLogic(KMapIn, matchValue, rowShiftInds(rowDiv+1:end), colInds);
            
            rowStr = strjoin({rowStr, rowUpperStr, rowLowerStr}, op);
            rowStr = regexprep(rowStr, regStr, '');
        end
    end
    
    if (cols > 1)
        colDiv = cols/2;
        
        % Columns may wrap, so we cycle the inner matrix to mimic this
        for ii = 1:colDiv
            %KInner = circshift(KMapIn(2:end,1:end), ii - 1, 2);
            %colLeftwardStr = genLogic([KMapIn(1, 1:end) ; KInner(1:1+rowDiv-1,:)], matchValue);
            %colRightwardStr = genLogic([KMapIn(1, 1:end) ; KInner(1+rowDiv:end,:)], matchValue);
            %colStr = strcat(rowUpperStr, '+', rowLowerStr);
        end
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

