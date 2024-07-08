function [alfa, beta, gamma, I] = CalculoAngulos(Registro, kProximal, iDistal,  seg2, seg3, seg4, seg6 )


aI=cross(Registro.SCG.(sprintf('%s',kProximal)),Registro.SCG.(sprintf('%s',iDistal)))
normI=sqrt(sum((aI.^2),2))
I=aI./[normI,normI,normI]

alfa= asind(dot(I,Registro.SCG.(sprintf('%s',seg2)),2))
beta= asind(dot(Registro.SCG.(sprintf('%s',seg3)),Registro.SCG.(sprintf('%s',seg4)),2))  
gamma= asind(dot(I,Registro.SCG.(sprintf('%s',seg6)),2))  

end

