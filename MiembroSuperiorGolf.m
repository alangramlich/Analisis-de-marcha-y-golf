clear all;

Archivo='C:\Users\alang\Documents\Facultad\BIOMECANIC\ANALISIS DE MARCHA\Putter_frente_001.c3d';

h=btkReadAcquisition(Archivo);

[marcadores,informacionCine]=btkGetMarkers(h);

[fuerzas,informacionFuerzas]=btkGetForcePlatforms(h);

%Antropometria=btkFindMetaData(h,'Antropometria');
AC_R=marcadores.MarkerSet__R_AC;
AC_L=marcadores.MarkerSet__L_AC;
IJ=marcadores.MarkerSet__IJ;
PX=marcadores.MarkerSet__AX;
EL_R=marcadores.MarkerSet__R_EL;
EL_L=marcadores.MarkerSet__L_EL;
EM_R=marcadores.MarkerSet__R_EM;
EM_L=marcadores.MarkerSet__L_EM;
ASIS_R=marcadores.MarkerSet__R_ASIS;
ASIS_L=marcadores.MarkerSet__L_ASIS;
RS_R=marcadores.MarkerSet__R_RS;
RS_L=marcadores.MarkerSet__L_RS;
US_R=marcadores.MarkerSet__R_US;
US_L=marcadores.MarkerSet__L_US;
C7=marcadores.MarkerSet__C7;
T8=marcadores.MarkerSet__T8;
PSIS=marcadores.MarkerSet__SACRUM;
PALO_S=marcadores.MarkerSet__PALO_S;
PALO_I=marcadores.MarkerSet__PALO_I;
PELOTA=marcadores.MarkerSet__PELOTA;

Eventos=btkGetEvents(h);
%% Filtro de Marcadores
fm=informacionCine.frequency;
fe=fm/2;% frec de nisquist
wn=10/fe; % frec de corte de 10hz
[B,A]=butter(2,wn); %Filtro de butter
for i=1:3
    AC_R(:,i)= filtfilt(B,A,AC_R(:,i));
    AC_L(:,i)= filtfilt(B,A,AC_L(:,i));
    IJ(:,i)= filtfilt(B,A,IJ(:,i));
    PX(:,i)= filtfilt(B,A,PX(:,i));
    EL_R(:,i)= filtfilt(B,A,EL_R(:,i));
    EL_L(:,i)= filtfilt(B,A,EL_L(:,i));
    EM_R(:,i)= filtfilt(B,A,EM_R(:,i));
    EM_L(:,i)= filtfilt(B,A,EM_L(:,i));
    ASIS_R(:,i)= filtfilt(B,A,ASIS_R(:,i));
    ASIS_L(:,i)= filtfilt(B,A,ASIS_L(:,i));
    RS_R(:,i)= filtfilt(B,A,RS_R(:,i));
    RS_L(:,i)= filtfilt(B,A,RS_L(:,i));
    US_L(:,i)= filtfilt(B,A,US_L(:,i));
    US_R(:,i)= filtfilt(B,A,US_R(:,i));
    C7(:,i)= filtfilt(B,A,C7(:,i));
    T8(:,i)= filtfilt(B,A,T8(:,i));
    PSIS(:,i)= filtfilt(B,A,PSIS(:,i));
   end;

%% VECTORES X Y Z Pelvis


Numpelvis=ASIS_R-ASIS_L;
Denpelvis=sqrt(sum(Numpelvis.^2,2));
Zpelvis=Numpelvis./Denpelvis;

Numypelvis=cross((PSIS-ASIS_L),(Numpelvis));
Denypelvis=sqrt(sum(Numypelvis.^2,2))
Ypelvis=Numypelvis./Denypelvis;

Numxpelvis=cross(Ypelvis,Zpelvis);
Denxpelvis=sqrt(sum(Numxpelvis.^2,2))
Xpelvis=Numxpelvis./Denxpelvis;

%% VECTORES X Y Z Torax

Numytorax=((IJ+C7)/2)-((PX+T8)/2);
Denytorax=sqrt(sum(Numytorax.^2,2));
Ytorax=Numytorax./Denytorax;

Numwtorax=cross((C7-IJ),((PX+T8)/2)-IJ);
Denwtorax=sqrt(sum(Numwtorax.^2,2));
Ztorax=Numwtorax./Denwtorax;

