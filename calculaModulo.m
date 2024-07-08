% La funcion calcula el modulo de filas o columnas de una matriz que tenga 
% alguna de sus dimenciones de tamaño igual a 3. Verifica si la fila o la
% columna tiene tres componentes y a esa dimensión le calcula el módulo
% ENTRADA
%  matriz: es una matriz de n×3 o 3×n cuyos elementos son numericos.
% SALIDA
%  MODULO: es un vector de n×1 o 1×n (segun las dimensiones de la entrada).
%  Cada elemento del vector se corresponde a la norma 2 de los 3 elementos
%  de la fila o columna a evaluar.
%  Si la matriz de entrada no posee las dimensiones adecuadas (una dimension
%  igual a 3) la salida es igual a 0.
% EJEMPLO
% calcular rapidez del muslo a partir del vector velocidad lineal del muslo
% para todos los frames:
% rapidezMuslo= calculaModulo(velocidadCentroDeMasaMuslo)
% rapidezMuslo es un vector de [1×n] si velocidadCentroDeMasaMuslo es de
% tamaño [3×n]. Si velocidadCentroDeMasaMuslo es de tamaño [n×3]
% rapidezMuslo tendrá tamaño [n×1].
%
% Autor: Marcos Dominguez
% Noviembre 2020
function MODULO = calculaModulo(matriz)
if length(matriz(1,:))==3
MODULO = sqrt(sum(abs(matriz).^2,2));
else
    if length(matriz(:,1))==3
    MODULO = sqrt(sum((matriz).^2,1));
    else
    MODULO=0;
    end
end
