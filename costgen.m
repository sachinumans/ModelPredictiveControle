function [H,h,const]=costgen(T,S,param,dim,x0)

Qbar=blkdiag(kron(eye(dim.N),param.Q),param.P); 

H=S'*Qbar*S+kron(eye(dim.N),param.R);   
h=S'*Qbar*T*x0;
const=x0'*T'*Qbar*T*x0;

end