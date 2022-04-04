function [L] = getObserverGain(sys, dsys, dim)
% L = place(sys.A', sys.C', [0.8, 0.85, 0.86, 0.9]);
% L = L';
% 
% Ld = place(dsys.A', dsys.C', [0.1+0.1*1j, 0.1-0.1*1j]);
% Ld = Ld';

L = place([sys.A, dsys.B; zeros(dim.nd, dim.nx), dsys.A]', [sys.C, dsys.C]', ...
    [0.1, 0.12, 0.14, 0.16, 0.11]);
L = L';
end