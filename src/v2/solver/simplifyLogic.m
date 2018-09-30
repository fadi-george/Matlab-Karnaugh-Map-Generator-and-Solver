function logicStrOut = simplifyLogic(logicStrIn)

%% Simplifies Sum of Products/Product of Sums logic string
formatStr = strrep(logicStrIn,')(',')*(');
logicStrOut = str2sym(formatStr);

%% Additional simplification
if (regexp(string(logicStrOut),'\s*\+\s*1'))
    logicStrOut = '1';
end

end

