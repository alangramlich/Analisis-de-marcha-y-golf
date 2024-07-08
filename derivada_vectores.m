% d1Vectores=derivada_vectores(Vectores, dt)
% 
% FUNCIÓN:
%   deriva la filas o las columnas de una matriz por el método de euler,
%   derivr filas o columnas en funcion de la cantidad de filas o
%   columnas. Siempre deriva respecto a la dimensión mas larga.
% EXPLICACION DEL METODO:
%   la funcion duplica la matriz que ingresa defasandola dos muestras y resta
%   elemento a elemento las dos matrices. De esta forma obtengo en una sola
%   resta la diferencia de p(n+1)-p(n-1) para todos los frames.
%   luego divide cada elemento por 2 veces el tiempo de muestreo y descarta
%   los valores de excedente que se genreraro en los extremos al realizar
%   el defasaje entre matrices.
% ENTRADA
%   Vectores: es una matriz de tamaño [m×n] o [n×m] donde m es tipicamente 1 
%   o 3 y n representa la cantidad de frames.
%   dt: es un elemento numerico de tamaño [1×1] que representa el tiempo
%   trancurrido entre frame y frame (período de muestreo). Es inverso a la
%   frecuencia de muestreo.
% SALIDA
%   d1Vectores: es una matriz del mismo tamaño que la matriz "Vectores" cuyos
%   elementos corresponden al valor de la derivada discreta respecto al
%   tiempo de la matriz de entrada. Los valores correspondientes al frame 
%   inicial (frame nro 1) y final (frame==length(Vectores)) de esta matriz 
%   no son datos validos.
% EJEMPLO
%   velocidadDelPie=derivada_vectores(centroDeMasaPie, 1/frecuenciaDeMuestreo)
% 
% Autor: Marcos Dominguez.
% Abril 2019
function d1Vectores=derivada_vectores(Vectores, dt)
    
    if (length(Vectores(:,1))>length(Vectores(1,:))) % ¿dimension 1 mayor a dimensión 2? muchas filas (una por frame) y 3 columnas generalmente
        Vectores1=[Vectores; Vectores(length(Vectores),:) ; Vectores(length(Vectores),:)]; %defino nueva matriz con dos filas mas al final que la matriz original y con el mismo contenido de la ultima fila de la matriz original
        Vectores2=[ Vectores(1,:) ; Vectores(1,:); Vectores]; %defino nueva matriz con dos filas mas al principio que la matriz original y con el mismo contenido de la primera fila de la matriz original
        Vectores=(Vectores1-Vectores2)/(2*dt);% resta de matrices y dividir cada elemento por 2 veces el tiempo de muestreo.
        d1Vectores=Vectores(2:length(Vectores)-1,:); %descartar los valores de excedente que se genreraron en los extremos al realizar el defasaje entre matrices.
    else %condición de dimension 2 mayor a dimensión 1 - muchas columnas(una por frame) y 3 filas generalmente
        Vectores1=[Vectores ,Vectores(length(Vectores),1) , Vectores(length(Vectores),1)]; %defino nueva matriz con dos columnas mas al final que la matriz original y con el mismo contenido de la ultima columna de la matriz original
        Vectores2=[Vectores(:,1),Vectores(:,1), Vectores]; %defino nueva matriz con dos columnas mas al principio que la matriz original y con el mismo contenido de la primera columna de la matriz original
        Vectores=(Vectores1-Vectores2)/(2*dt); % resta de matrices y dividir cada elemento por 2 veces el tiempo de muestreo.
       d1Vectores=Vectores(:,2:length(Vectores)-1); %descartar los valores de excedente que se genreraron en los extremos al realizar el defasaje entre matrices.
    end
end