function [alfasen, betasen, gamasen,alfacos,betacos, gamacos]=anguloeuler(i,j,k,segmento, graficar)
% Esta funci�n calcula los �ngulos de Euler, a trav�s de sus dos formas:
% con la f�rmula de arco-seno y con la f�rmula del arco-coseno para un dado
% segmento.
% Para llamar la funci�n:

% [alfasen,alfacos,betasen,betacos,gamasen,gamacos]=anguloeuler(i,j,k)
% Entradas:
% i, j y k cada uno es la matrices de tama�o [numero de muestras x 3] del
% sistema anclado en el segmento de inter�s.
% Resultados:
% alfasen = el �ngulo alfa (tambi�n llamado fi) del segmento, calculado por
% el arco-seno.
% alfacos = el �ngulo alfa (tambi�n llamado fi) del segmento, calculado por
% el arco-coseno.
% betasen = el �ngulo beta (tambi�n llamado tita) del segmento, calculado por
% el arco-seno.
% betacos = el �ngulo beta (tambi�n llamado tita) del segmento, calculado por
% el arco-coseno.
% gamasen = el �ngulo gamma (tambi�n llamado psi) del segmento, calculado por
% el arco-seno.
% gamacos = el �ngulo gamma (tambi�n llamado psi) del segmento, calculado por
% el arco-coseno.

% Definimos I, J y K
% I, J y K son los versores del sistema coordenado global.
% Recuerden que para cada muestra, el valor del versor es id�ntico, por lo
% tanto generamos matrices, que en cada fila tengan el valor [1 0 0], por
% ejemplo.
% Paola Catalfamo 15-09-2020

I = zeros(size (i)); % I es la matriz [1 0 0]
I(:,1) = 1;

J = zeros(size (i)); % J = [0 1 0]
J(:,2) = 1;

K = zeros(size (i)); % K = [ 0 0 1]
K(:,3) = 1;


% Calculo de l�nea de nodos

Nodo= cross(K,k);
normNodo=sqrt(sum(Nodo.^2,2));
nodo=Nodo./[normNodo,normNodo,normNodo];                                 %L�nea de nodos del segmento

% Calculo de Angulos de Euler
% Recordar la equivalencia entre alfa y phi, beta y theta, gamma y psi

alfasen = asin(dot(cross (I,nodo),K,2));
betasen = asin(dot(cross (K,k),nodo,2));
gamasen = asin(dot(cross (nodo,i),k,2));

% Reviso �ngulos de euler para revisar que no haya saltos.
% En el caso de usar el arco seno, los saltos estar�n cerca de los 90�. 
% En el caso de usar arco coseno, los saltos estar�n cerca de 180�.

% figure;
% plot(alfasen,'LineWidth',2);
% xlabel('Frames');
% ylabel('Grados');
% title('Angulo alfa del segmento');
% grid on;
% 
% figure;
% plot(betasen,'LineWidth',2);
% xlabel('Frames');
% ylabel('Grados');
% title('Angulo beta del segmento');
% grid on;
% 
% figure;
% plot(gamasen,'LineWidth',2);
% xlabel('Frames');
% ylabel('Grados');
% title('Angulo gama del segmento');
% grid on;

% Por si encuentro saltos en los �ngulos, rearmo los angulos, utilizando
% la funci�n del arco coseno
% Alfa
auxcosalfa1=dot(J,nodo,2);                              % Variables auxiliares, 
auxcosalfa2= sqrt(sum(auxcosalfa1.^2,2));
auxcosalfa3=auxcosalfa1./auxcosalfa2;

auxalfa=acos(dot(I,nodo,2));
alfacos = dot(auxcosalfa3,auxalfa,2);

%Beta
betacos = acos(dot(K,k,2));              % ATENCI�N BETA Y BETA CORREGIDO parecen tener distinto signo, sin embargo es todo causado por valores superiores a 90�

%Gamma
auxcosgama1=dot(j,nodo,2);                              % Variables auxiliares, 
auxcosgama2= sqrt(sum(auxcosgama1.^2,2));
auxcosgama3=auxcosgama1./auxcosgama2;

auxgama=acos(dot(i,nodo,2));
gamacos =- dot(auxcosgama3,auxgama,2);
if (graficar)
    figure;
    plot(alfasen,'LineWidth',2); hold on; plot(alfacos,'r','LineWidth',2);
    legend('Angulo Alfa calculado con asind', 'Angulo Alfa calculado con acosd');
    xlabel('Frames');
    ylabel('Grados');
    title('Angulo alfa del segmento ',segmento);
    grid on;
    figure;
    plot(betasen,'LineWidth',2); hold on; plot(betacos,'r','LineWidth',2);
    legend('Angulo Beta calculado con asind', 'Angulo Beta calculado con acosd');
    xlabel('Frames');
    ylabel('Grados');
    title('Angulo beta del segmento ',segmento);
    grid on;
    figure;
    plot(gamasen,'LineWidth',2);hold on; plot(gamacos,'r','LineWidth',2);
    legend('Angulo Gamma calculado con asind', 'Angulo Gamma calculado con acosd');
    xlabel('Frames');
    ylabel('Grados');
    title('Angulo gama del segmento ', segmento);
    grid on;
end
    

% Una vez que tengan elegidos los �ngulos, pueden anular la graficaci�n,
% mediante el uso del signo "comentar" %. Todo lo que aparezca en una l�nea
% de comando, despu�s de % se entiende como texto y no c�digo.