function [L, Ld] = getObserverGain(sys, dsys)
L = place(sys.A', sys.C', [0.6+0.4*1j, 0.6-0.4*1j, 0.8+0.2*1j, 0.8-0.2*1j]);
L = L';

Ld = place(dsys.A', dsys.C', [0.3+0.2*1j, 0.3-0.2*1j, 0.5]);
Ld = Ld';
end