function numOut = graycode(numIn)
%% Transforms a number into its numeric equivalent
% numIn is a number to be transformed
% e.g. graycode(6) = 5
    numOut = bitxor(numIn, bitshift(numIn,-1));  
end