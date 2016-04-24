function res = genLogic( kMat , midOrMax )
% Performs grouping on a karnaugh map/matrix (KMat)
% Generates either minterm or maxterm logic based on midOrMax
% if midOrMax is 1, minterm logic will be calcualted 
% -- otherwise maxterm logic

subMat = kMat(2:end,2:end);
[m , n] = size(subMat);

%% Check Args
if( nargin < 2 )
    midOrMax = 1;
end
    
%% Row and Column Indicides of 1s or 0s
if( midOrMax == 1 )
    [r,c] = ind2sub([m n] , strmatch('1',subMat(:)));
else
    [r,c] = ind2sub([m n] , strmatch('0',subMat(:)));
end

%% Check Special Cases
len = length(r);
if( len == m*n )
    res = '1';
    return;
end
if( len == 0 )
    res = '0';
    return;
end

%% Group 1s or 0s
res = groupOnesOrZeros( kMat , r , c , midOrMax );
end

function logicStr =  groupOnesOrZeros( kMat , rowInds , colInds , isMinTerm )

    %% Convert Cell Matrix to Numeric Matrix
    strVars = kMat{ 1 , 1 };
    strT = kMat(1 , 2:end );
    strL = kMat( 2:end , 1 )';
    % All Dont Cares get replaced by 2s
    kMat = fixDontCares( kMat );
    k = 1;
    
    labels = strsplit(strVars ,'\');
    leftLabels = labels(1);                          % Left Label Variables
    topLabels  = labels(2);                          % Top  Label Variables
    
    [rows , cols] = size( kMat );
    
    logicStr = '';
    if( isMinTerm == 0 )
        logicStr = '( ';
    end
    
    sharedInds = [];
    
    %% Remove Connected Entries
    while( length(rowInds) )
        
        startR = rowInds(1);  startC = colInds(1);
        rowStr = '';          colStr = '';
        
        %% Check Row Wrap
        cnt_1 = 1; cnt_2 = 0;     
        idx = 2;
        rowWrapTopInds = {startR};
        rowWrapBotInds = {};
        
        tempInds = [startR];
        for r = 1:rows
            if( kMat( mod(startR-r+rows-1,rows)+1 , startC ) == isMinTerm || kMat( mod(startR-r+rows-1,rows)+1 , startC ) == 2 )
                cnt_1 = cnt_1 + 1;
                tempInds = [tempInds  mod(startR-r+rows-1,rows)+1];
                if( isPowerOfTwo( cnt_1 ) )
                    rowWrapTopInds{idx} = tempInds;
                    idx = idx + 1;
                end
            else
                break;
            end            
        end
        
        tempInds = [];
        idx = 1;
        for r = 1:rows
            if( kMat( mod(startR+r-2 , rows)+1 , startC ) == isMinTerm || kMat( mod(startR+r-2 , rows)+1 , startC ) == 2 )
                cnt_2 = cnt_2 + 1;
                tempInds = [tempInds  mod(startR+r-2 , rows)+1];
                if( isPowerOfTwo( cnt_2 ) )
                    rowWrapBotInds{idx} = tempInds;
                    idx = idx + 1;
                end
            else
                break;
            end
        end
        
        if( length(rowWrapTopInds) && length(rowWrapBotInds) )
            
            if( length(rowWrapTopInds{end}) == rows )
                rowLogInds = [rowWrapTopInds rowWrapBotInds(2:end-1)];
            else
                rowLogInds = [rowWrapTopInds rowWrapBotInds(2:end)];
            end
            
        elseif( length(rowWrapTopInds) )
            rowLogInds = rowWrapTopInds;
        else
            rowLogInds = rowWrapBotInds;
        end
        
        %% Check Columns for Each Row Indices (Powers of 2)
        numRLogs = length(rowLogInds);
        curBoxArea = 0;
        captureCount = 0;
        
        for rr = 1:numRLogs
            
            rLogLength = length(rowLogInds{rr});            
            colWrapLeftInds = [startC];
            tempInds = [startC];
            cnt_1 = 1;
            for c = 1:cols
                checkCol = kMat( rowLogInds{rr} , mod(startC-c+cols-1,cols)+1 ) == isMinTerm | kMat(rowLogInds{rr} , mod(startC-c+cols-1,cols)+1 ) == 2;
                if( sum(checkCol) >= rLogLength )
                    cnt_1 = cnt_1 + 1;
                    tempInds = [tempInds mod(startC-c+cols-1,cols)+1];
                    if( isPowerOfTwo( cnt_1 ) )
                        colWrapLeftInds = tempInds;
                    end
                else
                    break;
                end
            end

            colWrapRightInds = [];
            tempInds = [];
            cnt_2 = 0;
            for c = 1:cols-c
                checkCol = kMat( rowLogInds{rr} , mod(startC+c-2 , cols)+1 ) == isMinTerm | kMat( rowLogInds{rr} ,mod(startC+c-2 , cols)+1 ) == 2;
                if( sum(checkCol) >= rLogLength )
                    cnt_2 = cnt_2 + 1;
                    tempInds = [tempInds mod(startC+c-2 , cols)+1];
                    if( isPowerOfTwo( cnt_2 ) )
                        colWrapRightInds = tempInds;
                    end
                else
                    break;
                end
            end
            if( isPowerOfTwo(length(colWrapLeftInds) + length(colWrapRightInds) - 1 ) )
                temp = [colWrapLeftInds colWrapRightInds(2:end)];
            else
                if( length(colWrapLeftInds) > length(colWrapRightInds) )
                    temp = colWrapLeftInds;
                else
                    temp = colWrapRightInds;
                end

            end
            if( rLogLength*length(temp) >= curBoxArea )
                sumVal = sum( sum( kMat(rowLogInds{rr} , temp) == isMinTerm ) );
                lengthSharedInds = size(sharedInds,1);
                
                sharedCount = 0;
                for kk = 1:lengthSharedInds
                    if( any( rowLogInds{rr} == sharedInds(kk,1) ) )
                        if( any( temp == sharedInds(kk,2) ) )
                            sharedCount = sharedCount + 1;
                        end
                    end
                end
                
                if( sumVal-sharedCount >= captureCount )
                    captureCount = sumVal;
                    curBoxArea = rLogLength*length(temp);
                    colLogInds = temp;
                    tempRowLogInds = rowLogInds{rr};                
                end
            end
        end
        
        rowLogInds = tempRowLogInds;
        cLogLength = length( colLogInds );
        rLogLength = length( rowLogInds );

        %% Remove Indices from Queue
        kk = 1;
        indsCollect = [];
        while( kk <= length(rowInds) )
            if( any( rowLogInds == rowInds(kk) ) )
                if( any( colLogInds == colInds(kk) ) )
                    indsCollect = [indsCollect kk];
                    sharedInds = [sharedInds ; [rowInds(kk) colInds(kk)]];
                end
            end
            kk = kk + 1;
        end
        rowInds( indsCollect ) = [];
        colInds( indsCollect ) = [];

        if( cLogLength ~= cols )  
            colStr = matchAndGenStr( strT( colLogInds ) , topLabels{1} , isMinTerm );
        end
        if( rLogLength ~= rows )  
            rowStr = matchAndGenStr( strL( rowLogInds ) , leftLabels{1} , isMinTerm );
        end
        
        %% Append MinTerm or MaxTerm
        if( isMinTerm )
            tempStr = horzcat( rowStr , colStr );
        else
            if( colStr )
                if( rowStr )
                    tempStr = horzcat( rowStr , ' + ' );
                    tempStr = horzcat( tempStr , colStr ); 
                else
                    tempStr = colStr;
                end
            else
                tempStr = rowStr;
            end
        end
        if( length(strfind( logicStr , tempStr )) == 0 )
            logicStr = horzcat(logicStr , tempStr );
             
            if( isMinTerm )
                logicStr = horzcat( logicStr , ' + ' );
            else
                logicStr = horzcat( logicStr , ' )( ' );
            end
        end
        

        k = k + 1;
    end
    
    %% Remove Trailing Characters
    if( isMinTerm )
        logicStr = logicStr(1:end-3);
    else
        logicStr = logicStr(1:end-2);
    end
end

%% Convert Dont Cares in Karnaugh Map to 2's
function newKmat = fixDontCares( kMat )
    [n , m] = size( kMat );
    n = n - 1;
    m = m - 1;
    
    newKmat = zeros( n , m );
    for r = 1:n
       for c = 1:m
          if( kMat{ r + 1 , c + 1 } == 'X' )
              newKmat( r , c ) = 2;
          else
              newKmat( r , c ) = kMat{ r + 1 , c + 1 } - 48;  % Char to Num[1 1
          end
       end
    end
end

%% Take Column or Row Labels, Match Bits, and Generate String
function logicStr = matchAndGenStr( labels , strLabel , isMinTerm )

    temp = cell2mat( labels(:) );
    [ n , m ] = size( temp );
    bitMatches = ones(1, m);
    
    matchMat = ones(n,1)*labels{1};
    logMatch = temp == matchMat;
    logicStr = '';
    
    for k = 1:n
        bitMatches = logMatch( k , : )&bitMatches;
    end
    
    temp = labels{1};
    for j = 1:m
        if( bitMatches(j) )
            
            ch = temp(j);
            logicStr = horzcat(logicStr , strLabel(j));
            if( isMinTerm )
                if( ch == '0' )
                    logicStr = horzcat(logicStr,'''');
                end
            else
                if( ch == '1' )
                    logicStr = horzcat(logicStr,'''');
                end 
                logicStr = horzcat(logicStr,' + ');

            end
            
        end
    end
    if( isMinTerm == 0 )
        logicStr = logicStr(1:end-3);
    end
end

