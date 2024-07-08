%% Biomecanica
clear;
close all;
clc;
%% Carga del registro

Registro = CargarRegistro();

% variables antroprometricas en METROS (por eso divido por 100 ya que estan
% medidas en centimetros)
FL_R = Registro.antropometria.LONGITUD_PIE_DERECHO.Valor/100;
FL_L = Registro.antropometria.LONGITUD_PIE_IZQUIERDO.Valor/100;
MH_R = Registro.antropometria.ALTURA_MALEOLOS_DERECHO.Valor/100;
MH_L = Registro.antropometria.ALTURA_MALEOLOS_IZQUIERDO.Valor/100;
MW_R = Registro.antropometria.ANCHO_MALEOLOS_DERECHO.Valor/100;
MW_L = Registro.antropometria.ANCHO_MALEOLOS_IZQUIERDO.Valor/100;
KD_R = Registro.antropometria.DIAMETRO_RODILLA_DERECHA.Valor/100;
KD_L = Registro.antropometria.DIAMETRO_RODILLA_IZQUIERDA.Valor/100;
LA = Registro.antropometria.LONGITUD_ASIS.Valor/100;
FW_R = Registro.antropometria.ANCHO_PIE_DERECHO.Valor/100;
FW_L = Registro.antropometria.ANCHO_PIE_IZQUIERDO.Valor/100;

A1 = Registro.antropometria.PESO.Valor;
A7 = Registro.antropometria.LONGITUD_PIERNA_DERECHA.Valor/100;
A8 = Registro.antropometria.LONGITUD_PIERNA_IZQUIERDA.Valor/100;
A11 = KD_R;
A12 = KD_L;
A13 = FL_R;
A14 = FL_L;
A15 = MH_R;
A16 = MH_L;
A17 = MW_R;
A18 = MW_L;
A19 = FW_R;
A20 = FW_L;

%Altura en centimetros
Altura = Registro.antropometria.ALTURA.Valor;
%% Recorte y Lectura de marcadores

fm = Registro.info.Cinematica.frequency;

LHS1 = round(Registro.eventos.Izquierdo_LHS(1)*fm); 
LHS2 = round(Registro.eventos.Izquierdo_LHS(2)*fm);
LTO = round(Registro.eventos.Izquierdo_LTO*fm);

RHS1 = round(Registro.eventos.Derecho_RHS(1)*fm); 
RHS2 = round(Registro.eventos.Derecho_RHS(2)*fm);
RTO = round(Registro.eventos.Derecho_RTO*fm);

RTO_CM=round(((RTO-RHS1)*100)/(RHS2-RHS1));
LTO_CM=round(((LTO-LHS1)*100)/(LHS2-LHS1));
Inicio = LHS1 - 10;
Fin = RHS2 + 10;

p1 = Registro.Pasada.Marcadores.Crudos.Valores.r_met(Inicio:Fin,:);
p2 = Registro.Pasada.Marcadores.Crudos.Valores.r_heel(Inicio:Fin,:);
p3 = Registro.Pasada.Marcadores.Crudos.Valores.r_mall(Inicio:Fin,:);
p4 = Registro.Pasada.Marcadores.Crudos.Valores.r_bar_2(Inicio:Fin,:);
p5 = Registro.Pasada.Marcadores.Crudos.Valores.r_knee_1(Inicio:Fin,:);
p6 = Registro.Pasada.Marcadores.Crudos.Valores.r_bar_1(Inicio:Fin,:);
p7 = Registro.Pasada.Marcadores.Crudos.Valores.r_asis(Inicio:Fin,:);
p8 = Registro.Pasada.Marcadores.Crudos.Valores.l_met(Inicio:Fin,:);
p9 = Registro.Pasada.Marcadores.Crudos.Valores.l_heel(Inicio:Fin,:);
p10 = Registro.Pasada.Marcadores.Crudos.Valores.l_mall(Inicio:Fin,:);
p11 = Registro.Pasada.Marcadores.Crudos.Valores.l_bar_2(Inicio:Fin,:);
p12 = Registro.Pasada.Marcadores.Crudos.Valores.l_knee_1(Inicio:Fin,:);
p13 = Registro.Pasada.Marcadores.Crudos.Valores.l_bar_1(Inicio:Fin,:);
p14 = Registro.Pasada.Marcadores.Crudos.Valores.l_asis(Inicio:Fin,:);
p15 = Registro.Pasada.Marcadores.Crudos.Valores.sacrum(Inicio:Fin,:);
%% Filtrado de marcadores

fe = fm/2;      %frec de Nyquist
wn = 10/fe;     %frecuencia de corte 10Hz
[B,A] = butter(2,wn);   %filtro

for i =1:3
   p1(:,i) = filtfilt(B, A, p1(:,i));
   p2(:,i) = filtfilt(B, A, p2(:,i));
   p3(:,i) = filtfilt(B, A, p3(:,i));
   p4(:,i) = filtfilt(B, A, p4(:,i));
   p5(:,i) = filtfilt(B, A, p5(:,i));
   p6(:,i) = filtfilt(B, A, p6(:,i));
   p7(:,i) = filtfilt(B, A, p7(:,i));
   p8(:,i) = filtfilt(B, A, p8(:,i));
   p9(:,i) = filtfilt(B, A, p9(:,i));
   p10(:,i) = filtfilt(B, A, p10(:,i));
   p11(:,i) = filtfilt(B, A, p11(:,i));
   p12(:,i) = filtfilt(B, A, p12(:,i));
   p13(:,i) = filtfilt(B, A, p13(:,i));
   p14(:,i) = filtfilt(B, A, p14(:,i));
   p15(:,i) = filtfilt(B, A, p15(:,i));
    
end
%% Calculo de u, v, w

Registro = CalculoV(Registro, p14, p7, 'vPelvis',p7-p15 ,p14-p15 , 'wPelvis', 'uPelvis',1);
Registro = CalculoV(Registro, p3, p5, 'vRodillaR',p4-p5  ,p3-p5 , 'uRodillaR', 'wRodillaR',-1);
Registro = CalculoV(Registro, p10, p12, 'vRodillaL', p10-p12 ,p11-p12 , 'uRodillaL', 'wRodillaL',-1);
Registro = CalculoV(Registro, p1, p2, 'uTobilloR', p1-p3 ,p2-p3 , 'wTobilloR', 'vTobilloR',-1);
Registro = CalculoV(Registro, p8, p9, 'uTobilloL', p8-p10 ,p9-p10 , 'wTobilloL', 'vTobilloL',-1);
%% Cálculo de centros articulares
R_HJC = CalculoCentroArticular(Registro, p15, LA*0.598, -LA*0.344, -LA*0.29, 'Pelvis');
L_HJC = CalculoCentroArticular(Registro, p15, LA*0.598, LA*0.344, -LA*0.29, 'Pelvis');
R_KJC = CalculoCentroArticular(Registro, p5, 0, 0, 0.5*KD_R, 'RodillaR');
L_KJC = CalculoCentroArticular(Registro, p12, 0, 0, -0.5*KD_L, 'RodillaL');
R_AJC = CalculoCentroArticular(Registro, p3, 0.016*FL_R, 0.392*MH_R, 0.478*MW_R, 'TobilloR');
L_AJC = CalculoCentroArticular(Registro, p10, 0.016*FL_L, 0.392*MH_L, -0.478*MW_L, 'TobilloL');
R_TOE = CalculoCentroArticular(Registro, p3, 0.742*FL_R, 1.074*MH_R, -0.187*FW_R, 'TobilloR');
L_TOE = CalculoCentroArticular(Registro, p10, 0.742*FL_L, 1.074*MH_L, 0.187*FW_L, 'TobilloL');
%% Calculo de i, j, k

%Sistema i,j, k para pelvis

Registro.SCG.iPelvis = Registro.SCL.wPelvis;
Registro.SCG.jPelvis = Registro.SCL.uPelvis;
Registro.SCG.kPelvis = Registro.SCL.vPelvis;


%Sistema i,j, k para muslo

Registro = Calculo_ijk(Registro, R_HJC, R_KJC, 'iMusloR',p6-R_HJC , R_KJC - R_HJC , 'jMusloR', 'kMusloR',1);
Registro = Calculo_ijk(Registro, L_HJC, L_KJC, 'iMusloL',L_KJC - L_HJC , p13-L_HJC , 'jMusloL', 'kMusloL',1);


%Sistema i,j, k para pierna

Registro = Calculo_ijk(Registro, R_KJC, R_AJC, 'iPiernaR', p5-R_KJC, R_AJC - R_KJC, 'jPiernaR', 'kPiernaR',1);
Registro = Calculo_ijk(Registro, L_KJC, L_AJC, 'iPiernaL', L_AJC-L_KJC,p12 - L_KJC ,  'jPiernaL', 'kPiernaL',1);


%Sistema i,j, k para pie

Registro = Calculo_ijk(Registro, p2, R_TOE, 'iPieR',R_AJC-p2 , R_TOE - p2 , 'kPieR', 'jPieR',-1);
Registro = Calculo_ijk(Registro, p9, L_TOE, 'iPieL',L_AJC-p9, L_TOE - p9 , 'kPieL', 'jPieL',-1);
%% Cálculo centros de masa

R_TCG = R_HJC + 0.39*(R_KJC-R_HJC);
L_TCG = L_HJC + 0.39*(L_KJC-L_HJC);
R_CCG = R_KJC + 0.42*(R_AJC-R_KJC);
L_CCG = L_KJC + 0.42*(L_AJC-L_KJC);
R_FCG = p2 + 0.44*(R_TOE-p2);
L_FCG = p9 + 0.44*(L_TOE-p9);
%% Calculo angulos articulares en grados

%cadera derecha
[alfaCaderaR, betaCaderaR, gamaCaderaR, iCaderaR] = CalculoAngulos(Registro, 'kPelvis','iMusloR', 'iPelvis','kPelvis','iMusloR', 'kMusloR');

gamaCaderaR = -gamaCaderaR;

%cadera izquierda
[alfaCaderaL, betaCaderaL, gamaCaderaL, iCaderaL] = CalculoAngulos(Registro, 'kPelvis','iMusloL', 'iPelvis','kPelvis','iMusloL', 'kMusloL');

betaCaderaL = -betaCaderaL;

%rodilla derecha
[alfaRodillaR, betaRodillaR, gamaRodillaR, iRodillaR] = CalculoAngulos(Registro, 'kMusloR','iPiernaR', 'iMusloR','kMusloR','iPiernaR', 'kPiernaR');
alfaRodillaR = -alfaRodillaR;
gamaRodillaR = -gamaRodillaR;

%rodilla izquierda
[alfaRodillaL, betaRodillaL, gamaRodillaL, iRodillaL] = CalculoAngulos(Registro, 'kMusloL','iPiernaL', 'iMusloL','kMusloL','iPiernaL', 'kPiernaL');
alfaRodillaL = -alfaRodillaL;
betaRodillaL = -betaRodillaL;

%tobillo derecha
[alfaTobilloR, betaTobilloR, gamaTobilloR,iTobilloR] = CalculoAngulos(Registro, 'kPiernaR','iPieR', 'jPiernaR','kPiernaR','iPieR', 'kPieR');
alfaTobilloR = -alfaTobilloR;

%tobillo izquierda
[alfaTobilloL, betaTobilloL, gamaTobilloL, iTobilloL] = CalculoAngulos(Registro, 'kPiernaL','iPieL', 'jPiernaL','kPiernaL','iPieL', 'kPieL');
alfaTobilloL = -alfaTobilloL;
betaTobilloL = -betaTobilloL;
gamaTobilloL = -gamaTobilloL;
%% Recorte e interpolacion

%cadera derecha
[alfaCaderaR] = InterpolaA100Muestras(alfaCaderaR(RHS1 - Inicio:RHS2 - Inicio));
[betaCaderaR] = InterpolaA100Muestras(betaCaderaR(RHS1 - Inicio:RHS2 - Inicio));
[gamaCaderaR] = InterpolaA100Muestras(gamaCaderaR(RHS1 - Inicio:RHS2 - Inicio));

%cadera izquierda
[alfaCaderaL] = InterpolaA100Muestras(alfaCaderaL(1:LHS2 - Inicio));
[betaCaderaL] = InterpolaA100Muestras(betaCaderaL(1:LHS2 - Inicio));
[gamaCaderaL] = InterpolaA100Muestras(gamaCaderaL(1:LHS2 - Inicio));

%rodilla derecha
[alfaRodillaR] = InterpolaA100Muestras(alfaRodillaR(RHS1 - Inicio:RHS2 - Inicio)); 
[betaRodillaR] = InterpolaA100Muestras(betaRodillaR(RHS1 - Inicio:RHS2 - Inicio));
[gamaRodillaR] = InterpolaA100Muestras(gamaRodillaR(RHS1 - Inicio:RHS2 - Inicio));

%rodilla izquierda
[alfaRodillaL] = InterpolaA100Muestras(alfaRodillaL(1:LHS2 - Inicio)); 
[betaRodillaL] = InterpolaA100Muestras(betaRodillaL(1:LHS2 - Inicio)); 
[gamaRodillaL] = InterpolaA100Muestras(gamaRodillaL(1:LHS2 - Inicio));

%tobillo derecha
[alfaTobilloR] = InterpolaA100Muestras(alfaTobilloR(RHS1 - Inicio:RHS2 - Inicio)); 
[betaTobilloR] = InterpolaA100Muestras(betaTobilloR(RHS1 - Inicio:RHS2 - Inicio));
[gamaTobilloR] = InterpolaA100Muestras(gamaTobilloR(RHS1 - Inicio:RHS2 - Inicio));

