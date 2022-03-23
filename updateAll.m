function [] = updateAll(YN)
if YN == "Y" | YN == 1
    Parameter()
    SystemDiscretisation()
    CostMatrices()
    getLin_cstr_mat()
end