Numutorax=cross(Ytorax,Ztorax);
Denutorax=sqrt(sum(Numutorax.^2,2));
Xtorax=Numutorax./Denutorax;

%% Humero (centro art cavidad glenoidea y codo)
Numuhum=AC_R-AC_L
Denuhum=sqrt(sum(Numuhum.^2,2));
GH_XAUX=Numuhum./Denuhum;

Numuhum=C7-AC_L
Denuhum=sqrt(sum(Numuhum.^2,2));
GH_AUX=Numuhum./Denuhum;

Numuhum=cross(GH_AUX,GH_XAUX);
Denuhum=sqrt(sum(Numuhum.^2,2));
GH_YAUX=Numuhum./Denuhum;

%ESTO ES EL CENTRO ARTICULAR DE LA CAVIDAD GLENOIDEA
Factor=AC_R-AC_L;
Factor=sqrt(sum(Factor.^2,2));
GH_R=-0.17*GH_YAUX.*Factor+AC_R
Factor=AC_R-AC_L
Factor=sqrt(sum(Factor.^2,2));
GH_L=-0.17*GH_YAUX.*Factor+AC_L

%ESTO ES EL CENTRO ARTICULAR DEL CODO
EJC_R=(EL_L+EM_L)/2
EJC_L=(EL_R+EM_R)/2

%ESTO NO SE QUE ES
Num=GH_R-EJC_R;
Den=sqrt(sum(Num.^2,2))
Y_H2_R=Num./Den;

Num=GH_L-EJC_L;
Den=sqrt(sum(Num.^2,2))
Y_H2_L=Num./Den;
%ACA HABLA DE UN Y_A QUE NUNCA DEFINIO Y LO DEFINE RECIEN 
%EN LA SECCION SIGUIENTE

%% Antebrazo
Num=EJC_L-US_L;
Den=sqrt(sum(Num.^2,2));
Y_A_L=Num./Den;
Num=EJC_R-US_R;
Den=sqrt(sum(Num.^2,2));
Y_A_R=Num./Den;
%Y_A es una linea que une US con EJC (seria algo asi como el eje del
%antebrazo)
Num=cross(Y_A_R, (RS_R-US_R));
Den=sqrt(sum(Num.^2,2));
X_A_R=Num./Den;
Num=cross((RS_L-US_L), Y_A_L);
Den=sqrt(sum(Num.^2,2));
X_A_L=Num./Den;
%X_A es perpendicular a US, RS, EJC, y apunta hacia adelante 
%(donde puta sera adelante no tengo idea)
Num=cross(X_A_R, Y_A_R);
Den=sqrt(sum(Num.^2,2));
Z_A_R=Num./Den;
Num=cross(X_A_L, Y_A_L);
Den=sqrt(sum(Num.^2,2));
Z_A_L=Num./Den;



%% Humero (si, humero, porque resulta que necesito parametros del antebrazo ¿¿¿???)
Num=cross(Y_H2_R, Y_A_R);
Den=sqrt(sum(Num.^2,2));
Z_H2_R=Num./Den;

Num=cross(Y_H2_R, Z_H2_R);
Den=sqrt(sum(Num.^2,2));
X_H2_R=Num./Den;

%VOY A SUPONER QUE PARA EL IZQUIERDO ES TODO TAL CUAL

Num=cross(Y_H2_L, Y_A_L);
Den=sqrt(sum(Num.^2,2));
Z_H2_L=Num./Den;

