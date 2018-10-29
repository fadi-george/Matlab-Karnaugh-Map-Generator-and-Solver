function logicStr = genLogic(KMapIn, matchValue)
%% Quine-McCluskey Approach
% https://en.wikipedia.org/wiki/Quine%E2%80%93McCluskey_algorithm
labels = strjoin(strsplit(KMapIn{1,1}, '\'), '');
numVars = length(labels);
[rows, cols] = size(KMapIn);

%% Pre-liminary Solving
% Checking if matrix is all ones or all zeros
allZeros = all(all(strcmp(KMapIn(2:end, 2:end), '0')));
allOnes = all(all(strcmp(KMapIn(2:end, 2:end), '1'))); 

if (allZeros)
    logicStr = '0';
    return;
end
if (allOnes)
    logicStr = '1';
    return;
end

% Buckets for number of ones/zeros
matchBuckets = cell(numVars + 1, 1);
M = containers.Map();

% Find indices of matching term from the Karanugh Map
for rr = 2:rows
    for cc = 2:cols
        if (strcmp(KMapIn(rr,cc), matchValue) || strcmp(KMapIn(rr,cc), 'X'))
            matchStr = strcat(KMapIn{rr,1},KMapIn{1,cc});
            bucketInd = count(matchStr, matchValue) + 1;

            ind = num2str( bin2dec(matchStr) );
            M(ind) = matchStr;
            matchBuckets{bucketInd} = [matchBuckets{bucketInd}, qmElement(ind, matchStr)];
        end
    end
end

% Delete empty rows
matchBuckets(all(cellfun('isempty',matchBuckets),2),:) = [];

%% 1. Finding the prime implicants
ii = 1;
stopStr = repmat('-', 1, numVars);
while (ii < length(matchBuckets))
        
    % Comparing string from one bucket to the next bucket
    startStrs = matchBuckets{ii};
    endStrs = matchBuckets{ii + 1};
    lastInd = length(matchBuckets) + 1;

    for strInd = 1:length(startStrs)
        startStrKey = startStrs(strInd).indStr;
        startStr = M(startStrKey);

        for endInd = 1:length(endStrs)
            endStrKey = endStrs(endInd).indStr;
            endStr = M(endStrKey);
            
            if (strcmp(endStr, stopStr))
                break;
            end

            % Comparing string difference
            diffInds = (startStr - '0') ~= (endStr - '0');
            %disp(startStrKey);disp(endStrKey);
            if (sum(diffInds) == 1)

                combinedInds = sort(str2num([startStrKey, ' ', endStrKey]));
                combinedInds = sprintf('%d,', combinedInds);
                combinedInds = combinedInds(1:end-1);

                %% Skip if not unique combination
                %disp(combinedInds);
                if (~isKey(M, combinedInds))
                    % Add to queue
                    strDiff = startStr;
                    strDiff(diffInds) = '-';
                    M(combinedInds) = strDiff;
                
                    %disp(sprintf('combined: %s', strDiff));
                    if (length(matchBuckets) == lastInd)
                        matchBuckets{lastInd} = [matchBuckets{lastInd}, qmElement(combinedInds, strDiff)];  
                    else
                        matchBuckets(lastInd) = {qmElement(combinedInds, strDiff)};
                    end
                    
                    %disp(matchBuckets{ii}(strInd))
                    matchBuckets{ii}(strInd).checked = 1;
                    matchBuckets{ii + 1}(endInd).checked = 1;
                else
                    %disp(matchBuckets{ii}(strInd))
                    matchBuckets{ii}(strInd).checked = 1;
                    matchBuckets{ii + 1}(endInd).checked = 1;
                    %disp('skipped');
                end
                
            end
            %disp('-----');
        end
    end
        
    ii = ii + 1;
end

% Extracting "unchecked" strings (ones without pairs)
matchBuckets = horzcat(matchBuckets{:});
matchBuckets = findobj(matchBuckets, 'checked', 0);

% TODO: Dont Cares
MinMaxInds = [];
for ii = 1:length(matchBuckets)
    MinMaxInds = unique([MinMaxInds str2num(matchBuckets(ii).indStr)]);
end

%% 2. Prime Implicant Chart
primeArr =  zeros(length(matchBuckets), length(MinMaxInds));
numMarks = 0;
for ii = 1:length(matchBuckets)
    el = matchBuckets(ii);
    % mark placement onto prime implicant array
    [~,~,mi] = intersect(str2num(el.indStr), MinMaxInds);
    
    numMarks = numMarks + length(mi);
    primeArr(ii, mi) = 1;
end

%% 3. Extracting prime implicants
pStrCell = {};
strOp = '+';
if (matchValue == '0')
    strOp = '*';
end

while (numMarks)
    temp = sum(primeArr) == 1;
    
    % If no prime column found, check against rows with biggest count
    if (sum(temp) == 0)
        [~,pRowInd] = max(sum(primeArr,2));
    else
        tempInds = find(temp);
        pColInd = tempInds(1);
        pRowInd = find(primeArr(:,pColInd));
    end
    
    % mark off checked off row/columns
    pColInds = find(primeArr(pRowInd, :));
    pColArr = primeArr(:, pColInds);
    numMarks = numMarks - sum(sum(pColArr));
    primeArr(:, pColInds) = 0;
    
    tempStr = genStr(matchBuckets(pRowInd), labels, matchValue);
    pStrCell(end + 1) = {tempStr};
end

logicStr = strjoin(pStrCell, strOp);
end

