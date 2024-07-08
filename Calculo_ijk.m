function Registro = Calculo_ijk(Registro, marcador1, marcador2, segmento1, dif1, dif2, segmento2, segmento3,cond)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

Numerador = (marcador1 - marcador2)
Denominador = sqrt(sum((Numerador.^2),2))
C1 = cross(dif1,dif2)
norm1 = sqrt(sum((C1.^2),2))


Registro.SCG.(sprintf('%s',segmento1)) = Numerador./[Denominador,Denominador,Denominador]
Registro.SCG.(sprintf('%s',segmento2)) = C1./[norm1,norm1,norm1]

if cond == 1
    C2 = cross(Registro.SCG.(sprintf('%s',segmento1)),Registro.SCG.(sprintf('%s',segmento2)))
else
    C2 = cross(Registro.SCG.(sprintf('%s',segmento2)),Registro.SCG.(sprintf('%s',segmento1)))
end
norm2 = sqrt(sum((C2.^2),2))
Registro.SCG.(sprintf('%s',segmento3)) = C2./[norm2,norm2,norm2]

end