%tobillo izquierda
[alfaTobilloL] = InterpolaA100Muestras(alfaTobilloL(1:LHS2 - Inicio)); 
[betaTobilloL] = InterpolaA100Muestras(betaTobilloL(1:LHS2 - Inicio)); 
[gamaTobilloL] = InterpolaA100Muestras(gamaTobilloL(1:LHS2 - Inicio)); 
%% Grafica de centros de masa
% figure;
% plot3(R_TCG(:,1),R_TCG(:,2),R_TCG(:,3),'b--','LineWidth',2);
% hold on;
% plot3(R_CCG(:,1),R_CCG(:,2),R_CCG(:,3),'b--','LineWidth',2);
% hold on;
% % plot3(CM_rfoot(:,1),CM_rfoot(:,2),CM_rfoot(:,3),'b--','LineWidth',2); 'Centro de masa pie derecho',
% % hold on;
% plot3(R_HJC(:,1),R_HJC(:,2),R_HJC(:,3),'r','LineWidth',2);
% hold on;
% plot3(p2(:,1),p2(:,2),p2(:,3),'g','LineWidth',2);
% hold on;
% % plot3(prtoe(:,1),prtoe(:,2),prtoe(:,3),'k','LineWidth',2);'Centro articular pie derecho',
% % hold on;
% plot3(R_KJC(:,1),R_KJC(:,2),R_KJC(:,3),'y','LineWidth',2);
% hold on;
% plot3(R_AJC(:,1),R_AJC(:,2),R_AJC(:,3),'b','LineWidth',2);
% hold on;
% legend('Centro de masa de muslo derecho','Centro de masa pierna derecha','Centro articular cadera derecha','Marcador de talon derecho','Centro articular rodilla derecha','Centro articular tobillo derecho');
% xlabel('Eje X');
% ylabel('Eje Y');
% zlabel('Eje Z');
% title('Trayectoria del centro de masa de la mitad derecha del miembro inferior');
% grid on;
% 
% figure;
% plot3(L_TCG(:,1),L_TCG(:,2),L_TCG(:,3),'b--','LineWidth',2);
% hold on;
% plot3(L_CCG(:,1),L_CCG(:,2),L_CCG(:,3),'b--','LineWidth',2);
% hold on;
% % plot3(CM_lfoot(:,1),CM_lfoot(:,2),CM_lfoot(:,3),'b--','LineWidth',2); 'Centro de masa pie izquierdo',
% % hold on;
% plot3(L_KJC(:,1),L_KJC(:,2),L_KJC(:,3),'r','LineWidth',2);
% hold on;
% plot3(p9(:,1),p9(:,2),p9(:,3),'g','LineWidth',2);
% hold on;
% % plot3(pltoe(:,1),pltoe(:,2),pltoe(:,3),'k','LineWidth',2);'Centro articular pie izquierdo',
% % hold on;
% plot3(L_KJC(:,1),L_KJC(:,2),L_KJC(:,3),'y','LineWidth',2);
% hold on;
% plot3(L_AJC(:,1),L_AJC(:,2),L_AJC(:,3),'b','LineWidth',2);
% hold on;
% legend('Centro de masa de muslo izquierdo','Centro de masa pierna izquierda','Centro articular de cadera izquierda','Marcador de talon izquierdo','Centro articular rodilla izquierda','Centro articular tobillo izquierdo');
% xlabel('Eje X');
% ylabel('Eje Y');
% zlabel('Eje Z');
% title('Trayectoria del centro de masa de la mitad izquierda del miembro inferior');
% grid on;
% 
% figure;
% plot3(L_FCG(:,1),L_FCG(:,2),L_FCG(:,3),'b--','LineWidth',2);
% hold on;
% plot3(p9(:,1),p9(:,2),p9(:,3),'g','LineWidth',2);
% hold on;
% plot3(L_TOE(:,1),L_TOE(:,2),L_TOE(:,3),'k','LineWidth',2);
% hold on;
% legend('Centro de masa pie izquierdo','Marcador de talon izquierdo','Centro articular pie izquierdo');
% xlabel('Eje X');
% ylabel('Eje Y');
% zlabel('Eje Z');
% title('Trayectoria del centro de masa del pie izquierdo');
% 
% figure;
% plot3(R_FCG(:,1),R_FCG(:,2),R_FCG(:,3),'b--','LineWidth',2);
% hold on;
% plot3(p2(:,1),p2(:,2),p2(:,3),'g','LineWidth',2);
% hold on;
% plot3(R_TOE(:,1),R_TOE(:,2),R_TOE(:,3),'k','LineWidth',2);
% hold on;
% legend('Centro de masa pie derecho','Marcador de talon derecho','Centro articular pie derecho');
% xlabel('Eje X');
% ylabel('Eje Y');
% zlabel('Eje Z');
% title('Trayectoria del centro de masa del pie derecho');
%% Grafica de angulos
 figure;
 subplot(3,3,1), plot(alfaCaderaR,'g'), hold on, plot(alfaCaderaL,'r'),hold on, ylabel('Cadera'),xlabel('%CM'),title('Flex(+)|Ext(-)'),grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
 subplot(3,3,2), plot(betaCaderaR,'g'), hold on,plot(betaCaderaL,'r'), hold on, xlabel('%CM'), title('Abduccion (+)|Aduccion (-)'), grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
 subplot(3,3,3), plot(gamaCaderaR,'g'), hold on,plot(gamaCaderaL,'r'), hold on, ylabel(''), title('Rot. Int(+)|Rot. Ext(-)'), grid on,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
 subplot(3,3,4), plot(alfaRodillaR,'g'),hold on,plot(alfaRodillaL,'r'),hold on, ylabel('Rodilla'),xlabel('%CM'),title('Flex(+)|Ext(-)'), grid on, zoom, axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
 subplot(3,3,5), plot(betaRodillaR,'g'),hold on,plot(betaRodillaL,'r'),hold on, ylabel(''),xlabel('%CM'), title('Abduccion (+)|Aduccion (-)'), grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
 subplot(3,3,6), plot(gamaRodillaR,'g'),hold on,plot(gamaRodillaL,'r'),hold on, ylabel(''),xlabel('%CM'), title('Rot. Int(+)|Rot. Ext(-)'), grid on,zoom, axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
 subplot(3,3,7), plot(alfaTobilloR,'g'),hold on,plot(alfaTobilloL,'r'),hold on, ylabel('Tobillo'),xlabel('%CM'),title('D. Flex(+)|P. Ext(-)'), grid on, zoom, axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
 subplot(3,3,8), plot(gamaTobilloR,'g'),hold on,plot(gamaTobilloL,'r'),hold on, ylabel(''),xlabel('%CM'), title('Inversion(+)|Eversion(-)'), grid on, zoom, axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
 subplot(3,3,9),  plot(betaTobilloR,'g'),hold on,plot(betaTobilloL,'r'),hold on, ylabel(''),xlabel('%CM'), title('Abduccion (+)|Aduccion (-)'),legend('Derecha','Izquierda'), grid on, zoom,axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
legend('off');
%% Gráfica centros de masa


% 
% figure;
% plot3(p15(:,1),p15(:,2),p15(:,3),'y','LineWidth',2);
% hold on;
% plot3(R_TCG(:,1),R_TCG(:,2),R_TCG(:,3),'y','LineWidth',2);
% hold on;
% plot3(L_TCG(:,1),L_TCG(:,2),L_TCG(:,3),'y','LineWidth',2);
% hold on;
% plot3(R_CCG(:,1),R_CCG(:,2),R_CCG(:,3),'y','LineWidth',2);
% hold on;
% plot3(L_CCG(:,1),L_CCG(:,2),L_CCG(:,3),'y','LineWidth',2);
% hold on;
% plot3(R_FCG(:,1),R_FCG(:,2),R_FCG(:,3),'y','LineWidth',2);
% hold on;
% plot3(L_FCG(:,1),L_FCG(:,2),L_FCG(:,3),'y','LineWidth',2);
% hold on;
% 
% 
% for i=1:20:length(p15)
%     quiver3(p15(i,1),p15(i,2),p15(i,3),Registro.SCG.iPelvis(i,1)/10,Registro.SCG.iPelvis(i,2)/10,Registro.SCG.iPelvis(i,3)/10,'r');
%     hold on;
%     quiver3(p15(i,1),p15(i,2),p15(i,3),Registro.SCG.jPelvis(i,1)/10,Registro.SCG.jPelvis(i,2)/10,Registro.SCG.jPelvis(i,3)/10,'g');
%     hold on;
%     quiver3(p15(i,1),p15(i,2),p15(i,3),Registro.SCG.kPelvis(i,1)/10,Registro.SCG.kPelvis(i,2)/10,Registro.SCG.kPelvis(i,3)/10,'b');
%     hold on;
% end;
% 
% for i=1:20:length(p15)
%     quiver3(R_TCG(i,1),R_TCG(i,2),R_TCG(i,3),Registro.SCG.iMusloR(i,1)/10,Registro.SCG.iMusloR(i,2)/10,Registro.SCG.iMusloR(i,3)/10,'r');
%     hold on;
%     quiver3(R_TCG(i,1),R_TCG(i,2),R_TCG(i,3),Registro.SCG.jMusloR(i,1)/10,Registro.SCG.jMusloR(i,2)/10,Registro.SCG.jMusloR(i,3)/10,'g');
%     hold on;
%     quiver3(R_TCG(i,1),R_TCG(i,2),R_TCG(i,3),Registro.SCG.kMusloR(i,1)/10,Registro.SCG.kMusloR(i,2)/10,Registro.SCG.kMusloR(i,3)/10,'b');
%     hold on;
% end;
% 
% for i=1:20:length(p15)
%     quiver3(L_TCG(i,1),L_TCG(i,2),L_TCG(i,3),Registro.SCG.iMusloL(i,1)/10,Registro.SCG.iMusloL(i,2)/10,Registro.SCG.iMusloL(i,3)/10,'r');
%     hold on;
%     quiver3(L_TCG(i,1),L_TCG(i,2),L_TCG(i,3),Registro.SCG.jMusloL(i,1)/10,Registro.SCG.jMusloL(i,2)/10,Registro.SCG.jMusloL(i,3)/10,'g');
%     hold on;
%     quiver3(L_TCG(i,1),L_TCG(i,2),L_TCG(i,3),Registro.SCG.kMusloL(i,1)/10,Registro.SCG.kMusloL(i,2)/10,Registro.SCG.kMusloL(i,3)/10,'b');
%     hold on;
% end;
% 
% for i=1:20:length(p15)
%     quiver3(R_CCG(i,1),R_CCG(i,2),R_CCG(i,3),Registro.SCG.iPiernaR(i,1)/10,Registro.SCG.iPiernaR(i,2)/10,Registro.SCG.iPiernaR(i,3)/10,'r');
%     hold on;
%     quiver3(R_CCG(i,1),R_CCG(i,2),R_CCG(i,3),Registro.SCG.jPiernaR(i,1)/10,Registro.SCG.jPiernaR(i,2)/10,Registro.SCG.jPiernaR(i,3)/10,'g');
%     hold on;
%     quiver3(R_CCG(i,1),R_CCG(i,2),R_CCG(i,3),Registro.SCG.kPiernaR(i,1)/10,Registro.SCG.kPiernaR(i,2)/10,Registro.SCG.kPiernaR(i,3)/10,'b');
%     hold on;
% end;
% for i=1:20:length(p15)
%     quiver3(L_CCG(i,1),L_CCG(i,2),L_CCG(i,3),Registro.SCG.iPiernaL(i,1)/10,Registro.SCG.iPiernaL(i,2)/10,Registro.SCG.iPiernaL(i,3)/10,'r');
%     hold on;
%     quiver3(L_CCG(i,1),L_CCG(i,2),L_CCG(i,3),Registro.SCG.jPiernaL(i,1)/10,Registro.SCG.jPiernaL(i,2)/10,Registro.SCG.jPiernaL(i,3)/10,'g');
%     hold on;
%     quiver3(L_CCG(i,1),L_CCG(i,2),L_CCG(i,3),Registro.SCG.kPiernaL(i,1)/10,Registro.SCG.kPiernaL(i,2)/10,Registro.SCG.kPiernaL(i,3)/10,'b');
%     hold on;
% end;
% for i=1:20:length(p15)
%     quiver3(R_FCG(i,1),R_FCG(i,2),R_FCG(i,3),Registro.SCG.iPieR(i,1)/10,Registro.SCG.iPieR(i,2)/10,Registro.SCG.iPieR(i,3)/10,'r');
%     hold on;
%     quiver3(R_FCG(i,1),R_FCG(i,2),R_FCG(i,3),Registro.SCG.jPieR(i,1)/10,Registro.SCG.jPieR(i,2)/10,Registro.SCG.jPieR(i,3)/10,'g');
%     hold on;
%     quiver3(R_FCG(i,1),R_FCG(i,2),R_FCG(i,3),Registro.SCG.kPieR(i,1)/10,Registro.SCG.kPieR(i,2)/10,Registro.SCG.kPieR(i,3)/10,'b');
%     hold on;
% end;
% for i=1:20:length(p15)
%     quiver3(L_FCG(i,1),L_FCG(i,2),L_FCG(i,3),Registro.SCG.iPieL(i,1)/10,Registro.SCG.iPieL(i,2)/10,Registro.SCG.iPieL(i,3)/10,'r');
%     hold on;
%     quiver3(L_FCG(i,1),L_FCG(i,2),L_FCG(i,3),Registro.SCG.jPieL(i,1)/10,Registro.SCG.jPieL(i,2)/10,Registro.SCG.jPieL(i,3)/10,'g');
%     hold on;
%     quiver3(L_FCG(i,1),L_FCG(i,2),L_FCG(i,3),Registro.SCG.kPieL(i,1)/10,Registro.SCG.kPieL(i,2)/10,Registro.SCG.kPieL(i,3)/10,'b');
%     hold on;
% end;
% 
% legend('Marcador del Sacro','Centro de masa muslo derecho','Centro de masa muslo izquierdo','Centro de masa pierna derecha','Centro de masa pierna izquierda','Centro de masa del pie derecho','Centro de masa del pie izquierdo','i de pelvis','j de pelvis','k de pelvis','i de muslo izquierdo','j de muslo izquierdo','k de muslo izquierdo','i de pierna derecha','j de pierna derecha','k de pierna derecha','i de pierna izquierda','j de pierna izquierda','k de pierna izquierda','i de muslo derecho','j de muslo derecho','k de muslo derecho','i de pie derecho','j de pie derecho','k de pie derecho','i de pie izquierdo','j de pie izquierdo','k de pie izquierdo');
% xlabel('Eje X');
% ylabel('Eje Y');
% zlabel('Eje Z');
% title('Trayectoria de centros de masa y de i, j, k');
% grid on;
%% Calculo angulos de Euler
%Los calculo y los guardo en registro->aunguloeulerseno->angulo,seccion,RL
%                            registro->aunguloeulercoseno->angulo,seccion,RL
%Mi funcion devuelve todos los angulos calculados en una tupla, y la
%desempaqueto como corresponde.
%Pasar 1 en vez de 0 al final para graficar
graficar=0
[Registro.AnguloEulerSen.alfaMusloR, Registro.AnguloEulerSen.betaMusloR, Registro.AnguloEulerSen.gamaMusloR, Registro.AnguloEulerCos.alfaMusloR, Registro.AnguloEulerCos.betaMusloR, Registro.AnguloEulerCos.gamaMusloR] = anguloeuler(Registro.SCG.iMusloR,Registro.SCG.jMusloR,Registro.SCG.kMusloR, 'MusloR', graficar);

