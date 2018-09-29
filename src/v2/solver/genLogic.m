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
rowStr = '(0)';
colStr = '(0)';

if (fullMatch)
    % 1s or 0s in every row
    if (rows - 1 == 2^rowLabelLen)
        if (isMinTerm)
            rowStr = '(1)';
        end
    end
    
    % 1s or 0s in every col
    if (cols - 1 == 2^colLabelLen)
        if (isMinTerm)
            colStr = '(1)';
        end
    end
    
    
    
else
    %% Divide areas by 2 but also wrapping around
    %%
    if (rows > 2)
        rowDiv = (rows - 1)/2;

        %% Rows may wrap, so we cycle the inner matrix to mimic this
        for ii = 1:rowDiv
            KInner = circshift(KMapIn(2:end,1:end),ii - 1);
            rowUpperStr = genLogic([KMapIn(1, 1:end) ; KInner(1:1+rowDiv-1,:)], matchValue);
            rowLowerStr = genLogic([KMapIn(1, 1:end) ; KInner(1+rowDiv:end,:)], matchValue);
            rowStr = strcat(rowUpperStr, '+', rowLowerStr);
        end
    end
    if (cols > 2)
        colDiv = (cols - 1)/2;
    end

end


%% Combine logic strings from row and columns
%
if (isMinTerm)
    logicStr = strcat(rowStr, '+', colStr);
else
    logicStr = strcat(rowStr, '*', colStr);
end

end

