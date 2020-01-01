function [M D]=ajuste(Xk,Yk,Ek,Nk) 
% Entrada:
%   Xk: vector N x 1 con las X's de los pixeles de los N ptos de control
%   Yk: vector N x 1 con las Y's de los píxeles de los N ptos de control
%   Ek, vector N x 1 con las coordenadas E's de los N ptos de control 
%   Nk, vector N x 1 con las coordenadas N's de los N ptos de control
%
% Salida: parámetros de la transformación de píxeles --> coordenadas
%   M : matriz 2 x 2 
%   D : vector 2 x 1  
 
D = [0 0]';
M = [1 0; 0 1];  % Ajuste por defecto (no transforma nada)
 
N = 8; % Numero de puntos de control
  
if (N<3), return; 
end
 
 
H=[Xk,Yk,Xk.^0]
 
coefs = H \Ek,
 
res_E = Ek - H*coefs
 
coefsN = H \Nk,
 
res_N = Nk - H*coefsN

 M = [coefs(1) coefs(2); coefsN(1) coefsN(2)],
 D = [coefs(3) coefsN(3)]',
return 

