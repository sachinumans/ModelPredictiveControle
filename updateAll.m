function [] = updateAll(YN)
%%%%%%%%%%%%%%%%%%%
% Update all .mat files
%%%%%%%%%%%%%%%%%%%
if YN == "Y" | YN == 1
    Parameter()
    SystemDiscretisation()
    CostMatrices()
    getLin_cstr_mat()
end

