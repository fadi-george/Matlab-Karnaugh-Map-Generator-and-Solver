function logicStrOut = simplifyLogic(logicStrIn)
%% Simplifies Sum of Products/Product of Sums logic string
formatStr = strrep(logicStrIn,')(',')*(');
logicStrOut = str2sym(strcat('mod(', formatStr, ',2)'));

%% Additional simplification
if (regexp(string(logicStrOut),'\s*+\s*1'))
    logicStrOut = '1';
end

end

