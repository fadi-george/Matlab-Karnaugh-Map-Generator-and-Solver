function kMatrix = karnaughMap( sizeMat , truthTable , columnChoice , optLabels , optLogic  )
%% Generates a Karnaugh Map matrix from some truthtable and output column.
% sizeMat specifies the number of varaibles to put in that row or column
% truthTable which consists of some inputs and an output matrix
% columnChoice is the column index for the output
% optLabels is to specify what to label the rows or columns
% -- optLabels must be a cell of characters i.e. {'W','X','Z'}
% optLogic helps to generate default, RS flipflop, or any other configuration i.e. { 'RS' , 1 }
% -- which will create seperate matrices for R and S using column 1 as the present state
% -- rightmost columns in truth table should be the next state values with any outputs,
% -- leftmost columns should be the present state values and any inputs

%% Check Option
%%
[n , m] = size(sizeMat);
[r , c] = size(truthTable);
numMats = 1;
fflogic = '';

if( n ~= 1 && m ~= 2 )
    error('Size must be a 1 by 2 array with entries being the number of varaibles for the row or column.');
end
if( columnChoice(1) > c )
    error('Column choice is bigger than the number of rows in the truth table.');    
end
if( nargin >= 4 )
    if( nargin == 5 ) % Generate 2 K-maps for FlipFlops other than D-Q
        if( length(optLogic) ~= 2 || ~iscell(optLogic) )
           error('Option logic must be a 1x2 cell with first entry being the logic to perform and the second entry being the column of the present state bit');
        end
        fflogic = optLogic{1};
        if( strcmp('RS',fflogic) || strcmp('JK',fflogic) )   
            numMats = 2;
        else
            error('No other FlipFlop logic is supported.');
        end
    else
        optLogic = '';
    end
    
    if( length(optLabels) )
        if( ((sizeMat(1) + sizeMat(2)) ~= length(optLabels)) || ~iscell(optLabels) )
            error('Optional labels must be in a cell format and must equal the total number of variables specified by the size matrix.');
        end
    end
else
    optLogic = '';
end


%% Initialize K-matricies
%%
rowBits = sizeMat(1);
rows = 2^rowBits;

colBits = sizeMat(2);
cols = 2^colBits;

if( r > (rows*cols) )
    warning('Number of rows in the truth table is bigger than required as specified by the size matrix.');
end

kMatrix = cell(rows+1,cols+1,numMats);       % create cell array to hold bits
kMatrix(:) = {'X'};                          % initialize to all dont cares
[m , n , ~] = size(kMatrix);
[tableRows , ~] = size(truthTable);
m = m - 1;
n = n - 1;


%% Label Matrix Inputs
%%
str = '';
if( nargin >= 4 && length(optLabels) )
    for ii = 1:rowBits
        str = strcat(str,optLabels{ii});
    end
    str = strcat(str,'\');
    for ii = rowBits+1:rowBits+colBits
        str = strcat(str,optLabels{ii});
    end  
else
    for ii = 1:rowBits
        str = strcat(str,64+ii);
    end
    str = strcat(str,'\');
    for ii = 1:colBits
        str = strcat(str,64+rowBits+ii);
    end    
end


%% Label Columns and Rows
%%
for ii = 1:numMats
    kMatrix(1,1,ii) = {str};
    st = 0;
    dir = 0;
    cap = 4;

    for jj = 1:max(m,n)

        if( jj <= n )                                       % label columns
            kMatrix{1,jj+1,ii} = dec2bin(st,colBits);
        end
        if( jj <= m )                                       % label rows
            kMatrix{jj+1,1,ii} = dec2bin(st,rowBits);   
        end
                  
        if( mod(jj,4) == 0 )
            dir = ~dir;
            cap = cap + 4;
        end
        
        if bitand(jj,1)                              % n is odd
        	st = bitxor( st , 1 );
            
        elseif( isPowerOfTwo(jj) )                   % n is a power of 2         
            st = bitxor( st , jj ); 
        
        elseif( isPowerOfTwo( cap - jj ) )
            st = bitxor( st , cap - jj );             
            
        end

    end 
end

%% Plug Values into KMap
%%
for jj = 1:numMats

    for ii = 1:tableRows
        r = num2str(truthTable(ii,1:rowBits));
        r = r(r ~= ' ');                            % remove spaces

        c = num2str(truthTable(ii,rowBits+1:rowBits+colBits));
        c = c(c ~= ' ');                            % remove spaces        

        output = num2str(truthTable(ii,columnChoice));

        % Get position
        rowPos = strmatch(r , {kMatrix{2:end,1,jj}}) + 1;
        colPos = strmatch(c , {kMatrix{1,2:end,jj}}) + 1;
        
        if( fflogic )
            currentState = num2str(truthTable(ii,optLogic{2}));
        end
        
        if( jj == 1 )                                       
            if( strcmp('RS',fflogic) )                      % Reset
                if( output == '1' )
                    output = '0';
                elseif( currentState == '1' && output == '0' )
                    output = '1';           
                else
                    output = 'X';           
                end
            elseif( strcmp('JK',fflogic) )                  % J
                if( currentState == '0' && output == '0' )
                    output = '0';
                elseif( currentState == '0' && output == '1' )
                    output = '1';           
                else
                    output = 'X';           
                end                
            end
        else                                                
            if( strcmp('RS',fflogic) )                      % Set
                if( output == '0' )
                    output = '0';
                elseif( currentState == '0' && output == '1' )
                    output = '1';           
                else
                    output = 'X';           
                end
            elseif( strcmp('JK',fflogic) )                  % K
                if( currentState == '1' && output == '0' )
                    output = '1';
                elseif( currentState == '1' && output == '1' )
                    output = '0';           
                else
                    output = 'X';           
                end                 
            end
        end
        
        
        
        kMatrix(rowPos,colPos,jj) = {output};
        
        
    end
end