[Registro.AnguloEulerSen.alfaMusloL, Registro.AnguloEulerSen.betaMusloL, Registro.AnguloEulerSen.gamaMusloL, Registro.AnguloEulerCos.alfaMusloL, Registro.AnguloEulerCos.betaMusloL, Registro.AnguloEulerCos.gamaMusloL] = anguloeuler(Registro.SCG.iMusloL,Registro.SCG.jMusloL,Registro.SCG.kMusloL, 'MusloL', graficar);

[Registro.AnguloEulerSen.alfaPiernaR, Registro.AnguloEulerSen.betaPiernaR, Registro.AnguloEulerSen.gamaPiernaR, Registro.AnguloEulerCos.alfaPiernaR, Registro.AnguloEulerCos.betaPiernaR, Registro.AnguloEulerCos.gamaPiernaR] = anguloeuler(Registro.SCG.iPiernaR,Registro.SCG.jPiernaR,Registro.SCG.kPiernaR, 'PiernaR', graficar);

[Registro.AnguloEulerSen.alfaPiernaL, Registro.AnguloEulerSen.betaPiernaL, Registro.AnguloEulerSen.gamaPiernaL, Registro.AnguloEulerCos.alfaPiernaL, Registro.AnguloEulerCos.betaPiernaL, Registro.AnguloEulerCos.gamaPiernaL] = anguloeuler(Registro.SCG.iPiernaL,Registro.SCG.jPiernaL,Registro.SCG.kPiernaL, 'PiernaL', graficar);

[Registro.AnguloEulerSen.alfaPieR, Registro.AnguloEulerSen.betaPieR, Registro.AnguloEulerSen.gamaPieR, Registro.AnguloEulerCos.alfaPieR, Registro.AnguloEulerCos.betaPieR, Registro.AnguloEulerCos.gamaPieR] = anguloeuler(Registro.SCG.iPieR,Registro.SCG.jPieR,Registro.SCG.kPieR, 'PieR', graficar);

[Registro.AnguloEulerSen.alfaPieL, Registro.AnguloEulerSen.betaPieL, Registro.AnguloEulerSen.gamaPieL, Registro.AnguloEulerCos.alfaPieL, Registro.AnguloEulerCos.betaPieL, Registro.AnguloEulerCos.gamaPieL] = anguloeuler(Registro.SCG.iPieL,Registro.SCG.jPieL,Registro.SCG.kPieL, 'PieL', graficar);

[Registro.AnguloEulerSen.alfaPelvis, Registro.AnguloEulerSen.betaPelvis, Registro.AnguloEulerSen.gamaPelvis, Registro.AnguloEulerCos.alfaPelvis, Registro.AnguloEulerCos.betaPelvis, Registro.AnguloEulerCos.gamaPelvis] = anguloeuler(Registro.SCG.iPelvis,Registro.SCG.jPelvis,Registro.SCG.kPelvis, 'Pelvis', graficar);
%% Eleccion de angulos de Euler
% Me quedo con todos los COSENOS
% A los que tienen saltos les paso la correccion de 180 grados, y los que
% estan con upset les sumo o resto pi
Registro.AnguloEuler.alfaPelvis  = corr_ang180(Registro.AnguloEulerCos.alfaPelvis) - pi;
Registro.AnguloEuler.betaPelvis  = Registro.AnguloEulerCos.betaPelvis;
Registro.AnguloEuler.gamaPelvis = Registro.AnguloEulerCos.gamaPelvis;

Registro.AnguloEuler.alfaMusloR = (Registro.AnguloEulerCos.alfaMusloR);
Registro.AnguloEuler.betaMusloR = (Registro.AnguloEulerCos.betaMusloR);
Registro.AnguloEuler.gamaMusloR = (Registro.AnguloEulerCos.gamaMusloR);

Registro.AnguloEuler.alfaMusloL = (Registro.AnguloEulerCos.alfaMusloL) + pi;
Registro.AnguloEuler.betaMusloL = (Registro.AnguloEulerCos.betaMusloL);
Registro.AnguloEuler.gamaMusloL = (Registro.AnguloEulerCos.gamaMusloL);

Registro.AnguloEuler.alfaPiernaR = (Registro.AnguloEulerCos.alfaPiernaR);
Registro.AnguloEuler.betaPiernaR = (Registro.AnguloEulerCos.betaPiernaR);
Registro.AnguloEuler.gamaPiernaR = (Registro.AnguloEulerCos.gamaPiernaR);

Registro.AnguloEuler.alfaPiernaL = (Registro.AnguloEulerCos.alfaPiernaL)+ pi;
Registro.AnguloEuler.betaPiernaL = (Registro.AnguloEulerCos.betaPiernaL);
Registro.AnguloEuler.gamaPiernaL = (Registro.AnguloEulerCos.gamaPiernaL);


Registro.AnguloEuler.alfaPieR = (Registro.AnguloEulerCos.alfaPieR);
Registro.AnguloEuler.betaPieR = (Registro.AnguloEulerCos.betaPieR);
Registro.AnguloEuler.gamaPieR = (Registro.AnguloEulerCos.gamaPieR);

Registro.AnguloEuler.alfaPieL = (Registro.AnguloEulerCos.alfaPieL) + pi;
Registro.AnguloEuler.betaPieL = (Registro.AnguloEulerCos.betaPieL);
Registro.AnguloEuler.gamaPieL = (Registro.AnguloEulerCos.gamaPieL);
%% Derivadas angulos Eueler

Valores=fieldnames(Registro.AnguloEuler); %esta funcion esta buenisima
NumValores=length(Valores);

for NumVal=1:NumValores
    Val=char(Valores{NumVal});
    Cord=derivadaVectores(Registro.AnguloEuler.(sprintf('%s',Val)),1/fm);
    Registro.AnguloEulerDerivado.(sprintf('%s',Val))=Cord;

end;
%% Calculo de velocidades angulares

%Pelvis
[Registro.velocidadesAngulares.w0(:,1),Registro.velocidadesAngulares.w0(:,2),Registro.velocidadesAngulares.w0(:,3)]= velocidadangularsegmento(Registro.AnguloEuler.alfaPelvis, Registro.AnguloEulerDerivado.alfaPelvis, Registro.AnguloEuler.betaPelvis, Registro.AnguloEulerDerivado.betaPelvis, Registro.AnguloEuler.gamaPelvis, Registro.AnguloEulerDerivado.gamaPelvis);

%Muslo, pierna y pie derecho
[Registro.velocidadesAngulares.w1(:,1),Registro.velocidadesAngulares.w1(:,2),Registro.velocidadesAngulares.w1(:,3)]= velocidadangularsegmento(Registro.AnguloEuler.alfaMusloR, Registro.AnguloEulerDerivado.alfaMusloR, Registro.AnguloEuler.betaMusloR, Registro.AnguloEulerDerivado.betaMusloR, Registro.AnguloEuler.gamaMusloR, Registro.AnguloEulerDerivado.gamaMusloR);
[Registro.velocidadesAngulares.w3(:,1),Registro.velocidadesAngulares.w3(:,2),Registro.velocidadesAngulares.w3(:,3)]= velocidadangularsegmento(Registro.AnguloEuler.alfaPiernaR, Registro.AnguloEulerDerivado.alfaPiernaR, Registro.AnguloEuler.betaPiernaR, Registro.AnguloEulerDerivado.betaPiernaR, Registro.AnguloEuler.gamaPiernaR, Registro.AnguloEulerDerivado.gamaPiernaR);
[Registro.velocidadesAngulares.w5(:,1),Registro.velocidadesAngulares.w5(:,2),Registro.velocidadesAngulares.w5(:,3)]= velocidadangularsegmento(Registro.AnguloEuler.alfaPieR, Registro.AnguloEulerDerivado.alfaPieR, Registro.AnguloEuler.betaPieR, Registro.AnguloEulerDerivado.betaPieR, Registro.AnguloEuler.gamaPieR, Registro.AnguloEulerDerivado.gamaPieR);

%Muslo, pierna y pie izquierdo
[Registro.velocidadesAngulares.w2(:,1),Registro.velocidadesAngulares.w2(:,2),Registro.velocidadesAngulares.w2(:,3)]= velocidadangularsegmento(Registro.AnguloEuler.alfaMusloL, Registro.AnguloEulerDerivado.alfaMusloL, Registro.AnguloEuler.betaMusloL, Registro.AnguloEulerDerivado.betaMusloL, Registro.AnguloEuler.gamaMusloL, Registro.AnguloEulerDerivado.gamaMusloL);
[Registro.velocidadesAngulares.w4(:,1),Registro.velocidadesAngulares.w4(:,2),Registro.velocidadesAngulares.w4(:,3)]= velocidadangularsegmento(Registro.AnguloEuler.alfaPiernaL, Registro.AnguloEulerDerivado.alfaPiernaL, Registro.AnguloEuler.betaPiernaL, Registro.AnguloEulerDerivado.betaPiernaL, Registro.AnguloEuler.gamaPiernaL, Registro.AnguloEulerDerivado.gamaPiernaL);
[Registro.velocidadesAngulares.w6(:,1),Registro.velocidadesAngulares.w6(:,2),Registro.velocidadesAngulares.w6(:,3)]= velocidadangularsegmento(Registro.AnguloEuler.alfaPieL, Registro.AnguloEulerDerivado.alfaPieL, Registro.AnguloEuler.betaPieL, Registro.AnguloEulerDerivado.betaPieL, Registro.AnguloEuler.gamaPieL, Registro.AnguloEulerDerivado.gamaPieL);
%% Recorte de velocidades angulares
for i =1:3
Registro.velocidadesAngularesRec.w1(:,i) = InterpolaA100Muestras(Registro.velocidadesAngulares.w1(RHS1 - Inicio:RHS2 - Inicio,i));
Registro.velocidadesAngularesRec.w3(:,i) = InterpolaA100Muestras(Registro.velocidadesAngulares.w3(RHS1 - Inicio:RHS2 - Inicio,i));
Registro.velocidadesAngularesRec.w5(:,i) = InterpolaA100Muestras(Registro.velocidadesAngulares.w5(RHS1 - Inicio:RHS2 - Inicio,i));

Registro.velocidadesAngularesRec.w2(:,i) = InterpolaA100Muestras(Registro.velocidadesAngulares.w2(1:LHS2 - Inicio,i));
Registro.velocidadesAngularesRec.w4(:,i) = InterpolaA100Muestras(Registro.velocidadesAngulares.w4(1:LHS2 - Inicio,i));
Registro.velocidadesAngularesRec.w6(:,i) = InterpolaA100Muestras(Registro.velocidadesAngulares.w6(1:LHS2 - Inicio,i));
end;
%% Grafica velocidades angulares(radianes/s)
figure;
subplot(3,3,1), plot(Registro.velocidadesAngularesRec.w1(:,1),'g'),hold on,plot(Registro.velocidadesAngularesRec.w2(:,1),'r'),hold on, title('Muslo en x'), grid on,xlabel('%CM', 'FontSize',8), ylabel('rad/seg'),zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,2), plot(Registro.velocidadesAngularesRec.w1(:,2),'g'),hold on,plot(Registro.velocidadesAngularesRec.w2(:,2),'r'),hold on, title('Muslo en y'), grid on,xlabel('%CM', 'FontSize',8), zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,3), plot(Registro.velocidadesAngularesRec.w1(:,3),'g'),hold on,plot(Registro.velocidadesAngularesRec.w2(:,3),'r'),hold on, title('Muslo en z'), grid on,xlabel('%CM', 'FontSize',8), zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,4), plot(Registro.velocidadesAngularesRec.w3(:,1),'g'),hold on,plot(Registro.velocidadesAngularesRec.w4(:,1),'r'),hold on, title('Pierna en x'), grid on,xlabel('%CM', 'FontSize',8), ylabel('rad/seg'),zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,5), plot(Registro.velocidadesAngularesRec.w3(:,2),'g'),hold on,plot(Registro.velocidadesAngularesRec.w4(:,2),'r'),hold on, title('Pierna en y'), grid on,xlabel('%CM', 'FontSize',8), zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,6), plot(Registro.velocidadesAngularesRec.w3(:,3),'g'),hold on,plot(Registro.velocidadesAngularesRec.w4(:,3),'r'),hold on, title('Pierna en z'), grid on,xlabel('%CM', 'FontSize',8), zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,7), plot(Registro.velocidadesAngularesRec.w5(:,1),'g'),hold on,plot(Registro.velocidadesAngularesRec.w6(:,1),'r'),hold on, title('Pie en x'), grid on,xlabel('%CM', 'FontSize',8), ylabel('rad/seg'),zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,8), plot(Registro.velocidadesAngularesRec.w5(:,2),'g'),hold on,plot(Registro.velocidadesAngularesRec.w6(:,2),'r'),hold on, title('Pie en y'), grid on,xlabel('%CM', 'FontSize',8), zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,9), plot(Registro.velocidadesAngularesRec.w5(:,3),'g'),hold on,plot(Registro.velocidadesAngularesRec.w6(:,3),'r'),hold on, title('Pie en z'), grid on,xlabel('%CM', 'FontSize',8), zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
%% Grafica velocidades angulares(grados/s)

figure;
subplot(3,3,1), plot(Registro.velocidadesAngularesRec.w1(:,1)*180/pi,'g'),hold on,plot(Registro.velocidadesAngularesRec.w2(:,1)*180/pi,'r'),hold on, title('Muslo en x'), grid on,xlabel('%CM', 'FontSize',8), ylabel('[°/seg]'),zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,2), plot(Registro.velocidadesAngularesRec.w1(:,2)*180/pi,'g'),hold on,plot(Registro.velocidadesAngularesRec.w2(:,2)*180/pi,'r'),hold on, title('Muslo en y'), grid on,xlabel('%CM', 'FontSize',8), zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,3), plot(Registro.velocidadesAngularesRec.w1(:,3)*180/pi,'g'),hold on,plot(Registro.velocidadesAngularesRec.w2(:,3)*180/pi,'r'),hold on, title('Muslo en z'), grid on,xlabel('%CM', 'FontSize',8), zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,4), plot(Registro.velocidadesAngularesRec.w3(:,1)*180/pi,'g'),hold on,plot(Registro.velocidadesAngularesRec.w4(:,1)*180/pi,'r'),hold on, title('Pierna en x'), grid on,xlabel('%CM', 'FontSize',8), ylabel('[°/seg]'),zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,5), plot(Registro.velocidadesAngularesRec.w3(:,2)*180/pi,'g'),hold on,plot(Registro.velocidadesAngularesRec.w4(:,2)*180/pi,'r'),hold on, title('Pierna en y'), grid on,xlabel('%CM', 'FontSize',8), zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,6), plot(Registro.velocidadesAngularesRec.w3(:,3)*180/pi,'g'),hold on,plot(Registro.velocidadesAngularesRec.w4(:,3)*180/pi,'r'),hold on, title('Pierna en z'), grid on,xlabel('%CM', 'FontSize',8), zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,7), plot(Registro.velocidadesAngularesRec.w5(:,1)*180/pi,'g'),hold on,plot(Registro.velocidadesAngularesRec.w6(:,1)*180/pi,'r'),hold on, title('Pie en x'), grid on,xlabel('%CM', 'FontSize',8), ylabel('[°/seg]'),zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,8), plot(Registro.velocidadesAngularesRec.w5(:,2)*180/pi,'g'),hold on,plot(Registro.velocidadesAngularesRec.w6(:,2)*180/pi,'r'),hold on, title('Pie en y'), grid on,xlabel('%CM', 'FontSize',8), zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,9), plot(Registro.velocidadesAngularesRec.w5(:,3)*180/pi,'g'),hold on,plot(Registro.velocidadesAngularesRec.w6(:,3)*180/pi,'r'),hold on, title('Pie en z'), grid on,xlabel('%CM', 'FontSize',8), zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
%% Masa de segmentos
Registro.MasaSegmentos.MasaMuslo.Valor = -2.649+0.1463*A1+0.0137*Altura;
Registro.MasaSegmentos.MasaPierna.Valor = -1.592+0.0362*A1+0.0121*Altura;
Registro.MasaSegmentos.MasaPie.Valor = -0.829+0.0077*A1+0.0073*Altura;