Num=cross(Y_H2_L, Z_H2_L);
Den=sqrt(sum(Num.^2,2));
X_H2_L=Num./Den;
%% HORA DE GRAFICAR
%% GRAFICO PELVIS
% figure;
% plot3(PSIS(:,1),PSIS(:,2),PSIS(:,3),'k','LineWidth',2);
% hold on;
% for i=1:10:length(PSIS)
%     quiver3(PSIS(i, 1), PSIS(i, 2), PSIS(i, 3), Xpelvis(i, 1)/10, Xpelvis(i, 2)/10, Xpelvis(i, 3)/10, 'b');
%     hold on;
%     quiver3(PSIS(i, 1), PSIS(i, 2), PSIS(i, 3), Ypelvis(i, 1)/10, Ypelvis(i, 2)/10, Ypelvis(i, 3)/10, 'r');
%     hold on;
%     quiver3(PSIS(i, 1), PSIS(i, 2), PSIS(i, 3), Zpelvis(i, 1)/10, Zpelvis(i, 2)/10, Zpelvis(i, 3)/10, 'g');
%     hold on;
% end
% xlabel('Eje X');
% ylabel('Eje Y');
% zlabel('Eje Z');
% title('Vectores XP, YP, ZP sobre el punto PSIS');
% grid on;
% legend('XP', 'YP', 'ZP');
% view(3);
%% GRAFICO TORAX
% figure;
% plot3(IJ(:,1),IJ(:,2),IJ(:,3),'k','LineWidth',2);
% hold on;
% for i=1:10:length(IJ)
%     quiver3(IJ(i, 1), IJ(i, 2), IJ(i, 3), Xtorax(i, 1)/10, Xtorax(i, 2)/10, Xtorax(i, 3)/10, 'b');
%     hold on;
%     quiver3(IJ(i, 1), IJ(i, 2), IJ(i, 3), Ytorax(i, 1)/10, Ytorax(i, 2)/10, Ytorax(i, 3)/10, 'r');
%     hold on;
%     quiver3(IJ(i, 1), IJ(i, 2), IJ(i, 3), Ztorax(i, 1)/10, Ztorax(i, 2)/10, Ztorax(i, 3)/10, 'g');
%     hold on;
% end
% xlabel('Eje X');
% ylabel('Eje Y');
% zlabel('Eje Z');
% title('Vectores XT, YT, ZT sobre el punto IJ');
% grid on;
% legend('XT', 'YT', 'ZT');
% view(3);
%% GRAFICO CAVIDAD GLENOIDEA DERECHA
% figure;
% plot3(GH_R(:,1),GH_R(:,2),GH_R(:,3),'k','LineWidth',2);
% hold on;
% for i=1:10:length(IJ)
%     quiver3(GH_R(i, 1), GH_R(i, 2), GH_R(i, 3), X_H2_R(i, 1)/10, X_H2_R(i, 2)/10, X_H2_R(i, 3)/10, 'b');
%     hold on;
%     quiver3(GH_R(i, 1), GH_R(i, 2), GH_R(i, 3), Y_H2_R(i, 1)/10, Y_H2_R(i, 2)/10, Y_H2_R(i, 3)/10, 'r');
%     hold on;
%     quiver3(GH_R(i, 1), GH_R(i, 2), GH_R(i, 3), Z_H2_R(i, 1)/10, Z_H2_R(i, 2)/10, Z_H2_R(i, 3)/10, 'g');
%     hold on;
% end
% xlabel('Eje X');
% ylabel('Eje Y');
% zlabel('Eje Z');
% title('Vectores X_H2, Y_H2, Z_H2 sobre la cavidad glenoidea DERECHA');
% grid on;
% legend('XT', 'YT', 'ZT');
% view(3);
%% GRAFICO CAVIDAD GLENOIDEA IZQUIERDA
% figure;
% plot3(GH_L(:,1),GH_L(:,2),GH_L(:,3),'k','LineWidth',2);
% hold on;
% for i=1:10:length(IJ)
%     quiver3(GH_L(i, 1), GH_L(i, 2), GH_L(i, 3), X_H2_L(i, 1)/10, X_H2_L(i, 2)/10, X_H2_L(i, 3)/10, 'b');
%     hold on;
%     quiver3(GH_L(i, 1), GH_L(i, 2), GH_L(i, 3), Y_H2_L(i, 1)/10, Y_H2_L(i, 2)/10, Y_H2_L(i, 3)/10, 'r');
%     hold on;
%     quiver3(GH_L(i, 1), GH_L(i, 2), GH_L(i, 3), Z_H2_L(i, 1)/10, Z_H2_L(i, 2)/10, Z_H2_L(i, 3)/10, 'g');
%     hold on;
% end
% xlabel('Eje X');
% ylabel('Eje Y');
% zlabel('Eje Z');
% title('Vectores X_H2, Y_H2, Z_H2 sobre la cavidad glenoidea IZQUIERDA');
% grid on;
% legend('XT', 'YT', 'ZT');
% view(3);

