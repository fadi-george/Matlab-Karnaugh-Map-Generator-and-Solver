function [outputArg1,outputArg2] = solver(kMap, varargin)
%% Solve a given KMap (made from the generator) for some logic (minterm or maxterm)

match = '1';
numvarargs = length(varargin);
optargs(1:numvarargs) = varargin;

optargs

%% TODO: Invalid inputs
% Invalid input size

% Invalid values

%% Find biggest group
if (logicType == 'maxterm')
    match = '0';
end

[rows cols] = size(kMap);
table = kMap(2:rs,2:cs);

for rr = 2:rows
    for cc = 2:cols
        start = table(rr,cc)
    end
end

end

