function boolVal = isPowerOfTwo( n )
% Determines if a number is a power of 2

%% GET MSB Bit Position
% Count position of most significant bit of the number
ii = 0;
while( bitshift(n,-ii) )
    ii = ii + 1;
end

%% Bitmask with Power of 2
% Use bit position to generate a power 2
% mask with original number to determine if it is a power of 2
boolVal = bitand( bitshift(1, ii - 1) , n ) == n ;

end