%% Muñeca

O_M_R=(US_R+RS_R)/2;
O_M_L=(US_L+RS_L)/2;

%Num=O_M_R-(M_H2_R+M_H5_R)/2;
%Den=sqrt(sum(Num.^2,2));
%Y_M_R=Num./Den;

%Num=O_M_L-(M_H2_L+M_H5_L)/2;
%Den=sqrt(sum(Num.^2,2));
%Y_M_L=Num./Den;
%ACA NOS FALTAN MARCADORES!!!
%% ANGULOS

%% HOMBRO
e1_hombro=Ytorax %este es el plano de elevacion 
%0 grados significa que el humero se encuentra coincidente
%con el plano frontal
%angulos positivos significan flexion hacia adelante ALFA
Num=cross(Y_H2_R, Ytorax);
Den=sqrt(sum(Num.^2,2));
I_hombro_R=Num./Den;

Num=cross(Y_H2_L, Ytorax);
Den=sqrt(sum(Num.^2,2));
I_hombro_L=Num./Den;

Num=dot(I_hombro_R, -Ztorax, 2);
Den=sqrt(sum(Num.^2,2));
Factor1=Num./Den;
Factor2=dot(I_hombro_R, Xtorax,2);
alfa_hombro_R=acosd((dot(Factor2, Factor1,2)));

Num=dot(I_hombro_L, -Ztorax, 2);
Den=sqrt(sum(Num.^2,2));
Factor1=Num./Den;
Factor2=dot(I_hombro_L, -Xtorax,2);
alfa_hombro_L=acosd((dot(Factor2, Factor1,2)));

%ROTACION INTERNA EXTERNA DEL HOMBRO, GAMMA

Num=dot(I_hombro_R, X_H2_R,2);
Den=sqrt(sum(Num.^2,2));
Factor1=Num./Den;
Factor2=dot(-Z_H2_R,I_hombro_R,2);
gamma_hombro_R=acosd(dot(Factor2,Factor1,2));


Num=dot(I_hombro_L, X_H2_L,2);
Den=sqrt(sum(Num.^2,2));
Factor1=Num./Den;
Factor2=dot(-Z_H2_L,I_hombro_L,2);
gamma_hombro_L=acosd(dot(Factor2,Factor1,2));

%BETA DEL HOMBRO, ELEVACION DEL HUMERO RESPECTO DEL TRONCO
beta_hombro_R=acosd(dot(Y_H2_R, Ytorax,2));
beta_hombro_L=acosd(dot(Y_H2_L, Ytorax,2));

%NO ME QUEDA CLARO CUAL ES ALFA Y CUAL ES GAMMA PERO BUENO AL MENOS TENEMOS
%ALGO


%% CODO 

% ALFA positivo flexion negativo hiperextension
Num=cross(Z_H2_R, Y_A_R);
Den=sqrt(sum(Num.^2,2));
I_codo_R = Num./Den;

Num=dot(I_codo_R, Y_H2_R, 2);
Den=sqrt(sum(Num.^2,2));
Factor2=Num./Den;
Factor1=dot(-I_codo_R, X_H2_R, 2);
alfa_codo_R=acosd(dot(Factor1, Factor2, 2));

Num=cross(Z_H2_L, Y_A_L);
Den=sqrt(sum(Num.^2,2));
I_codo_L = Num./Den;

Num=dot(I_codo_L, Y_H2_L, 2);
Den=sqrt(sum(Num.^2,2));
Factor2=Num./Den;
Factor1=dot(-I_codo_L, X_H2_L, 2);
alfa_codo_L=acosd(dot(Factor1, Factor2, 2));

% GAMMA POSITIVO PARA ROT INTERNA 
Num=dot(X_A_R, Z_H2_R, 2);
Den=sqrt(sum(Num.^2,2));
Factor2=Num./Den;
Factor1=dot(-I_codo_R, X_A_R, 2);
gamma_codo_R=-acosd(dot(Factor1, Factor2, 2));

Num=dot(X_A_L, Z_H2_L, 2);
Den=sqrt(sum(Num.^2,2));
Factor2=Num./Den;
Factor1=dot(-I_codo_L, X_A_L, 2);
gamma_codo_L=-acosd(dot(Factor1, Factor2, 2));