Registro.MasaSegmentos.MasaMuslo.Unidad = 'kg';
Registro.MasaSegmentos.MasaPierna.Unidad = 'kg';
Registro.MasaSegmentos.MasaPie.Unidad = 'kg';
%% Calculo de aceleracion lineal de segmentos
%Muslo derecho e izquierdo (hago la derivada 2 veces)
Registro.Aceleracion.R_TCG=derivadaVectores(derivadaVectores(R_TCG,1/fm),1/fm);
Registro.Aceleracion.L_TCG=derivadaVectores(derivadaVectores(L_TCG,1/fm),1/fm);

% %Pierna derecha e izquierda
Registro.Aceleracion.R_CCG=derivadaVectores(derivadaVectores(R_CCG,1/fm),1/fm);
Registro.Aceleracion.L_CCG=derivadaVectores(derivadaVectores(L_CCG,1/fm),1/fm);

% %Pie derecho e izquierdo
Registro.Aceleracion.R_FCG=derivadaVectores(derivadaVectores(R_FCG,1/fm),1/fm);
Registro.Aceleracion.L_FCG=derivadaVectores(derivadaVectores(L_FCG,1/fm),1/fm);
%% Calculo de matrices de inercia

%Muslo
Registro.MatricesInercia.Muslo.Ixx=(-13.5+11.3*A1-2.28*Altura)/10000;
Registro.MatricesInercia.Muslo.Iyy=(-3557+31.7*A1+18.61*Altura)/10000;
Registro.MatricesInercia.Muslo.Izz=(-3690+32.02*A1+19.24*Altura)/10000;

%Pierna
Registro.MatricesInercia.Pierna.Ixx=(-70.5+1.134*A1+0.3*Altura)/10000;
Registro.MatricesInercia.Pierna.Iyy=(-1105+4.59*A1+6.63*Altura)/10000;
Registro.MatricesInercia.Pierna.Izz=(-1152+4.594*A1+6.815*Altura)/10000;

%Pie
Registro.MatricesInercia.Pie.Ixx=(-15.48+0.144*A1+0.088*Altura)/10000;
Registro.MatricesInercia.Pie.Iyy=(-100+0.480*A1+0.626*Altura)/10000;
Registro.MatricesInercia.Pie.Izz=(-97.09+0.414*A1+0.614*Altura)/10000;
%% Calculo de cantidad de movimiento angular

%Muslo derecho
Registro.CantMovAngular.H1x = Registro.MatricesInercia.Muslo.Ixx*Registro.velocidadesAngulares.w1(:,1);
Registro.CantMovAngular.H1y = Registro.MatricesInercia.Muslo.Iyy*Registro.velocidadesAngulares.w1(:,2);
Registro.CantMovAngular.H1z = Registro.MatricesInercia.Muslo.Izz*Registro.velocidadesAngulares.w1(:,3);

%Muslo izquierdo
Registro.CantMovAngular.H2x = Registro.MatricesInercia.Muslo.Ixx*Registro.velocidadesAngulares.w2(:,1);
Registro.CantMovAngular.H2y = Registro.MatricesInercia.Muslo.Iyy*Registro.velocidadesAngulares.w2(:,2);
Registro.CantMovAngular.H2z = Registro.MatricesInercia.Muslo.Izz*Registro.velocidadesAngulares.w2(:,3);

%Pierna derecha
Registro.CantMovAngular.H3x = Registro.MatricesInercia.Pierna.Ixx*Registro.velocidadesAngulares.w3(:,1);
Registro.CantMovAngular.H3y = Registro.MatricesInercia.Pierna.Iyy*Registro.velocidadesAngulares.w3(:,2);
Registro.CantMovAngular.H3z = Registro.MatricesInercia.Pierna.Izz*Registro.velocidadesAngulares.w3(:,3);

%Pierna izquierda
Registro.CantMovAngular.H4x = Registro.MatricesInercia.Pierna.Ixx*Registro.velocidadesAngulares.w4(:,1);
Registro.CantMovAngular.H4y = Registro.MatricesInercia.Pierna.Iyy*Registro.velocidadesAngulares.w4(:,2);
Registro.CantMovAngular.H4z = Registro.MatricesInercia.Pierna.Izz*Registro.velocidadesAngulares.w4(:,3);

%Pie derecho
Registro.CantMovAngular.H5x = Registro.MatricesInercia.Pie.Ixx*Registro.velocidadesAngulares.w5(:,1);
Registro.CantMovAngular.H5y = Registro.MatricesInercia.Pie.Iyy*Registro.velocidadesAngulares.w5(:,2);
Registro.CantMovAngular.H5z = Registro.MatricesInercia.Pie.Izz*Registro.velocidadesAngulares.w5(:,3);

%Pie izquierda
Registro.CantMovAngular.H6x = Registro.MatricesInercia.Pie.Ixx*Registro.velocidadesAngulares.w6(:,1);
Registro.CantMovAngular.H6y = Registro.MatricesInercia.Pie.Iyy*Registro.velocidadesAngulares.w6(:,2);
Registro.CantMovAngular.H6z = Registro.MatricesInercia.Pie.Izz*Registro.velocidadesAngulares.w6(:,3);
%% Derivada cantidad de movimiento (momento angular)

Valores=fieldnames(Registro.CantMovAngular);
NumValores=length(Valores);

for NumVal=1:NumValores
    Val=char(Valores{NumVal});
    Cord=derivadaVectores(Registro.CantMovAngular.(sprintf('%s',Val)),1/fm);
    Registro.CantMovAngularDerivado.(sprintf('%s',Val))=Cord;

end;
%% Carga de datos de fuerzas y momentos 
%Fuerzas 

Registro.Fuerzas.FuerzaR(:,1) = Registro.Pasada.Fuerzas.Plataforma2.Valores.Fx2(Inicio:Fin,:);
Registro.Fuerzas.FuerzaR(:,2) = Registro.Pasada.Fuerzas.Plataforma2.Valores.Fy2(Inicio:Fin,:);
Registro.Fuerzas.FuerzaR(:,3) = Registro.Pasada.Fuerzas.Plataforma2.Valores.Fz2(Inicio:Fin,:);

Registro.Fuerzas.FuerzaL(:,1) = Registro.Pasada.Fuerzas.Plataforma1.Valores.Fx1(Inicio:Fin,:);
Registro.Fuerzas.FuerzaL(:,2) = Registro.Pasada.Fuerzas.Plataforma1.Valores.Fy1(Inicio:Fin,:);
Registro.Fuerzas.FuerzaL(:,3) = Registro.Pasada.Fuerzas.Plataforma1.Valores.Fz1(Inicio:Fin,:);

%Momento

Registro.Momento.MomentoR(:,1) = Registro.Pasada.Fuerzas.Plataforma2.Valores.Mx2(Inicio:Fin,:)/1000;
Registro.Momento.MomentoR(:,2) = Registro.Pasada.Fuerzas.Plataforma2.Valores.My2(Inicio:Fin,:)/1000;
Registro.Momento.MomentoR(:,3) = Registro.Pasada.Fuerzas.Plataforma2.Valores.Mz2(Inicio:Fin,:)/1000;

Registro.Momento.MomentoL(:,1) = Registro.Pasada.Fuerzas.Plataforma1.Valores.Mx1(Inicio:Fin,:)/1000;
Registro.Momento.MomentoL(:,2) = Registro.Pasada.Fuerzas.Plataforma1.Valores.My1(Inicio:Fin,:)/1000;
Registro.Momento.MomentoL(:,3) = Registro.Pasada.Fuerzas.Plataforma1.Valores.Mz1(Inicio:Fin,:)/1000;

%Centros de presión

Registro.CentrosDePresion.CPR=Registro.Pasada.Marcadores.Crudos.Valores.rGr(Inicio:Fin,:);
Registro.CentrosDePresion.CPL=Registro.Pasada.Marcadores.Crudos.Valores.lGr(Inicio:Fin,:);
%% Filtrado de Fuerzas 

%ME FIJO A MANO DONDE ES NAN

%LOS MIOS
for i =1:3
   Registro.Momento.MomentoR(1:179,i) = 0
   Registro.Momento.MomentoR(390:518,i) = 0
   Registro.Momento.MomentoL(1:12,i) = 0
   Registro.Momento.MomentoL(218:518,i) = 0
   Registro.CentrosDePresion.CPR(1:179,i) = 0
   Registro.CentrosDePresion.CPR(390:518,i) = 0
   Registro.CentrosDePresion.CPL(1:12,i) = 0
   Registro.CentrosDePresion.CPL(218:518,i) = 0
end;
%LOS DE JUSTO
% for i =1:3
%    Registro.Momento.MomentoR(1:192,i) = 0
%    Registro.Momento.MomentoR(413:549,i) = 0
%    Registro.Momento.MomentoL(1:12,i) = 0
%    Registro.Momento.MomentoL(230:549,i) = 0
%    Registro.CentrosDePresion.CPR(1:192,i) = 0
%    Registro.CentrosDePresion.CPR(413:549,i) = 0
%    Registro.CentrosDePresion.CPL(1:12,i) = 0
%    Registro.CentrosDePresion.CPL(230:549,i) = 0
% end;
Registro.CentrosDePresion.CPL(:,3) = 0
Registro.CentrosDePresion.CPR(:,3) = 0

fe = fm/2      %frec de Nyquist
wn = 10/fe     %frecuencia de corte 10Hz
[B,A] = butter(2,wn)   %filtro

 for i =1:3
Registro.Fuerzas.FuerzaR(:,i) = filtfilt(B, A, Registro.Fuerzas.FuerzaR(:,i));
Registro.Fuerzas.FuerzaL(:,i) = filtfilt(B, A, Registro.Fuerzas.FuerzaL(:,i));
Registro.Momento.MomentoR(:,i) = filtfilt(B, A, Registro.Momento.MomentoR(:,i));
Registro.Momento.MomentoL(:,i) = filtfilt(B, A, Registro.Momento.MomentoL(:,i));
Registro.CentrosDePresion.CPR(:,i) = filtfilt(B, A, Registro.CentrosDePresion.CPR(:,i));
Registro.CentrosDePresion.CPL(:,i) = filtfilt(B, A, Registro.CentrosDePresion.CPL(:,i));

end;

for i =1:3
   Registro.Momento.MomentoR(:,1) = 0
   Registro.Momento.MomentoR(:,2) = 0
   Registro.Momento.MomentoL(:,1) = 0
   Registro.Momento.MomentoL(:,2) = 0
   Registro.Momento.MomentoR(1:179,i) = 0
   Registro.Momento.MomentoR(390:518,i) = 0
   Registro.Momento.MomentoL(1:12,i) = 0
   Registro.Momento.MomentoL(218:518,i) = 0
   Registro.CentrosDePresion.CPR(1:179,i) = 0
   Registro.CentrosDePresion.CPR(390:518,i) = 0
   Registro.CentrosDePresion.CPL(1:12,i) = 0
   Registro.CentrosDePresion.CPL(218:518,i) = 0
   Registro.Fuerzas.FuerzaR(1:179,i) = 0
   Registro.Fuerzas.FuerzaR(390:518,i) = 0
   Registro.Fuerzas.FuerzaL(1:12,i) = 0
   Registro.Fuerzas.FuerzaL(218:518,i) = 0
end;


% figure;
% title('Prueba grafica CDP');
% subplot(3,1,1), plot(Registro.CentrosDePresion.CPR(:,1) ,'g'),hold on, plot(Registro.CentrosDePresion.CPL(:,1) ,'r'),hold on,title('CP'),xlabel('%CM'), ylabel('W/Kg'), grid on, zoom;
% subplot(3,1,2), plot(Registro.CentrosDePresion.CPR(:,2) ,'g'),hold on, plot(Registro.CentrosDePresion.CPL(:,2) ,'r'),hold on,title('CP'), xlabel('%CM'),ylabel('W/Kg'), grid on, zoom;
% subplot(3,1,3), plot(Registro.CentrosDePresion.CPR(:,3) ,'g'),hold on, plot(Registro.CentrosDePresion.CPL(:,3) ,'r'),hold on,title('CP'), xlabel('%CM'),ylabel('W/Kg'), grid on, zoom;

% Registro.CentrosDePresion.CPL(:,2) = -Registro.CentrosDePresion.CPL(:,2)
%% calculo de fuerzas para cada segmento 

% Tobillo, rodilla y cadera derecha

[Registro.FuerzaSeg.TobilloR(:,1), Registro.FuerzaSeg.TobilloR(:,2), Registro.FuerzaSeg.TobilloR(:,3)] = calculofuerzas (Registro.MasaSegmentos.MasaPie.Valor, Registro.Aceleracion.R_FCG, Registro.Fuerzas.FuerzaR(:,1), Registro.Fuerzas.FuerzaR(:,2),Registro.Fuerzas.FuerzaR(:,3));

Registro.FuerzasSL.iTobilloR = dot(Registro.FuerzaSeg.TobilloR,Registro.SCG.iPieR,2) %%paso a ejes anatomicos
Registro.FuerzasSL.jTobilloR = dot(Registro.FuerzaSeg.TobilloR,iTobilloR,2)
Registro.FuerzasSL.kTobilloR = dot(Registro.FuerzaSeg.TobilloR,Registro.SCG.kPiernaR,2)

[Registro.FuerzaSeg.RodillaR(:,1), Registro.FuerzaSeg.RodillaR(:,2), Registro.FuerzaSeg.RodillaR(:,3)] = calculofuerzas (Registro.MasaSegmentos.MasaPierna.Valor, Registro.Aceleracion.R_CCG, -Registro.FuerzaSeg.TobilloR(:,1), -Registro.FuerzaSeg.TobilloR(:,2),-Registro.FuerzaSeg.TobilloR(:,3))

