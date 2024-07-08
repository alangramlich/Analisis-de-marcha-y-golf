function [wx,wy,wz] = velocidadangularsegmento (alfa, deralfa, beta, derbeta, gama,dergama)
% function [wx,wy,wz] = velocidadangularsegmento (alfa, deralfa, beta, derbeta, gama,dergama);
% Esta funci�n calcula las velocidades angulares de los segmentos en
% coordenadas locales, a partir de los �ngulos de Euler alfa, beta, gama y
% sus derivadas expresadas en coordenadas locales.

% Entradas:
% Todas las entradas son vectores de tama�o n x 1, donde n es el n�mero de
% muestras correspondientes a dos ciclos completos de la marcha.
% alfa= angulo alfa del segmento de inter�s
% deralfa = derivada del �ngulo alfa del segmento de inter�s
% beta= angulo beta del segmento de inter�s
% derbeta = derivada del �ngulo beta del segmento de inter�s
% gama= angulo gamma del segmento de inter�s
% dergama = derivada del �ngulo gamma del segmento de inter�s

% Salidas de la funci�n
% Todas las salidas son vectores de tama�o nx1, donde n es el n�mero de
% muestras correspondientes a dos ciclos completos de la marcha.

% wx = velocidad angular del segmento de inter�s en la direcci�n x (es
% decir en la direcci�n i local), wx est� expresado en coordenadas locales

% wy = velocidad angular del segmento de inter�s en la direcci�n y (es
% decir en la direcci�n j local), wy est� expresado en coordenadas locales

% wz = velocidad angular del segmento de inter�s en la direcci�n z (es
% decir en la direcci�n k local), wx est� expresado en coordenadas locales

% Ejemplo de c�mo llamar a la funci�n para el segmento MUSLO DERECHO:
% [wxmusder,wymusder,wzmusder] = velocidadangularsegmento (alfamusder, deralfamusder, betamusder, derbetamusder, gamamusder,dergamamusder)

wx= deralfa.*sin(beta).*sin(gama) + derbeta.*cos(gama);
wy = deralfa.* sin(beta).*cos(gama) - derbeta.*sin(gama);
wz = deralfa.*cos(beta) + dergama;


