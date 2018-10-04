function logicStr = solver(KMapIn, varargin)
%% Solve a given KMap (made from the generator) for some logic (minterm or maxterm)
% Minterm expressions are Sums of Products
% Maxterm expressions are Products of Sums
numvarargs = length(varargin);

optargs = {'minterm'};
[optargs{1: numvarargs}] = varargin {:};
[logicType] = optargs{:};


%% Validate Inputs
%%
% Invalid input size
[rows cols] = size(KMapIn);
if (~isPowOfTwo(rows-1) | ~isPowOfTwo(cols-1))
    error('SOLVER:InvalidSize', 'KMap input must have labels in the top-left corner, gray codes to the right of the label, graycodes to the left of the label, and 0''''s or 1''''s for the rest of matrix.');
end

% Invalid labels
if (isempty(regexp(KMapIn{1,1},'\\')))
    error('SOLVER:InvalidLabels', 'KMap input must have a label that is seperated by a "\" character.');    
end

%% Adjust Karnaugh Map
%%
match = '1';
if (logicType == 'maxterm')
    match = '0';
end
KMap = strrep(KMapIn, 'X', match);

[rows, cols] = size(KMap);
logicStr = genLogic(KMap, match, [2:rows], [2:cols]);
logicStr = simplifyLogic(logicStr);

end

