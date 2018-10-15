function logicStr = genLogic2(KMapIn, matchValue)
%% Quine-McCluskey Approach
numVars = length(KMapIn{1,1});
labels = strsplit(KMapIn{1,1}, '\');
[rows, cols] = size(KMapIn);

% Buckets for number of ones/zeros
matchBuckets = cell(numVars, 1);
M = containers.Map();

% Find indices of matching term from the Karanugh Map
for rr = 2:rows
    for cc = 2:cols
        if (strcmp(KMapIn(rr,cc), matchValue) || strcmp(KMapIn(rr,cc), 'X'))
            matchStr = strcat(KMapIn{rr,1},KMapIn{1,cc});
            bucketInd = count(matchStr, matchValue) + 1;

            ind = num2str( bin2dec(matchStr) );
            M(ind) = matchStr;
            matchBuckets{bucketInd} = [matchBuckets{bucketInd}, qmElement(ind)];
        end
    end
end

%% Find groupings
ii = 1;
while (ii < length(matchBuckets))
        
    % Comparing string from one bucket to the next bucket
    startStrs = matchBuckets{ii};
    endStrs = matchBuckets{ii + 1};
    lastInd = length(matchBuckets) + 1;
    moreGroups = 0;    

    for strInd = 1:length(startStrs)
        startStrKey = startStrs(strInd).str;
        startStr = M(startStrKey);

        for endInd = 1:length(endStrs)
            endStrKey = endStrs(endInd).str;
            endStr = M(endStrKey);

            % Comparing string difference
            diffInds = (startStr - '0') ~= (endStr - '0');
            if (sum(diffInds) == 1)

                combinedInds = sort(str2num([startStrKey, ' ', endStrKey]));
                combinedInds = sprintf('%d,', combinedInds);
                combinedInds = combinedInds(1:end-1);

                %% Skip if not unique combination
                if (~isKey(M, combinedInds))
                    % Add to queue
                    moreGroups = 1;
                    strDiff = startStr;
                    strDiff(diffInds) = '-';
                    M(combinedInds) = strDiff;

                    if (length(matchBuckets) == lastInd)
                        matchBuckets{lastInd} = [matchBuckets{lastInd}, qmElement(combinedInds)];  
                    else
                        matchBuckets(lastInd) = {qmElement(combinedInds)};
                    end
                    
                    matchBuckets{ii}(strInd).checked = 1;
                    matchBuckets{ii + 1}(endInd).checked = 1;
                else
                    matchBuckets{ii}(strInd).checked = 1;
                    matchBuckets{ii + 1}(endInd).checked = 1;
                end
                
                
            end
        end
    end
        
    if (~moreGroups)
        ii = ii + 1;
    end
end

% Extracting "unchecked" strings (ones without pairs)
matchBuckets = horzcat(matchBuckets{:});
matchBuckets = findobj(matchBuckets, 'checked', 0);

%% Prime Implicants



end