Registro.FuerzasSL.iRodillaR = dot(Registro.FuerzaSeg.RodillaR,Registro.SCG.iPiernaR,2) %%paso a ejes anatomicos
Registro.FuerzasSL.jRodillaR = dot(Registro.FuerzaSeg.RodillaR,iRodillaR,2)
Registro.FuerzasSL.kRodillaR = dot(Registro.FuerzaSeg.RodillaR,Registro.SCG.kMusloR,2)

[Registro.FuerzaSeg.CaderaR(:,1), Registro.FuerzaSeg.CaderaR(:,2), Registro.FuerzaSeg.CaderaR(:,3)] = calculofuerzas (Registro.MasaSegmentos.MasaMuslo.Valor, Registro.Aceleracion.R_TCG,-Registro.FuerzaSeg.RodillaR(:,1), -Registro.FuerzaSeg.RodillaR(:,2),-Registro.FuerzaSeg.RodillaR(:,3))

Registro.FuerzasSL.iCaderaR = dot(Registro.FuerzaSeg.CaderaR,Registro.SCG.iPiernaR,2) %%paso a ejes anatomicos
Registro.FuerzasSL.jCaderaR = dot(Registro.FuerzaSeg.CaderaR,iCaderaR,2)
Registro.FuerzasSL.kCaderaR = dot(Registro.FuerzaSeg.CaderaR,Registro.SCG.kPelvis,2)

% Tobillo, rodilla y cadera izquierda

[Registro.FuerzaSeg.TobilloL(:,1), Registro.FuerzaSeg.TobilloL(:,2), Registro.FuerzaSeg.TobilloL(:,3)] = calculofuerzas (Registro.MasaSegmentos.MasaPie.Valor, Registro.Aceleracion.L_FCG, Registro.Fuerzas.FuerzaL(:,1), Registro.Fuerzas.FuerzaL(:,2),Registro.Fuerzas.FuerzaL(:,3))
 
Registro.FuerzasSL.iTobilloL = dot(Registro.FuerzaSeg.TobilloL,Registro.SCG.iPieL,2) %%paso a ejes anatomicos
Registro.FuerzasSL.jTobilloL = dot(Registro.FuerzaSeg.TobilloL,iTobilloL,2)
Registro.FuerzasSL.kTobilloL = dot(Registro.FuerzaSeg.TobilloL,-Registro.SCG.kPiernaL,2)

[Registro.FuerzaSeg.RodillaL(:,1), Registro.FuerzaSeg.RodillaL(:,2), Registro.FuerzaSeg.RodillaL(:,3)] = calculofuerzas (Registro.MasaSegmentos.MasaPierna.Valor, Registro.Aceleracion.L_CCG, -Registro.FuerzaSeg.TobilloL(:,1), -Registro.FuerzaSeg.TobilloL(:,2),-Registro.FuerzaSeg.TobilloL(:,3))
 
Registro.FuerzasSL.iRodillaL = dot(Registro.FuerzaSeg.RodillaL,Registro.SCG.iPiernaL,2) %%paso a ejes anatomicos
Registro.FuerzasSL.jRodillaL = dot(Registro.FuerzaSeg.RodillaL,iRodillaL,2)
Registro.FuerzasSL.kRodillaL = dot(Registro.FuerzaSeg.RodillaL,-Registro.SCG.kMusloL,2)

[Registro.FuerzaSeg.CaderaL(:,1), Registro.FuerzaSeg.CaderaL(:,2), Registro.FuerzaSeg.CaderaL(:,3)] = calculofuerzas (Registro.MasaSegmentos.MasaMuslo.Valor, Registro.Aceleracion.L_TCG, -Registro.FuerzaSeg.RodillaL(:,1), -Registro.FuerzaSeg.RodillaL(:,2),-Registro.FuerzaSeg.RodillaL(:,3))
 
Registro.FuerzasSL.iCaderaL = dot(Registro.FuerzaSeg.CaderaL,Registro.SCG.iPiernaL,2) %%paso a ejes anatomicos
Registro.FuerzasSL.jCaderaL = dot(Registro.FuerzaSeg.CaderaL,iCaderaL,2)
Registro.FuerzasSL.kCaderaL = dot(Registro.FuerzaSeg.CaderaL,-Registro.SCG.kPelvis,2)
%% Recorte y normalización de fuerzas articulares

Valores=fieldnames(Registro.FuerzasSL);
NumValores=length(Valores);

for NumVal=1:(NumValores/2)
    Val=char(Valores{NumVal});
    [Cord] = InterpolaA100Muestras(Registro.FuerzasSL.(sprintf('%s',Val))(RHS1 - Inicio:RHS2 - Inicio))/A1
    Registro.FuerzasSL.(sprintf('%s',Val)) = Cord
  
end;

for NumVal=(NumValores/2+1):NumValores
    Val=char(Valores{NumVal});    
    [Cord] = InterpolaA100Muestras(Registro.FuerzasSL.(sprintf('%s',Val))(1:LHS2 - Inicio))/A1
    Registro.FuerzasSL.(sprintf('%s',Val)) = Cord
end;
% 
figure;
%%suptitle('Fuerzas en ejes anatomicos');
subplot(3,3,7), plot(Registro.FuerzasSL.kTobilloR,'g'),hold on,plot(Registro.FuerzasSL.kTobilloL,'r'),hold on,title('Fuerza Tobillo [N/kg]'),xlabel('%CM'), ylabel('Lateral(-) - Medial(+)'), grid on, zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,8), plot(Registro.FuerzasSL.jTobilloR,'g'),hold on,plot(Registro.FuerzasSL.jTobilloL,'r'),hold on,title('Fuerza Tobillo [N/kg]'),xlabel('%CM'), ylabel('Posterior(-) - Anterior(+)'), grid on, zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,9), plot(Registro.FuerzasSL.iTobilloR,'g'),hold on,plot(Registro.FuerzasSL.iTobilloL,'r'),hold on,title('Fuerza Tobillo [N/kg]'),xlabel('%CM'), ylabel('Distal(-) - Proximal(+)'), grid on, zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,4), plot(Registro.FuerzasSL.kRodillaR,'g'),hold on,plot(Registro.FuerzasSL.kRodillaL,'r'),hold on,title('Fuerza Rodilla [N/kg]'),xlabel('%CM'), ylabel('Lateral(-) - Medial(+)'), grid on, zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,5), plot(Registro.FuerzasSL.jRodillaR,'g'),hold on,plot(Registro.FuerzasSL.jRodillaL,'r'),hold on,title('Fuerza Rodilla [N/kg]'),xlabel('%CM'), ylabel('Posterior(-) - Anterior(+)'), grid on, zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,6), plot(Registro.FuerzasSL.iRodillaR,'g'),hold on,plot(Registro.FuerzasSL.iRodillaL,'r'),hold on,title('Fuerza Rodilla [N/kg]'),xlabel('%CM'), ylabel('Distal(-) - Proximal(+)'), grid on, zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,1), plot(Registro.FuerzasSL.kCaderaR,'g'),hold on,plot(Registro.FuerzasSL.kCaderaL,'r'),hold on, title('Fuerza Cadera [N/kg]'),xlabel('%CM'),ylabel('Lateral(-) - Medial(+)'), grid on, zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,2), plot(Registro.FuerzasSL.jCaderaR,'g'),hold on,plot(Registro.FuerzasSL.jCaderaL,'r'),hold on, title('Fuerza Cadera [N/kg]'),xlabel('%CM'),ylabel('Posterior(-) - Anterior(+)'), grid on, zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,3), plot(Registro.FuerzasSL.iCaderaR,'g'),hold on,plot(Registro.FuerzasSL.iCaderaL,'r'),hold on, title('Fuerza Cadera [N/kg]'),xlabel('%CM'), ylabel('Distal(-) - Proximal(+)'), grid on, zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
%% Cálculo de Momentos 
%% tobillo

%Tobillo derecho
DisProximal.Pie.R = R_AJC - R_FCG

DisDistal.Pie.R = Registro.CentrosDePresion.CPR - R_FCG
mod1= calculaModulo(DisDistal.Pie.R)
DisDistal.Pie.R(:,2) = DisDistal.Pie.R(:,2) - 0.002
Registro.MomentoResidual.PieR = Registro.Momento.MomentoR + cross(DisProximal.Pie.R,Registro.FuerzaSeg.TobilloR) + cross(DisDistal.Pie.R,Registro.Fuerzas.FuerzaR)

Registro.Momento.PieR(:,1) =  Registro.CantMovAngularDerivado.H5x - dot(Registro.SCG.iPieR,Registro.MomentoResidual.PieR,2)
Registro.Momento.PieR(:,2) =  Registro.CantMovAngularDerivado.H5y - dot(Registro.SCG.jPieR,Registro.MomentoResidual.PieR,2)
Registro.Momento.PieR(:,3) =  Registro.CantMovAngularDerivado.H5z - dot(Registro.SCG.kPieR,Registro.MomentoResidual.PieR,2)


Registro.MomentoGlobal.PieR = delocalaglobal(Registro.SCG.iPieR,Registro.SCG.jPieR,Registro.SCG.kPieR,Registro.Momento.PieR)

MomentoAnatomico.PieRx = dot(Registro.MomentoGlobal.PieR,Registro.SCG.iPieR,2) %%paso a ejes anatomicos
MomentoAnatomico.PieRy = dot(Registro.MomentoGlobal.PieR,Registro.SCG.kPiernaR,2)
MomentoAnatomico.PieRz = dot(Registro.MomentoGlobal.PieR,iTobilloR,2) %segun apunte negativo

MomentoAnatomico.PieRx = InterpolaA100Muestras(MomentoAnatomico.PieRx(RHS1 - Inicio:RHS2 - Inicio))/A1
MomentoAnatomico.PieRy = InterpolaA100Muestras(MomentoAnatomico.PieRy(RHS1 - Inicio:RHS2 - Inicio))/A1
MomentoAnatomico.PieRz = InterpolaA100Muestras(MomentoAnatomico.PieRz(RHS1 - Inicio:RHS2 - Inicio))/A1


%Tobillo izquierdo
DisProximal.Pie.L = L_AJC - L_FCG
% DisProximal.Pie.L(:,2) = -DisProximal.Pie.L(:,2)  
DisDistal.Pie.L = Registro.CentrosDePresion.CPL - L_FCG
DisDistal.Pie.L(:,2) = DisDistal.Pie.L(:,2) + 0.03  

mod2= calculaModulo(DisDistal.Pie.L)
Registro.MomentoResidual.PieL = Registro.Momento.MomentoL + cross(DisProximal.Pie.L,Registro.FuerzaSeg.TobilloL) + cross(DisDistal.Pie.L,Registro.Fuerzas.FuerzaL)

Registro.Momento.PieL(:,1) =  Registro.CantMovAngularDerivado.H6x - dot(Registro.SCG.iPieL,Registro.MomentoResidual.PieL,2)
Registro.Momento.PieL(:,2) =  Registro.CantMovAngularDerivado.H6y - dot(Registro.SCG.jPieL,Registro.MomentoResidual.PieL,2)
Registro.Momento.PieL(:,3) =  Registro.CantMovAngularDerivado.H6z - dot(Registro.SCG.kPieL,Registro.MomentoResidual.PieL,2)


Registro.MomentoGlobal.PieL = delocalaglobal(Registro.SCG.iPieL,Registro.SCG.jPieL,Registro.SCG.kPieL,Registro.Momento.PieL)

MomentoAnatomico.PieLx = dot(Registro.MomentoGlobal.PieL,-Registro.SCG.iPieL,2) %%supuestamente negativo
MomentoAnatomico.PieLy = dot(Registro.MomentoGlobal.PieL,Registro.SCG.kPiernaL,2)
MomentoAnatomico.PieLz = dot(Registro.MomentoGlobal.PieL,-iTobilloL,2)

MomentoAnatomico.PieLx = InterpolaA100Muestras(MomentoAnatomico.PieLx(1:LHS2 - Inicio)/A1)
MomentoAnatomico.PieLy = InterpolaA100Muestras(MomentoAnatomico.PieLy(1:LHS2 - Inicio)/A1)
MomentoAnatomico.PieLz = InterpolaA100Muestras(MomentoAnatomico.PieLz(1:LHS2 - Inicio)/A1)
%% rodilla 

% %Rodilla derecha
DisProximal.Pierna.R = R_KJC - R_CCG
DisDistal.Pierna.R = R_AJC - R_CCG

Registro.MomentoResidual.PiernaR =  -Registro.MomentoGlobal.PieR + cross(DisProximal.Pierna.R,Registro.FuerzaSeg.RodillaR) - cross(DisDistal.Pierna.R,Registro.FuerzaSeg.TobilloR) 

Registro.Momento.PiernaR(:,1) =  Registro.CantMovAngularDerivado.H3x - dot(Registro.SCG.iPiernaR,Registro.MomentoResidual.PiernaR,2)
Registro.Momento.PiernaR(:,2) =  Registro.CantMovAngularDerivado.H3y - dot(Registro.SCG.jPiernaR,Registro.MomentoResidual.PiernaR,2)
Registro.Momento.PiernaR(:,3) =  Registro.CantMovAngularDerivado.H3z - dot(Registro.SCG.kPiernaR,Registro.MomentoResidual.PiernaR,2)

Registro.MomentoGlobal.PiernaR = delocalaglobal(Registro.SCG.iPiernaR,Registro.SCG.jPiernaR,Registro.SCG.kPiernaR,Registro.Momento.PiernaR)

MomentoAnatomico.PiernaRx = dot(Registro.MomentoGlobal.PiernaR,Registro.SCG.iPiernaR,2) %%paso a ejes anatomicos
MomentoAnatomico.PiernaRy = dot(Registro.MomentoGlobal.PiernaR,Registro.SCG.kMusloR,2)
MomentoAnatomico.PiernaRz = dot(Registro.MomentoGlobal.PiernaR,iRodillaR,2) %segun apunte es negativo

MomentoAnatomico.PiernaRx = InterpolaA100Muestras(MomentoAnatomico.PiernaRx(RHS1 - Inicio:RHS2 - Inicio))/A1
MomentoAnatomico.PiernaRy = InterpolaA100Muestras(MomentoAnatomico.PiernaRy(RHS1 - Inicio:RHS2 - Inicio))/A1
MomentoAnatomico.PiernaRz = InterpolaA100Muestras(MomentoAnatomico.PiernaRz(RHS1 - Inicio:RHS2 - Inicio))/A1


