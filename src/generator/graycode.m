function numOut = graycode(numIn, varargin)
%% Transforms a number into its numeric equivalent
% numIn is a number to be transformed
% bitWidth masks number output to some specified length
% e.g. graycode(6) = 5
p = inputParser;
addRequired(p, 'numIn');
addOptional(p, 'bitWidth', 0);
parse(p, numIn, varargin{:});

numOut = bitxor(numIn, bitshift(numIn,-1));
if (p.Results.bitWidth)
    numOut = bitand(numOut, 2^p.Results.bitWidth - 1);
end

end