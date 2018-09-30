function logicStr = genLogic(KMapIn, matchValue)
%%

isMinTerm = strcmp(matchValue,'1');
fullMatch = all(all(strcmp(KMapIn(2:end,2:end), matchValue)));
[rows cols] = size(KMapIn);

labels = strsplit('AB\CD','\');
rowLabelLen = length(labels{1});
colLabelLen = length(labels{2});

%% All values matched the search term
%%
rowStr = '';
colStr = '';

if (fullMatch)
    % 1s or 0s in every row
    if (rows - 1 == 2^rowLabelLen)
        if (isMinTerm)
            rowStr = '(1)';
        end
        
    % Must check which portions of the gray code stays the same
    else
        binMat = cell2mat( cellfun(@(str) str - '0', KMapIn(2:end,1),'un',0) );
        
        % In case of a single row, difference in the graycodes will be 0 
        [bRows, ~] = size(binMat);
        if (bRows == 1)
            binMat = [binMat; binMat];
        end
        
        % Extract label letters that match with graycode positions that
        % don't chat
        matchBin = logical(~diff(binMat));
        rowStr = labels{1}(matchBin);
        
        % Add negation label
        if (isMinTerm)
            bars = repmat('''',rows - 1);
            bars = pad(bars(matchBin),length(rowStr));
            
            rowStr = string(vertcat(rowStr, bars)');
            rowStr = strcat('(', rowStr, ')');
        else
            
        end
        
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
    if (rows > 2)
        rowDiv = (rows - 1)/2;

        % Rows may wrap, so we cycle the inner matrix downwards to mimic this
        for ii = 1:rowDiv
            KInner = circshift(KMapIn(2:end,1:end),ii - 1);
            rowUpperStr = genLogic([KMapIn(1, 1:end) ; KInner(1:1+rowDiv-1,:)], matchValue)
            rowLowerStr = genLogic([KMapIn(1, 1:end) ; KInner(1+rowDiv:end,:)], matchValue)
            
            if (isMinTerm)
                rowStr = strcat(rowUpperStr, '+', rowLowerStr);
            else
                rowStr = strcat(rowUpperStr, '*', rowLowerStr);
            end
            
            rowStr = char(rowStr);
            if (rowStr(end) == '+' || rowStr(end) == '*')
                rowStr = rowStr(1:end-1);
            end
        end
    end
    
    if (cols > 2)
        colDiv = (cols - 1)/2;
        
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
if (isMinTerm)
    logicStr = strcat(rowStr, '+', colStr);
else
    logicStr = strcat(rowStr, '*', colStr);
end

logicStr = char(logicStr);
if (logicStr(end) == '+' || logicStr(end) == '*')
    logicStr = logicStr(1:end-1);
end

end