% %Rodilla izquierda
DisProximal.Pierna.L = L_KJC - L_CCG
DisDistal.Pierna.L = L_AJC - L_CCG

Registro.MomentoResidual.PiernaL =  - Registro.MomentoGlobal.PieL + cross(DisProximal.Pierna.L,Registro.FuerzaSeg.RodillaL) - cross(DisDistal.Pierna.L,Registro.FuerzaSeg.TobilloL)

Registro.Momento.PiernaL(:,1) =  Registro.CantMovAngularDerivado.H4x - dot(Registro.SCG.iPiernaL,Registro.MomentoResidual.PiernaL,2)
Registro.Momento.PiernaL(:,2) =  Registro.CantMovAngularDerivado.H4y - dot(Registro.SCG.jPiernaL,Registro.MomentoResidual.PiernaL,2)
Registro.Momento.PiernaL(:,3) =  Registro.CantMovAngularDerivado.H4z - dot(Registro.SCG.kPiernaL,Registro.MomentoResidual.PiernaL,2)

Registro.MomentoGlobal.PiernaL = delocalaglobal(Registro.SCG.iPiernaL,Registro.SCG.jPiernaL,Registro.SCG.kPiernaL,Registro.Momento.PiernaL)

MomentoAnatomico.PiernaLx = dot(Registro.MomentoGlobal.PiernaL,-Registro.SCG.iPiernaL,2) %segun apunte es negativo
MomentoAnatomico.PiernaLy = dot(Registro.MomentoGlobal.PiernaL,Registro.SCG.kMusloL,2)
MomentoAnatomico.PiernaLz = dot(Registro.MomentoGlobal.PiernaL,-iRodillaL,2)

MomentoAnatomico.PiernaLx = InterpolaA100Muestras(MomentoAnatomico.PiernaLx(1:LHS2 - Inicio)/A1)
MomentoAnatomico.PiernaLy = InterpolaA100Muestras(MomentoAnatomico.PiernaLy(1:LHS2 - Inicio)/A1)
MomentoAnatomico.PiernaLz = InterpolaA100Muestras(MomentoAnatomico.PiernaLz(1:LHS2 - Inicio)/A1)
%% cadera 

%Cadera derecho
DisProximal.Muslo.R = R_HJC - R_TCG
DisDistal.Muslo.R = R_KJC - R_TCG

Registro.MomentoResidual.MusloR = - Registro.MomentoGlobal.PiernaR - cross(DisDistal.Muslo.R,Registro.FuerzaSeg.RodillaR) + cross(DisProximal.Muslo.R,Registro.FuerzaSeg.CaderaR)

Registro.Momento.MusloR(:,1) =  Registro.CantMovAngularDerivado.H1x - dot(Registro.SCG.iMusloR,Registro.MomentoResidual.MusloR,2)
Registro.Momento.MusloR(:,2) =  Registro.CantMovAngularDerivado.H1y - dot(Registro.SCG.jMusloR,Registro.MomentoResidual.MusloR,2)
Registro.Momento.MusloR(:,3) =  Registro.CantMovAngularDerivado.H1z - dot(Registro.SCG.kMusloR,Registro.MomentoResidual.MusloR,2)

Registro.MomentoGlobal.MusloR = delocalaglobal(Registro.SCG.iMusloR,Registro.SCG.jMusloR,Registro.SCG.kMusloR,Registro.Momento.MusloR)

MomentoAnatomico.MusloRx = dot(Registro.MomentoGlobal.MusloR,Registro.SCG.iMusloR,2) %%paso a ejes anatomicos
MomentoAnatomico.MusloRy = dot(Registro.MomentoGlobal.MusloR,Registro.SCG.kPelvis,2)
MomentoAnatomico.MusloRz = dot(Registro.MomentoGlobal.MusloR,iCaderaR,2) %segun apunte negativo

MomentoAnatomico.MusloRx = InterpolaA100Muestras(MomentoAnatomico.MusloRx(RHS1 - Inicio:RHS2 - Inicio))/A1
MomentoAnatomico.MusloRy = InterpolaA100Muestras(MomentoAnatomico.MusloRy(RHS1 - Inicio:RHS2 - Inicio))/A1
MomentoAnatomico.MusloRz = InterpolaA100Muestras(MomentoAnatomico.MusloRz(RHS1 - Inicio:RHS2 - Inicio))/A1


%Cadera izquierdo
DisProximal.Muslo.L = L_HJC - L_TCG
DisDistal.Muslo.L = L_KJC - L_TCG

Registro.MomentoResidual.MusloL = - Registro.MomentoGlobal.PiernaL - cross(DisDistal.Muslo.L,Registro.FuerzaSeg.RodillaL) + cross(DisProximal.Muslo.L,Registro.FuerzaSeg.CaderaL)

Registro.Momento.MusloL(:,1) =  Registro.CantMovAngularDerivado.H2x - dot(Registro.SCG.iMusloL,Registro.MomentoResidual.MusloL,2)
Registro.Momento.MusloL(:,2) =  Registro.CantMovAngularDerivado.H2y - dot(Registro.SCG.jMusloL,Registro.MomentoResidual.MusloL,2)
Registro.Momento.MusloL(:,3) =  Registro.CantMovAngularDerivado.H2z - dot(Registro.SCG.kMusloL,Registro.MomentoResidual.MusloL,2)

Registro.MomentoGlobal.MusloL = delocalaglobal(Registro.SCG.iMusloL,Registro.SCG.jMusloL,Registro.SCG.kMusloL,Registro.Momento.MusloL)

MomentoAnatomico.MusloLx = dot(Registro.MomentoGlobal.MusloL,-Registro.SCG.iMusloL,2) %%paso a ejes anatomicos
MomentoAnatomico.MusloLy = dot(Registro.MomentoGlobal.MusloL,Registro.SCG.kPelvis,2)
MomentoAnatomico.MusloLz = dot(Registro.MomentoGlobal.MusloL,-iCaderaL,2) %segun apunte negativo

MomentoAnatomico.MusloLx = InterpolaA100Muestras(MomentoAnatomico.MusloLx(1:LHS2 - Inicio))/A1
MomentoAnatomico.MusloLy = InterpolaA100Muestras(MomentoAnatomico.MusloLy(1:LHS2 - Inicio))/A1
MomentoAnatomico.MusloLz = InterpolaA100Muestras(MomentoAnatomico.MusloLz(1:LHS2 - Inicio))/A1
%% grafica momentos 

figure;
title('Momentos');
subplot(3,3,1), plot(MomentoAnatomico.MusloRy,'g'),hold on, plot(MomentoAnatomico.MusloLy,'r'),hold on,title('Momento Cadera [Nm/kg]'),xlabel('%CM'), ylabel('Flex(-) - Ext(+) '), grid on, zoom, grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,2), plot(MomentoAnatomico.MusloRz,'g'),hold on, plot(MomentoAnatomico.MusloLz,'r'),hold on,title('Momento Cadera [Nm/kg]'),xlabel('%CM'), ylabel('Abd (-) - Add (+)'), grid on, zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,3), plot(MomentoAnatomico.MusloRx,'g'),hold on, plot(MomentoAnatomico.MusloLx,'r'),hold on,title('Momento Cadera [Nm/kg]'),xlabel('%CM'), ylabel('Rot. int(+) - Rot. ext(-)'), grid on, zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,4), plot(MomentoAnatomico.PiernaRy,'g'),hold on, plot(MomentoAnatomico.PiernaLy,'r'),hold on,title('Momento Rodilla [Nm/kg]'),xlabel('%CM'), ylabel('Flex(+) - Ext(-)'), grid on, zoom, grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,5), plot(MomentoAnatomico.PiernaRz,'g'),hold on, plot(MomentoAnatomico.PiernaLz,'r'),hold on,title('Momento Rodilla [Nm/kg]'),xlabel('%CM'), ylabel('Valgo(-) - Varo(+)'), grid on, zoom, grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,6), plot(MomentoAnatomico.PiernaRx,'g'),hold on, plot(MomentoAnatomico.PiernaLx,'r'),hold on,title('Momento Rodilla [Nm/kg]'),xlabel('%CM'), ylabel('Rot.int(+) - Rot.ext(-)'), grid on, zoom, grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,7), plot(MomentoAnatomico.PieRy,'g'),hold on, plot(MomentoAnatomico.PieLy,'r'),hold on,title('Momento Tobillo [Nm/kg]'),xlabel('%CM'), ylabel('Plantar flex.(-) - Dorsi.flex(+)'), grid on, zoom, grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,8), plot(MomentoAnatomico.PieRx,'g'),hold on, plot(MomentoAnatomico.PieLx,'r'),hold on,title('Momento Tobillo [Nm/kg]'),xlabel('%CM'), ylabel('Inv(-) - Eve(+)'), grid on, zoom, grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,9), plot(MomentoAnatomico.PieRz,'g'),hold on, plot(MomentoAnatomico.PieLz,'r'),hold on, title('Momento Tobillo [Nm/kg]'),xlabel('%CM'), ylabel('Abd (-) - Add (+)'), grid on, zoom, grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');


DisProximal.Pie.R1(:,1) = InterpolaA100Muestras(DisProximal.Pie.R(RHS1 - Inicio:RHS2 - Inicio,1))/A1
DisProximal.Pie.L1(:,1) = InterpolaA100Muestras(DisProximal.Pie.L(1:LHS2 - Inicio,1))/A1
DisProximal.Pie.R1(:,2) = InterpolaA100Muestras(DisProximal.Pie.R(RHS1 - Inicio:RHS2 - Inicio,2))/A1
DisProximal.Pie.L1(:,2) = InterpolaA100Muestras(DisProximal.Pie.L(1:LHS2 - Inicio,2))/A1
DisProximal.Pie.R1(:,3) = InterpolaA100Muestras(DisProximal.Pie.R(RHS1 - Inicio:RHS2 - Inicio,3))/A1
DisProximal.Pie.L1(:,3) = InterpolaA100Muestras(DisProximal.Pie.L(1:LHS2 - Inicio,3))/A1

% figure;
% title('Potencia Lineal Transferida');
% subplot(1,1,1), plot(DisDistal.Pie.R(:,1) ,'g'),hold on, plot(DisDistal.Pie.L(:,1) ,'r'),hold on,title('P'),xlabel('%CM'), ylabel('W/Kg'), grid on, zoom;
% subplot(1,1,1), plot(R_FCG(:,1) ,'y'),hold on, plot(L_FCG(:,1) ,'b'),hold on,;
% 
% figure;
% subplot(1,1,1), plot(DisDistal.Pie.R(:,2) ,'g'),hold on, plot(DisDistal.Pie.L(:,2) ,'r'),hold on,title('P'), xlabel('%CM'),ylabel('W/Kg'), grid on, zoom;
% subplot(1,1,1), plot(R_FCG(:,2) ,'y'),hold on, plot(L_FCG(:,2) ,'b'),hold on,;
% 
% figure;
% subplot(1,1,1), plot(DisDistal.Pie.R(:,3) ,'g'),hold on, plot(DisDistal.Pie.L(:,3) ,'r'),hold on,title('P'), xlabel('%CM'),ylabel('W/Kg'), grid on, zoom;
% subplot(1,1,1), plot(R_FCG(:,3),'y'),hold on, plot(L_FCG(:,3) ,'b'),hold on,;

DisDistal.Pie.R1(:,1) = InterpolaA100Muestras(DisDistal.Pie.R(RHS1 - Inicio:RHS2 - Inicio,1))/A1
DisDistal.Pie.L1(:,1) = InterpolaA100Muestras(DisDistal.Pie.L(1:LHS2 - Inicio,1))/A1
DisDistal.Pie.R1(:,2) = InterpolaA100Muestras(DisDistal.Pie.R(RHS1 - Inicio:RHS2 - Inicio,2))/A1
DisDistal.Pie.L1(:,2) = InterpolaA100Muestras(DisDistal.Pie.L(1:LHS2 - Inicio,2))/A1
DisDistal.Pie.R1(:,3) = InterpolaA100Muestras(DisDistal.Pie.R(RHS1 - Inicio:RHS2 - Inicio,3))/A1
DisDistal.Pie.L1(:,3) = InterpolaA100Muestras(DisDistal.Pie.L(1:LHS2 - Inicio,3))/A1

DisProximal.Pierna.R1(:,1) = InterpolaA100Muestras(DisProximal.Pierna.R(RHS1 - Inicio:RHS2 - Inicio,1))/A1
DisProximal.Pierna.L1(:,1) = InterpolaA100Muestras(DisProximal.Pierna.L(1:LHS2 - Inicio,1))/A1
DisProximal.Pierna.R1(:,2) = InterpolaA100Muestras(DisProximal.Pierna.R(RHS1 - Inicio:RHS2 - Inicio,2))/A1
DisProximal.Pierna.L1(:,2) = InterpolaA100Muestras(DisProximal.Pierna.L(1:LHS2 - Inicio,2))/A1
DisProximal.Pierna.R1(:,3) = InterpolaA100Muestras(DisProximal.Pierna.R(RHS1 - Inicio:RHS2 - Inicio,3))/A1
DisProximal.Pierna.L1(:,3) = InterpolaA100Muestras(DisProximal.Pierna.L(1:LHS2 - Inicio,3))/A1

DisDistal.Pierna.R1(:,1) = InterpolaA100Muestras(DisDistal.Pierna.R(RHS1 - Inicio:RHS2 - Inicio,1))/A1
DisDistal.Pierna.L1(:,1) = InterpolaA100Muestras(DisDistal.Pierna.L(1:LHS2 - Inicio,1))/A1
DisDistal.Pierna.R1(:,2) = InterpolaA100Muestras(DisDistal.Pierna.R(RHS1 - Inicio:RHS2 - Inicio,2))/A1
DisDistal.Pierna.L1(:,2) = InterpolaA100Muestras(DisDistal.Pierna.L(1:LHS2 - Inicio,2))/A1
DisDistal.Pierna.R1(:,3) = InterpolaA100Muestras(DisDistal.Pierna.R(RHS1 - Inicio:RHS2 - Inicio,3))/A1
DisDistal.Pierna.L1(:,3) = InterpolaA100Muestras(DisDistal.Pierna.L(1:LHS2 - Inicio,3))/A1

DisProximal.Muslo.R1(:,1) = InterpolaA100Muestras(DisProximal.Muslo.R(RHS1 - Inicio:RHS2 - Inicio,1))/A1
DisProximal.Muslo.L1(:,1) = InterpolaA100Muestras(DisProximal.Muslo.L(1:LHS2 - Inicio,1))/A1
DisProximal.Muslo.R1(:,2) = InterpolaA100Muestras(DisProximal.Muslo.R(RHS1 - Inicio:RHS2 - Inicio,2))/A1
DisProximal.Muslo.L1(:,2) = InterpolaA100Muestras(DisProximal.Muslo.L(1:LHS2 - Inicio,2))/A1
DisProximal.Muslo.R1(:,3) = InterpolaA100Muestras(DisProximal.Muslo.R(RHS1 - Inicio:RHS2 - Inicio,3))/A1
DisProximal.Muslo.L1(:,3) = InterpolaA100Muestras(DisProximal.Muslo.L(1:LHS2 - Inicio,3))/A1

