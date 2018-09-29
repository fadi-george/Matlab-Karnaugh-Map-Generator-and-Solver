function [outputArg1,outputArg2] = solver(KMap, varargin)
%% Solve a given KMap (made from the generator) for some logic (minterm or maxterm)

numvarargs = length(varargin);

optargs = {'minterm'};
[optargs{1: numvarargs}] = varargin {:};
[logicType] = optargs{:};


%% TODO: Invalid inputs
% Invalid input size

% Invalid values

%% Find biggest group
match = '1';
if (logicType == 'maxterm')
    match = '0';
    strrep(K, 'X', match)
end

[rows cols] = size(KMap);
visitedInds = [];
for rr = 2:rows
    for cc = 2:cols
        start = KMap(rr,cc);
        
        % TODO Check if index is part of already existing group

        nextRowVal = start;
        if (strcmp(start, match))
            rowGroups = {rr, rr};
            visitedInds(end + 1) = sub2ind([rows cols], rr, cc);
            tempRowCount = 1;
            
            % Checking "upwards"
            k = 1;
            while ((strcmp(nextRowVal, match)))
                if (isPowOfTwo(k))
                    visitedInds(end + 1) = sub2ind([rows cols], rr + k - 1, cc);
                    tempRowCount = tempRowCount + 1;
                    rowGroups{1}(end + 1) = rr + k - 1;
                end
                nextRowVal = KMap(rr + k, cc);
                k = k - 1;
                
                if (k == 1)
                    k = rows;
                end
                if (tempRowCount == rows - 1)
                    break;
                end
            end
            
            % Checking rows that match "downwards", wraps around from top
            % side
            if (tempRowCount ~= rows - 1)
                nextRowVal = start;
                k = 1;
                
                while ((strcmp(nextRowVal, match)))
                    if (isPowOfTwo(k))
                        visitedInds(end + 1) = sub2ind([rows cols], rr + k - 1, cc);
                        tempRowCount = tempRowCount + 1;
                        rowGroups{2}(end + 1) = rr + k - 1;
                    end
                    nextRowVal = KMap(rr + k, cc);
                    k = k + 1;

                    if (k == rows + 1)
                        k = 2;
                    end
                    if (tempRowCount == rows - 1)
                        break;
                    end
                end
            end
            
            
            groups = {};
            for ii = 1:2
                rowInds = rowGroups{ii};
                
                
                % Checking columns that match "leftwards", wraps around from
                % right side
                k = 1;
                tempColCount = 1;
                nextCol = K(rowInds,cc);
                
                while (all(strcmp(nextCol, match)))
                    if (isPowOfTwo(k))
                        tempColCount = tempRowCount + 1;
                        rowGroups{2}(end + 1) = rr + k - 1;
                    end
                    nextCol = KMap(rowInds, cc + k);
                    k = k + 1;

                    if (k == 1)
                        k = cols - 1;
                    end
                    if (tempColCount == cols - 1)
                        break;
                    end
                end
                groups{end+1} =
                
                % Checking columns that match "rightwards", wraps around from
                % right side
                k = 1;
                tempColCount = 1;
                nextCol = K(rowInds,cc);
                
                while (all(strcmp(nextCol, match)))
                    if (isPowOfTwo(k))
                        tempColCount = tempRowCount + 1;
                        rowGroups{2}(end + 1) = rr + k - 1;
                    end
                    nextCol = KMap(rowInds, cc + k);
                    k = k + 1;

                    if (k == 1)
                        k = cols - 1;
                    end
                    if (tempColCount == cols - 1)
                        break;
                    end
                end
            end
        end
        
    end
end

end

