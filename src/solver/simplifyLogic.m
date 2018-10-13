function logicStrOut = simplifyLogic(logicStrIn)
%% Simplifies Sum of Products/Product of Sums logic string
logicStrOut = strrep(logicStrIn,')(',')*(');
logicStrOut = regexprep(logicStrOut, '\+0|\s', '');
%logicStrOut = str2sym(formatStr);

if (isempty(logicStrOut))
    logicStrOut = "";
end

%% Additional simplification
if (regexp(string(logicStrOut),'\s*\+\s*1'))
    logicStrOut = '1';
end

end

