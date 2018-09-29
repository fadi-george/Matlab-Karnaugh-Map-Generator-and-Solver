function boolOut = isPowOftwo(numIn)
%% Determines if a number is a power of two
if (numIn == 0)
    error('0 is not a valid input.');
end

nextValue = numIn;
count = 0;

while (nextValue ~= 1)
    count = count + 1;
    nextValue = bitshift(nextValue,-1);
end

boolOut = false;
if (2^count == numIn)
    boolOut = true;
end

end

