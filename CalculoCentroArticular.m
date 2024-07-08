function centro = CalculoCentroArticular(Registro, a, c1, c2, c3, nombre)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

u = strcat('u', nombre)
v = strcat('v', nombre)
w = strcat('w', nombre)
centro = a + (c1*Registro.SCL.(sprintf('%s',u)) + c2*Registro.SCL.(sprintf('%s',v)) + c3*Registro.SCL.(sprintf('%s',w)))

end

