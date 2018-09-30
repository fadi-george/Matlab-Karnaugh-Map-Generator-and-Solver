function logicStr = solver(KMapIn, varargin)
%% Solve a given KMap (made from the generator) for some logic (minterm or maxterm)
% Minterm expressions are Sums of Products
% Maxterm expressions are Products of Sums
numvarargs = length(varargin);

optargs = {'minterm'};
[optargs{1: numvarargs}] = varargin {:};
[logicType] = optargs{:};


%% TODO: Invalid inputs
%%
% Invalid input size

% Invalid values

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

