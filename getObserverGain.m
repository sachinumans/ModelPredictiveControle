function [L] = getObserverGain(sys, dsys, dim)
% Get the observer gain for the passed system and disturbance dynamics

L = place([sys.A, dsys.B; zeros(dim.nd, dim.nx), dsys.A]', [sys.C, dsys.C]', ...
    [0.1, 0.12, 0.14, 0.16, 0.11]);
L = L';
end