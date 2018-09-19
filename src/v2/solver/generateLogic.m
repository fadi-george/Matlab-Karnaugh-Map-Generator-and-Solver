function kMatrix = generateLogic( truthTable )
%% Validate truthTable
if (all(truthTable(:) < 2) == 0)
    error('GL:BinaryInput', 'Binary values only. Discard rows with don''t cares.')
end



end

