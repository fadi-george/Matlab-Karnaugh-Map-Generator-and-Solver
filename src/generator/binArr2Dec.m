function decOut = binArr2Dec(binArrIn)
%% Converts a binary matrix to a number
decOut = num2str(binArrIn);
decOut(isspace(decOut)) = '';
decOut = reshape(decOut,size(binArrIn));
decOut = bin2dec(decOut);
end

