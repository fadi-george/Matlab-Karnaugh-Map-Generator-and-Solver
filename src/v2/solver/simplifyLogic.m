function logicStrOut = simplifyLogic(logicStrIn)
%% Simplifies Sum of Products/Product of Sums logic string
formatStr = strrep(logicStrIn,')(',')*(');
logicStrOut = formatStr;
%logicStrOut = str2sym(formatStr);

if (isempty(logicStrOut))
    logicStrOut = "";
end

%% Additional simplification
if (regexp(string(logicStrOut),'\s*\+\s*1'))
    logicStrOut = '1';
end

end

