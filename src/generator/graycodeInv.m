function numOut = graycodeInv(numIn, varargin)
%% Transforms a graycode number/array into its original numeric value/array
if (length(numIn) > 1)
    numOut = arrayfun(@(x) graycodeInv(x), numIn);
else
    numOut = 0;
    ii = numIn;
    while(ii)
        numOut = bitxor(numOut, ii);
        ii = bitshift(ii,-1);
    end
end

end