DisDistal.Muslo.R1(:,1) = InterpolaA100Muestras(DisDistal.Muslo.R(RHS1 - Inicio:RHS2 - Inicio,1))/A1
DisDistal.Muslo.L1(:,1) = InterpolaA100Muestras(DisDistal.Muslo.L(1:LHS2 - Inicio,1))/A1
DisDistal.Muslo.R1(:,2) = InterpolaA100Muestras(DisDistal.Muslo.R(RHS1 - Inicio:RHS2 - Inicio,2))/A1
DisDistal.Muslo.L1(:,2) = InterpolaA100Muestras(DisDistal.Muslo.L(1:LHS2 - Inicio,2))/A1
DisDistal.Muslo.R1(:,3) = InterpolaA100Muestras(DisDistal.Muslo.R(RHS1 - Inicio:RHS2 - Inicio,3))/A1
DisDistal.Muslo.L1(:,3) = InterpolaA100Muestras(DisDistal.Muslo.L(1:LHS2 - Inicio,3))/A1


% figure;
% title('Prueba distancia');
% subplot(3,3,1), plot(DisDistal.Pie.R1(:,1),'g'),hold on, plot(DisDistal.Pie.L1(:,1),'r'),hold on,title('Momento Pie'),xlabel('%CM'), ylabel('Flexión(-) - Extensión(+)'), grid on, zoom;
% subplot(3,3,2), plot(DisDistal.Pie.R1(:,2),'g'),hold on, plot(DisDistal.Pie.L1(:,2),'r'),hold on,title('Momento Pie'),xlabel('%CM'), ylabel('Abduccion (-) - Aducción (+)'), grid on, zoom;
% subplot(3,3,3), plot(DisDistal.Pie.R1(:,3),'g'),hold on, plot(DisDistal.Pie.L1(:,3),'r'),hold on,title('Momento Pie'),xlabel('%CM'), ylabel('Rot. int(-) - Rot. ext(+)'), grid on, zoom;
% subplot(3,3,4), plot(DisDistal.Pierna.R1(:,1),'g'),hold on, plot(DisDistal.Pierna.L1(:,1),'r'),hold on,title('Momento Pierna'),xlabel('%CM'), ylabel('Flexión(-) - Extensión(+)'), grid on, zoom;
% subplot(3,3,5), plot(DisDistal.Pierna.R1(:,2),'g'),hold on, plot(DisDistal.Pierna.L1(:,2),'r'),hold on,title('Momento Pierna'),xlabel('%CM'), ylabel('Abduccion (-) - Aducción (+)'), grid on, zoom;
% subplot(3,3,6), plot(DisDistal.Pierna.R1(:,3),'g'),hold on, plot(DisDistal.Pierna.L1(:,3),'r'),hold on,title('Momento Pierna'),xlabel('%CM'), ylabel('Rot. int(-) - Rot. ext(+)'), grid on, zoom;
% subplot(3,3,7), plot(DisDistal.Muslo.R1(:,1),'g'),hold on, plot(DisDistal.Muslo.L1(:,1),'r'),hold on,title('Momento Muslo'),xlabel('%CM'), ylabel('Flexión(-) - Extensión(+)'), grid on, zoom;
% subplot(3,3,8), plot(DisDistal.Muslo.R1(:,2),'g'),hold on, plot(DisDistal.Muslo.L1(:,2),'r'),hold on,title('Momento Muslo'),xlabel('%CM'), ylabel('Abduccion (-) - Aducción (+)'), grid on, zoom;
% subplot(3,3,9), plot(DisDistal.Muslo.R1(:,3),'g'),hold on, plot(DisDistal.Muslo.L1(:,3),'r'),hold on,title('Momento Muslo'),xlabel('%CM'), ylabel('Rot. int(-) - Rot. ext(+)'), grid on, zoom;
%% Potencia

Potencia.Transferida.MusloR = dot(Registro.FuerzaSeg.CaderaR,derivadaVectores(R_HJC,1/fm),2)
Potencia.Transferida.PiernaR = dot(Registro.FuerzaSeg.RodillaR,derivadaVectores(R_KJC,1/fm),2)
Potencia.Transferida.PieR = dot(Registro.FuerzaSeg.TobilloR,derivadaVectores(R_AJC,1/fm),2)

Potencia.Transferida.MusloL = dot(Registro.FuerzaSeg.CaderaL,derivadaVectores(L_HJC,1/fm),2)
Potencia.Transferida.PiernaL = dot(Registro.FuerzaSeg.RodillaL,derivadaVectores(L_KJC,1/fm),2)
Potencia.Transferida.PieL = dot(Registro.FuerzaSeg.TobilloL,derivadaVectores(L_AJC,1/fm),2)


Valores=fieldnames(Potencia.Transferida);
NumValores=length(Valores);

for NumVal=1:(NumValores/2)
    Val=char(Valores{NumVal});
    [Cord] = InterpolaA100Muestras(Potencia.Transferida.(sprintf('%s',Val))(RHS1 - Inicio:RHS2 - Inicio))/A1
    Potencia.Transferida.(sprintf('%s',Val)) = Cord
  
end;

for NumVal=((NumValores/2)+1):NumValores
    Val=char(Valores{NumVal});    
    [Cord] = InterpolaA100Muestras(Potencia.Transferida.(sprintf('%s',Val))(1:LHS2 - Inicio))/A1
    Potencia.Transferida.(sprintf('%s',Val)) = Cord
end;

figure;
title('Potencia Lineal Transferida');
subplot(3,1,1), plot(Potencia.Transferida.MusloR ,'g'),hold on, plot(Potencia.Transferida.MusloL ,'r'),hold on,title('Cadera'),xlabel('%CM'), ylabel('W/Kg'), grid on, zoom, grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');;
subplot(3,1,2), plot(Potencia.Transferida.PiernaR ,'g'),hold on, plot(Potencia.Transferida.PiernaL ,'r'),hold on,title('Rodilla'), xlabel('%CM'),ylabel('W/Kg'), grid on, zoom, grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');;
subplot(3,1,3), plot(Potencia.Transferida.PieR ,'g'),hold on, plot(Potencia.Transferida.PieL ,'r'),hold on,title('Tobillo'), xlabel('%CM'),ylabel('W/Kg'), grid on, zoom, grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');;
%% Potencia parte 2

% %Paso todas las velocidades a global
% w0 = delocalaglobal(Registro.SCG.iPelvis,Registro.SCG.jPelvis,Registro.SCG.kPelvis,Registro.velocidadesAngulares.w0)
% w1 = delocalaglobal(Registro.SCG.iMusloR,Registro.SCG.jMusloR,Registro.SCG.kMusloR,Registro.velocidadesAngulares.w1)
% w2 = delocalaglobal(Registro.SCG.iMusloL,Registro.SCG.jMusloL,Registro.SCG.kMusloL,Registro.velocidadesAngulares.w2)
% w3 = delocalaglobal(Registro.SCG.iPiernaR,Registro.SCG.jPiernaR,Registro.SCG.kPiernaR,Registro.velocidadesAngulares.w3)
% w4 = delocalaglobal(Registro.SCG.iPiernaL,Registro.SCG.jPiernaL,Registro.SCG.kPiernaL,Registro.velocidadesAngulares.w4)
% w5 = delocalaglobal(Registro.SCG.iPieR,Registro.SCG.jPieR,Registro.SCG.kPieR,Registro.velocidadesAngulares.w5)
% w6 = delocalaglobal(Registro.SCG.iPieL,Registro.SCG.jPieL,Registro.SCG.kPieL,Registro.velocidadesAngulares.w6)

% %Cadera flexión-extensión
w1_flex = Registro.velocidadesAngulares.w1.*Registro.SCG.kPelvis
w0_flex = Registro.velocidadesAngulares.w0.*Registro.SCG.kPelvis

w1_flex = delocalaglobal(Registro.SCG.iMusloR,Registro.SCG.jMusloR,Registro.SCG.kMusloR,w1_flex)
w0_flex = delocalaglobal(Registro.SCG.iPelvis,Registro.SCG.jPelvis,Registro.SCG.kPelvis,w0_flex)

M1_flex = Registro.Momento.MusloR.*Registro.SCG.kPelvis
M1_flex = delocalaglobal(Registro.SCG.iMusloR,Registro.SCG.jMusloR,Registro.SCG.kMusloR,M1_flex)
Potencia.Generada.CaderaR(:,1) = dot(M1_flex,(w1_flex-w0_flex),2)

w2_flex = Registro.velocidadesAngulares.w2.*Registro.SCG.kPelvis
w2_flex = delocalaglobal(Registro.SCG.iMusloL,Registro.SCG.jMusloL,Registro.SCG.kMusloL,w2_flex)

M2_flex = Registro.Momento.MusloL.*Registro.SCG.kPelvis
M2_flex = delocalaglobal(Registro.SCG.iMusloL,Registro.SCG.jMusloL,Registro.SCG.kMusloL,M2_flex)
Potencia.Generada.CaderaL(:,1) = dot(M2_flex,(w2_flex-w0_flex),2)

%Cadera rotacion int-ext
w1_rot = Registro.velocidadesAngulares.w1.*Registro.SCG.iMusloR
w1_rot = delocalaglobal(Registro.SCG.iMusloR,Registro.SCG.jMusloR,Registro.SCG.kMusloR,w1_rot)
w0_rot = Registro.velocidadesAngulares.w0.*Registro.SCG.iMusloR
w0_rot = delocalaglobal(Registro.SCG.iPelvis,Registro.SCG.jPelvis,Registro.SCG.kPelvis,w0_rot)

M1_rot = Registro.Momento.MusloR.*Registro.SCG.iMusloR
M1_rot = delocalaglobal(Registro.SCG.iMusloR,Registro.SCG.jMusloR,Registro.SCG.kMusloR,M1_rot)
Potencia.Generada.CaderaR(:,2) = dot(M1_rot,(w1_rot-w0_rot),2)

w2_rot = Registro.velocidadesAngulares.w2.*Registro.SCG.iMusloL
w2_rot = delocalaglobal(Registro.SCG.iMusloL,Registro.SCG.jMusloL,Registro.SCG.kMusloL,w2_rot)
w0L_rot = Registro.velocidadesAngulares.w0.*Registro.SCG.iMusloL
w0L_rot = delocalaglobal(Registro.SCG.iPelvis,Registro.SCG.jPelvis,Registro.SCG.kPelvis,w0L_rot)

M2_rot = Registro.Momento.MusloL.*Registro.SCG.iMusloL
M2_rot = delocalaglobal(Registro.SCG.iMusloL,Registro.SCG.jMusloL,Registro.SCG.kMusloL,M2_rot)
Potencia.Generada.CaderaL(:,2) = dot(M2_rot,(w2_rot-w0L_rot),2)

%Cadera rotacion abd-add

e2R = cross(Registro.SCG.kPelvis,Registro.SCG.iMusloR)
e2L = cross(Registro.SCG.kPelvis,Registro.SCG.iMusloL)

w1_abd = Registro.velocidadesAngulares.w1.*e2R
w1_abd = delocalaglobal(Registro.SCG.iMusloR,Registro.SCG.jMusloR,Registro.SCG.kMusloR,w1_abd)
w0_abd = Registro.velocidadesAngulares.w0.*e2R
w0_abd = delocalaglobal(Registro.SCG.iPelvis,Registro.SCG.jPelvis,Registro.SCG.kPelvis,w0_abd)

M1_abd = Registro.Momento.MusloR.*e2R
M1_abd = delocalaglobal(Registro.SCG.iMusloR,Registro.SCG.jMusloR,Registro.SCG.kMusloR,M1_abd)
Potencia.Generada.CaderaR(:,3) = dot(M1_abd,(w1_abd-w0_abd),2)

w2_abd = Registro.velocidadesAngulares.w2.*e2L
w2_abd = delocalaglobal(Registro.SCG.iMusloL,Registro.SCG.jMusloL,Registro.SCG.kMusloL,w2_abd)
w0L_abd = Registro.velocidadesAngulares.w0.*e2L
w0L_abd = delocalaglobal(Registro.SCG.iPelvis,Registro.SCG.jPelvis,Registro.SCG.kPelvis,w0L_abd)

M2_abd = Registro.Momento.MusloL.*e2L
M2_abd = delocalaglobal(Registro.SCG.iMusloL,Registro.SCG.jMusloL,Registro.SCG.kMusloL,M2_abd)
Potencia.Generada.CaderaL(:,3) = dot(M2_abd,(w2_abd-w0L_abd),2)
%% Rodilla flexión-extensión

% w1_flex = Registro.velocidadesAngulares.w1.*Registro.SCG.kMusloR
% w1_flex = delocalaglobal(Registro.SCG.iMusloR,Registro.SCG.jMusloR,Registro.SCG.kMusloR,w1_flex)
w3_flex = Registro.velocidadesAngulares.w3.*Registro.SCG.kMusloR
w3_flex = delocalaglobal(Registro.SCG.iPiernaR,Registro.SCG.jPiernaR,Registro.SCG.kPiernaR,w3_flex)

M3_flex = Registro.Momento.PiernaR.*Registro.SCG.kMusloR
M3_flex = delocalaglobal(Registro.SCG.iPiernaR,Registro.SCG.jPiernaR,Registro.SCG.kPiernaR,M3_flex)
Potencia.Generada.RodillaR(:,1) = dot(M3_flex,(w3_flex-w1_flex),2)

% w2_flex = Registro.velocidadesAngulares.w2.*Registro.SCG.kMusloL
% w2_flex = delocalaglobal(Registro.SCG.iMusloL,Registro.SCG.jMusloL,Registro.SCG.kMusloL,w2_flex)
w4_flex = Registro.velocidadesAngulares.w4.*Registro.SCG.kMusloL
w4_flex = delocalaglobal(Registro.SCG.iPiernaL,Registro.SCG.jPiernaL,Registro.SCG.kPiernaL,w4_flex)

M4_flex = Registro.Momento.PiernaL.*Registro.SCG.kMusloL
M4_flex = delocalaglobal(Registro.SCG.iPiernaL,Registro.SCG.jPiernaL,Registro.SCG.kPiernaL,M4_flex)
Potencia.Generada.RodillaL(:,1) = dot(M4_flex,(w4_flex-w2_flex),2)