% BETA ABDUCCION NEGATIVO

beta_codo_R=asind(dot(Z_H2_R, Y_A_R, 2));
beta_codo_L=asind(dot(Z_H2_L, Y_A_L, 2));


%% MUÑECA
%no tenemos los marcadores jejox

%% ARTICULACION LUMBOSACRA

Num=cross(Xtorax, Ypelvis);
Den=sqrt(sum(Num.^2,2));
I_lumbosacro=Num./Den;

%INCLINACION DEL TRONCO
Num=dot(-I_lumbosacro, Ytorax, 2);
Den=sqrt(sum(Num.^2,2));
Factor2=Num./Den;
Factor1=dot(Xtorax, -I_lumbosacro, 2);
sigma_tronco=acosd(dot(Factor1, Factor2, 2));

%OBLICUIDAD mide que tanto el hombro izquierdo se eleva respecto del
%derecho
psi_tronco=asind(dot(Ytorax, Zpelvis, 2));

%FACTOR X compara la rotacion de los hombros con la de la pelvis
%positivo cuando el hombro derecho rota externamente (?????)
%y negativo cuando el hombro derecho rota internamente (??????)
Num=dot(I_lumbosacro, Zpelvis, 2);
Den=sqrt(sum(Num.^2,2));
Factor2=Num./Den;
Factor1=dot(Xpelvis, -I_lumbosacro, 2);
factor_x_tronco=dot(Factor1, Factor2, 2);


%% GRAFICAS 

% Crear una nueva figura
figure;

% Primer subplot
subplot(3,1,1); % 3 filas, 1 columna, primer subplot
plot(alfa_hombro_R);
title('Gráfica de alfa hombro R');

% Segundo subplot
subplot(3,1,2); % 3 filas, 1 columna, segundo subplot
plot(beta_hombro_R);
title('Gráfica de beta hombro R');

% Tercer subplot
subplot(3,1,3); % 3 filas, 1 columna, tercer subplot
plot(gamma_hombro_R);
title('Gráfica de gamma hombro R');



% Crear una nueva figura
figure;

% Primer subplot
subplot(3,1,1); % 3 filas, 1 columna, primer subplot
plot(alfa_hombro_L);
title('Gráfica de alfa hombro L');

% Segundo subplot
subplot(3,1,2); % 3 filas, 1 columna, segundo subplot
plot(beta_hombro_L);
title('Gráfica de beta hombro L');

% Tercer subplot
subplot(3,1,3); % 3 filas, 1 columna, tercer subplot
plot(gamma_hombro_L);
title('Gráfica de gamma hombro L');

% Crear una nueva figura
figure;

% Primer subplot
subplot(3,1,1); % 3 filas, 1 columna, primer subplot
plot(alfa_codo_L);
title('Gráfica de alfa codo L');

% Segundo subplot
subplot(3,1,2); % 3 filas, 1 columna, segundo subplot
plot(beta_codo_L);
title('Gráfica de beta codo L');

% Tercer subplot
subplot(3,1,3); % 3 filas, 1 columna, tercer subplot
plot(gamma_codo_L);
title('Gráfica de gamma codo L');


% Crear una nueva figura
figure;

% Primer subplot
subplot(3,1,1); % 3 filas, 1 columna, primer subplot
plot(alfa_codo_R);
title('Gráfica de alfa codo R');

% Segundo subplot
subplot(3,1,2); % 3 filas, 1 columna, segundo subplot
plot(beta_codo_R);
title('Gráfica de beta codo R');

% Tercer subplot
subplot(3,1,3); % 3 filas, 1 columna, tercer subplot
plot(gamma_codo_R);
title('Gráfica de gamma codo R');



% Crear una nueva figura
figure;

% Primer subplot
subplot(3,1,1); % 3 filas, 1 columna, primer subplot
plot(sigma_tronco);
title('Gráfica de inclinacion del tronco');

% Segundo subplot
subplot(3,1,2); % 3 filas, 1 columna, segundo subplot
plot(psi_tronco);
title('Gráfica de oblicuidad del tronco');

% Tercer subplot
subplot(3,1,3); % 3 filas, 1 columna, tercer subplot
plot(factor_x_tronco);
title('Gráfica de factor x tronco');