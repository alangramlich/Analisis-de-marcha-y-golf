function [Fpx, Fpy, Fpz] = calculofuerzas (masadelsegmento, aceleracionCentrodeMasa, Fdx, Fdy,Fdz)
% [Fpx, Fpy, Fpz] = calculofuerzas (masadelsegmento, aceleracionCentrodeMasa, Fdx, Fdy,Fdz)
% Esta funci�n estima las fuerzas proximales a partir de los datos de masa
% del segmento, aceleraci�n del centro de masa en sus tres componentes y
% Fuerzas distales.

% Entradas de la funci�n:
%     Masa del segmento= valor num�rico, en kg.
%     aceleraci�nCentrodeMasaS = matriz nro_de_muestrasx3, en m/seg2;
%     Fdx, Fdy y Fdz= vectores nx1, de las fuerzas distales de reacci�n en la direcci�n x,y,z , en Newtons;

% Salidas de la funci�n
%      Fpx, Fpy y Fpz= vectores nx1, de las fuerzas proximales de acci�n, en Newtons

% Ejemplo de llamado
% [Fxrod, Fyrod, Fzrod] = calculofuerzas (MasaPierna, aCMpierna, -Fxtob, -Fytob,-Fztob);


Fpx = masadelsegmento.*aceleracionCentrodeMasa (:,1) - Fdx;

Fpy = masadelsegmento.*aceleracionCentrodeMasa (:,2) - Fdy;

Fpz = masadelsegmento.*(aceleracionCentrodeMasa (:,3) + 9.81) - Fdz;