w1_flex = Registro.velocidadesAngulares.w1.*Registro.SCG.kPelvis
w1_flex = delocalaglobal(Registro.SCG.iMusloR,Registro.SCG.jMusloR,Registro.SCG.kMusloR,w1_flex)
w0_flex = Registro.velocidadesAngulares.w0.*Registro.SCG.kPelvis
w0_flex = delocalaglobal(Registro.SCG.iPelvis,Registro.SCG.jPelvis,Registro.SCG.kPelvis,w0_flex)

M1_flex = Registro.Momento.MusloR.*Registro.SCG.kPelvis
M1_flex = delocalaglobal(Registro.SCG.iMusloR,Registro.SCG.jMusloR,Registro.SCG.kMusloR,M1_flex)
Potencia.Generada.CaderaR(:,1) = dot(M1_flex,(w1_flex-w0_flex),2)

w2_flex = Registro.velocidadesAngulares.w2.*Registro.SCG.kPelvis
w2_flex = delocalaglobal(Registro.SCG.iMusloL,Registro.SCG.jMusloL,Registro.SCG.kMusloL,w2_flex)

M2_flex = Registro.Momento.MusloL.*Registro.SCG.kPelvis
M2_flex = delocalaglobal(Registro.SCG.iMusloL,Registro.SCG.jMusloL,Registro.SCG.kMusloL,M2_flex)
Potencia.Generada.CaderaL(:,1) = dot(M2_flex,(w2_flex-w0_flex),2)

%Rodilla rotacion int-ext
w3_rot = Registro.velocidadesAngulares.w3.*Registro.SCG.iPiernaR
w3_rot = delocalaglobal(Registro.SCG.iPiernaR,Registro.SCG.jPiernaR,Registro.SCG.kPiernaR,w3_rot)

M3_rot = Registro.Momento.PiernaR.*Registro.SCG.iPiernaR
M3_rot = delocalaglobal(Registro.SCG.iPiernaR,Registro.SCG.jPiernaR,Registro.SCG.kPiernaR,M3_rot)
Potencia.Generada.RodillaR(:,2) = dot(M3_rot,(w3_rot-w1_rot),2)

w4_rot = Registro.velocidadesAngulares.w4.*Registro.SCG.iPiernaL
w4_rot = delocalaglobal(Registro.SCG.iPiernaL,Registro.SCG.jPiernaL,Registro.SCG.kPiernaL,w4_rot)

M4_rot = Registro.Momento.PiernaL.*Registro.SCG.iPiernaL
M4_rot = delocalaglobal(Registro.SCG.iPiernaL,Registro.SCG.jPiernaL,Registro.SCG.kPiernaL,M4_rot)
Potencia.Generada.RodillaL(:,2) = dot(M4_rot,(w4_rot-w2_rot),2)

%Rodilla rotacion abd-add

e3R = cross(Registro.SCG.kMusloR,Registro.SCG.iPiernaR)
e3L = cross(Registro.SCG.kMusloL,Registro.SCG.iPiernaL)


w1_abd = Registro.velocidadesAngulares.w1.*e3R
w1_abd = delocalaglobal(Registro.SCG.iMusloR,Registro.SCG.jMusloR,Registro.SCG.kMusloR,w1_abd)
w3_abd = Registro.velocidadesAngulares.w3.*e3R
w3_abd = delocalaglobal(Registro.SCG.iPiernaR,Registro.SCG.jPiernaR,Registro.SCG.kPiernaR,w3_abd)

M3_abd = Registro.Momento.PiernaR.*e3R
M3_abd = delocalaglobal(Registro.SCG.iPiernaR,Registro.SCG.jPiernaR,Registro.SCG.kPiernaR,M3_abd)
Potencia.Generada.RodillaR(:,3) = dot(M3_abd,(w3_abd-w1_abd),2)


w2_abd = Registro.velocidadesAngulares.w2.*e3L
w2_abd = delocalaglobal(Registro.SCG.iMusloL,Registro.SCG.jMusloL,Registro.SCG.kMusloL,w2_abd)
w4_abd = Registro.velocidadesAngulares.w4.*e3L
w4_abd = delocalaglobal(Registro.SCG.iPiernaL,Registro.SCG.jPiernaL,Registro.SCG.kPiernaL,w4_abd)

M4_abd = Registro.Momento.PiernaL.*e3L
M4_abd = delocalaglobal(Registro.SCG.iPiernaL,Registro.SCG.jPiernaL,Registro.SCG.kPiernaL,M4_abd)
Potencia.Generada.RodillaL(:,3) = dot(M4_abd,(w4_abd-w2_abd),2)
%% Tobillo flexión-extensión
w5_flex = Registro.velocidadesAngulares.w5.*Registro.SCG.kPiernaR
w5_flex = delocalaglobal(Registro.SCG.iPieR,Registro.SCG.jPieR,Registro.SCG.kPieR,w5_flex)

M5_flex = Registro.Momento.PieR.*Registro.SCG.kPiernaR
M5_flex = delocalaglobal(Registro.SCG.iPieR,Registro.SCG.jPieR,Registro.SCG.kPieR,M5_flex)
Potencia.Generada.TobilloR(:,1) = dot(M5_flex,(w5_flex-w3_flex),2)

w6_flex = Registro.velocidadesAngulares.w4.*Registro.SCG.kPiernaL
w6_flex = delocalaglobal(Registro.SCG.iPieL,Registro.SCG.jPieL,Registro.SCG.kPieL,w6_flex)

M6_flex = Registro.Momento.PieL.*Registro.SCG.kPiernaL
M6_flex = delocalaglobal(Registro.SCG.iPieL,Registro.SCG.jPieL,Registro.SCG.kPieL,M6_flex)
Potencia.Generada.TobilloL(:,1) = dot(M6_flex,(w6_flex-w4_flex),2)

%Tobillo rotacion int-ext
w5_rot = Registro.velocidadesAngulares.w5.*Registro.SCG.iPieR
w5_rot = delocalaglobal(Registro.SCG.iPieR,Registro.SCG.jPieR,Registro.SCG.kPieR,w5_rot)

M5_rot = Registro.Momento.PieR.*Registro.SCG.iPieR
M5_rot = delocalaglobal(Registro.SCG.iPieR,Registro.SCG.jPieR,Registro.SCG.kPieR,M5_rot)
Potencia.Generada.TobilloR(:,2) = dot(M5_rot,(w5_rot-w3_rot),2)

w6_rot = Registro.velocidadesAngulares.w6.*Registro.SCG.iPieL
w6_rot = delocalaglobal(Registro.SCG.iPieL,Registro.SCG.jPieL,Registro.SCG.kPieL,w6_rot)

M6_rot = Registro.Momento.PieL.*Registro.SCG.iPieL
M6_rot = delocalaglobal(Registro.SCG.iPieL,Registro.SCG.jPieL,Registro.SCG.kPieL,M6_rot)
Potencia.Generada.TobilloL(:,2) = dot(M6_rot,(w6_rot-w4_rot),2)

%Tobillo rotacion abd-add

e4R = cross(Registro.SCG.kPiernaR,Registro.SCG.iPieR)
e4L = cross(Registro.SCG.kPiernaL,Registro.SCG.iPieL)

w5_abd = Registro.velocidadesAngulares.w5.*e4R
w5_abd = delocalaglobal(Registro.SCG.iPieR,Registro.SCG.jPieR,Registro.SCG.kPieR,w5_abd)

M5_abd = Registro.Momento.PieR.*e4R
M5_abd = delocalaglobal(Registro.SCG.iPieR,Registro.SCG.jPieR,Registro.SCG.kPieR,M5_abd)
Potencia.Generada.TobilloR(:,3) = dot(M5_abd,(w5_abd-w3_abd),2)

w6_abd = Registro.velocidadesAngulares.w6.*e4L
w6_abd = delocalaglobal(Registro.SCG.iPieL,Registro.SCG.jPieL,Registro.SCG.kPieL,w6_abd)

M6_abd = Registro.Momento.PieL.*e4L
M6_abd = delocalaglobal(Registro.SCG.iPieL,Registro.SCG.jPieL,Registro.SCG.kPieL,M6_abd)
Potencia.Generada.TobilloL(:,3) = dot(M6_abd,(w6_abd-w4_abd),2)

for i =1:3
Potencia.Generada.CaderaRi(:,i) = InterpolaA100Muestras(Potencia.Generada.CaderaR(RHS1 - Inicio:RHS2 - Inicio,i))/A1
Potencia.Generada.CaderaLi(:,i) = InterpolaA100Muestras(Potencia.Generada.CaderaL(1:LHS2 - Inicio,i))/A1
Potencia.Generada.RodillaRi(:,i) = InterpolaA100Muestras(Potencia.Generada.RodillaR(RHS1 - Inicio:RHS2 - Inicio,i))/A1
Potencia.Generada.RodillaLi(:,i) = InterpolaA100Muestras(Potencia.Generada.RodillaL(1:LHS2 - Inicio,i))/A1
Potencia.Generada.TobilloRi(:,i) = InterpolaA100Muestras(Potencia.Generada.TobilloR(RHS1 - Inicio:RHS2 - Inicio,i))/A1
Potencia.Generada.TobilloLi(:,i) = InterpolaA100Muestras(Potencia.Generada.TobilloL(1:LHS2 - Inicio,i))/A1

end;

figure;
title('Potencia Generada');
subplot(3,3,1), plot(Potencia.Generada.CaderaRi(:,2) ,'g'),hold on, plot(Potencia.Generada.CaderaLi(:,2) ,'r'),hold on,title('Cadera Flex-Ext'),xlabel('%CM'), ylabel('W/Kg'), grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,2), plot(Potencia.Generada.CaderaRi(:,1) ,'g'),hold on, plot(Potencia.Generada.CaderaLi(:,1) ,'r'),hold on,title('Cadera abd-add'), xlabel('%CM'),ylabel('W/Kg'), grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,3), plot(Potencia.Generada.CaderaRi(:,3),'g'),hold on, plot(Potencia.Generada.CaderaLi(:,3) ,'r'),hold on,title('Cadera Rot. Ext - Int'), xlabel('%CM'),ylabel('W/Kg'), grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,4), plot(Potencia.Generada.RodillaRi(:,2) ,'g'),hold on, plot(Potencia.Generada.RodillaLi(:,2) ,'r'),hold on,title('Rodilla Flex-Ext'),xlabel('%CM'), ylabel('W/Kg'), grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,5), plot(Potencia.Generada.RodillaRi(:,1) ,'g'),hold on, plot(Potencia.Generada.RodillaLi(:,1) ,'r'),hold on,title('Rodilla Val-Var'), xlabel('%CM'),ylabel('W/Kg'), grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,6), plot(Potencia.Generada.RodillaRi(:,3),'g'),hold on, plot(Potencia.Generada.RodillaLi(:,3) ,'r'),hold on,title('Rodilla'), xlabel('%CM'),ylabel('W/Kg'), grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,7), plot(Potencia.Generada.TobilloRi(:,2) ,'g'),hold on, plot(Potencia.Generada.TobilloLi(:,2) ,'r'),hold on,title('Tobillo Flex-Ext'),xlabel('%CM'), ylabel('W/Kg'), grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,8), plot(Potencia.Generada.TobilloRi(:,1) ,'g'),hold on, plot(Potencia.Generada.TobilloLi(:,1) ,'r'),hold on,title('Tobillo Eve-Inv'), xlabel('%CM'),ylabel('W/Kg'), grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,9), plot(Potencia.Generada.TobilloRi(:,3),'g'),hold on, plot(Potencia.Generada.TobilloLi(:,3) ,'r'),hold on,title('Tobillo'), xlabel('%CM'),ylabel('W/Kg'), grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');

%% VEL ANGULAR LOCAL



figure;
subplot(3,3,1), plot(Registro.velocidadesAngularesRec.w1(:,1)*180/pi,'g'),hold on,plot(Registro.velocidadesAngularesRec.w2(:,1)*180/pi,'r'),hold on, title('Muslo en x'), grid on,xlabel('%CM', 'FontSize',8), ylabel('[°/seg]'),zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,2), plot(Registro.velocidadesAngularesRec.w1(:,2)*180/pi,'g'),hold on,plot(Registro.velocidadesAngularesRec.w2(:,2)*180/pi,'r'),hold on, title('Muslo en y'), grid on,xlabel('%CM', 'FontSize',8), zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,3), plot(Registro.velocidadesAngularesRec.w1(:,3)*180/pi,'g'),hold on,plot(Registro.velocidadesAngularesRec.w2(:,3)*180/pi,'r'),hold on, title('Muslo en z'), grid on,xlabel('%CM', 'FontSize',8), zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,4), plot(Registro.velocidadesAngularesRec.w3(:,1)*180/pi,'g'),hold on,plot(Registro.velocidadesAngularesRec.w4(:,1)*180/pi,'r'),hold on, title('Pierna en x'), grid on,xlabel('%CM', 'FontSize',8), ylabel('[°/seg]'),zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,5), plot(Registro.velocidadesAngularesRec.w3(:,2)*180/pi,'g'),hold on,plot(Registro.velocidadesAngularesRec.w4(:,2)*180/pi,'r'),hold on, title('Pierna en y'), grid on,xlabel('%CM', 'FontSize',8), zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,6), plot(Registro.velocidadesAngularesRec.w3(:,3)*180/pi,'g'),hold on,plot(Registro.velocidadesAngularesRec.w4(:,3)*180/pi,'r'),hold on, title('Pierna en z'), grid on,xlabel('%CM', 'FontSize',8), zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,7), plot(Registro.velocidadesAngularesRec.w5(:,1)*180/pi,'g'),hold on,plot(Registro.velocidadesAngularesRec.w6(:,1)*180/pi,'r'),hold on, title('Pie en x'), grid on,xlabel('%CM', 'FontSize',8), ylabel('[°/seg]'),zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,8), plot(Registro.velocidadesAngularesRec.w5(:,2)*180/pi,'g'),hold on,plot(Registro.velocidadesAngularesRec.w6(:,2)*180/pi,'r'),hold on, title('Pie en y'), grid on,xlabel('%CM', 'FontSize',8), zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');
subplot(3,3,9), plot(Registro.velocidadesAngularesRec.w5(:,3)*180/pi,'g'),hold on,plot(Registro.velocidadesAngularesRec.w6(:,3)*180/pi,'r'),hold on, title('Pie en z'), grid on,xlabel('%CM', 'FontSize',8), zoom,grid on, zoom,  axis tight, y = axis, line([RTO_CM RTO_CM],[y(3)-abs(y(4)-y(3))*0.05 y(4)+abs(y(4)-y(3))*0.05],'color','g','LineWidth',2,'LineStyle','--'), line([LTO_CM LTO_CM],[y(3) y(4)],'color','r','LineWidth',2,'LineStyle','--');