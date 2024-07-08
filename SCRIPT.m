close all;
clear all;
clc;

%% LECTURA DE DATOS C3D
cd('C:\Users\alang\Documents\Facultad\BIOMECANIC\ANALISIS DE MARCHA')
file ='0047_Davis_MarchaDavis_Walking11b2021.c3d';
h = btkReadAcquisition(file);
[marcadores, info_cinem] = btkGetMarkers(h);
[fuerzas, info_fza] = btkGetForcePlatforms(h);
antropometria = btkFindMetaData(h,'Antropometria');
Eventos = btkGetEvents(h);

% ASIGNO LOS DATOS SEGUN DIGA EL APUNTE. ESTOS SON ~datos antropometricos~
A1 = antropometria.children.PESO.info.values;
A2 = antropometria.children.LONGITUD_ASIS.info.values/100;
A11 = antropometria.children.DIAMETRO_RODILLA_DERECHA.info.values/100;
A12 = antropometria.children.DIAMETRO_RODILLA_IZQUIERDA.info.values/100;
A13 = antropometria.children.LONGITUD_PIE_DERECHO.info.values/100;
A14 = antropometria.children.LONGITUD_PIE_IZQUIERDO.info.values/100;
A15 = antropometria.children.ALTURA_MALEOLOS_DERECHO.info.values/100;
A16 = antropometria.children.ALTURA_MALEOLOS_IZQUIERDO.info.values/100;
A17 = antropometria.children.ANCHO_MALEOLOS_DERECHO.info.values/100;
A18 = antropometria.children.ANCHO_MALEOLOS_IZQUIERDO.info.values/100;
A19 = antropometria.children.ANCHO_PIE_DERECHO.info.values/100;
A20 = antropometria.children.ANCHO_PIE_IZQUIERDO.info.values/100;


%% RECORTO. HAY NAN AL INICIO Y FIN, HAY EVENTOS MARCADOS COMO RHS
%RTO LHS LTO 
fm=info_cinem.frequency(1);
RHS1=round(Eventos.Derecho_RHS(1)*fm);
RHS2=round(Eventos.Derecho_RHS(2)*fm);
RTO=round(Eventos.Derecho_RTO(1)*fm);

LHS1=round(Eventos.Izquierdo_LHS(1)*fm);
LHS2=round(Eventos.Izquierdo_LHS(2)*fm);
LTO=round(Eventos.Izquierdo_LTO(1)*fm);

inicio=LHS1-10;
fin=RHS2+10;

%ACA RECORTO Y LE CAMBIO EL NOMBRE SEGUN LA TABLA DEL APUNTE PAGINA 44
p1=marcadores.r_met(inicio:fin, :);
p2=marcadores.r_heel(inicio:fin, :);
p3=marcadores.r_mall(inicio:fin,:);
p4=marcadores.r_bar_2(inicio:fin,:);
p5=marcadores.r_knee_1(inicio:fin,:);
p6=marcadores.r_bar_1(inicio:fin,:);
p7=marcadores.r_asis(inicio:fin,:);

p8=marcadores.l_met(inicio:fin,:);
p9=marcadores.l_heel(inicio:fin,:);
p10=marcadores.l_mall(inicio:fin,:);
p11=marcadores.l_bar_2(inicio:fin,:);
p12=marcadores.l_knee_1(inicio:fin,:);
p13=marcadores.l_bar_1(inicio:fin,:);
p14=marcadores.l_asis(inicio:fin,:);

p15=marcadores.sacrum(inicio:fin,:);

%% AHORA HAY QUE FILTRAR 
fm=info_cinem.frequency(1); %esto ya lo tenia definido pero lo repito por claridad
fe=fm/2; %FRECUENCIA DE Nyquist
wn=10/fe; %FRECUENCIA DE CORTE
[B,A]=butter(2,wn); %FILTRO. 2 es el orden

for i=1:3
    p1(:,i)=filtfilt(B,A,p1(:,i));
    p2(:,i)=filtfilt(B,A,p2(:,i));
    p3(:,i)=filtfilt(B,A,p3(:,i));
    p4(:,i)=filtfilt(B,A,p4(:,i));
    p5(:,i)=filtfilt(B,A,p5(:,i));
    p6(:,i)=filtfilt(B,A,p6(:,i));
    p7(:,i)=filtfilt(B,A,p7(:,i));
    p8(:,i)=filtfilt(B,A,p8(:,i));
    p9(:,i)=filtfilt(B,A,p9(:,i));
    p10(:,i)=filtfilt(B,A,p10(:,i));
    p11(:,i)=filtfilt(B,A,p11(:,i));
    p12(:,i)=filtfilt(B,A,p12(:,i));
    p13(:,i)=filtfilt(B,A,p13(:,i));
    p14(:,i)=filtfilt(B,A,p14(:,i));
    p15(:,i)=filtfilt(B,A,p15(:,i));
end;

%% CALCULAR VERSORES U V W

%---------------------------CADERA
Avp = p14 - p7;
Bvp = Avp.^2;
normvp=sqrt(sum(Bvp,2));
vpelvis=Avp./normvp;

Aw=(p7-p15);
Bw=(p14-p15);
Cw=cross(Aw,Bw);
normwp=sqrt(sum(Cw.^2,2));
wpelvis=Cw./normwp;

upelvis=cross(vpelvis,wpelvis);

prhip=p15+0.598*A2*upelvis-0.344*A2*vpelvis-0.290*A2*wpelvis;
plhip=p15+0.598*A2*upelvis+0.344*A2*vpelvis-0.290*A2*wpelvis;

%GRAFICO

figure;
plot3(p15(:,1),p15(:,2),p15(:,3),'k','LineWidth',2);
hold on;
plot3(p7(:,1),p7(:,2),p7(:,3),'r','LineWidth',2);
hold on;
plot3(p14(:,1),p14(:,2),p14(:,3),'b','LineWidth',2);
hold on;
plot3(prhip(:,1),prhip(:,2),prhip(:,3),'g','LineWidth',2);
hold on;
plot3(plhip(:,1),plhip(:,2),plhip(:,3),'g','LineWidth',2);
hold on;

for i=1:10:length(p15)
    quiver3(p15(i,1),p15(i,2),p15(i,3),upelvis(i,1)/10,upelvis(i,2)/10,upelvis(i,3)/10,'b');
    hold on;
    quiver3(p15(i,1),p15(i,2),p15(i,3),vpelvis(i,1)/10,vpelvis(i,2)/10,vpelvis(i,3)/10,'r');
    hold on;
    quiver3(p15(i,1),p15(i,2),p15(i,3),wpelvis(i,1)/10,wpelvis(i,2)/10,wpelvis(i,3)/10,'g');
    hold on;
end;
legend('Marcador del Sacro','Marcador del ASIS derecho','Marcador del ASIS izquierdo','Centro articular cadera Derecha','Centro articular cadera Izquierda','upelvis','vpelvis','wpelvis');
xlabel('Eje X');
ylabel('Eje Y');
zlabel('Eje Z');
title('Trayectoria de marcadores y diagrama de u,v,w sobre el marcador del sacro');
grid on;

%-----------------------------------RODILLA DERECHA
Avc=p3-p5;
Bvc=Avc.^2;
normvc=sqrt(sum(Bvc,2));
vrknee=Avc./normvc;

Au=(p4-p5);
Bu=(p3-p5);
Cu=cross(Au,Bu);
normuc=sqrt(sum(Cu.^2,2));
urknee=Cu./normuc;


wrknee=cross(urknee,vrknee);

prknee=p5+0*A11*urknee+0*A11*vrknee+0.5*A11*wrknee;
%GRAFICO

figure;
plot3(p5(:,1),p5(:,2),p5(:,3),'k','LineWidth',2);
hold on;
plot3(p3(:,1),p3(:,2),p3(:,3),'r','LineWidth',2);
hold on;
plot3(p4(:,1),p4(:,2),p4(:,3),'b','LineWidth',2);
hold on;
plot3(prknee(:,1),prknee(:,2),prknee(:,3),'g','LineWidth',2);
hold on;

for i=1:10:length(p5)
    quiver3(p5(i,1),p5(i,2),p5(i,3),urknee(i,1)/10,urknee(i,2)/10,urknee(i,3)/10,'b');
    hold on;
    quiver3(p5(i,1),p5(i,2),p5(i,3),vrknee(i,1)/10,vrknee(i,2)/10,vrknee(i,3)/10,'r');
    hold on;
    quiver3(p5(i,1),p5(i,2),p5(i,3),wrknee(i,1)/10,wrknee(i,2)/10,wrknee(i,3)/10,'g');
    hold on;
end;
legend('EPICONDILO FEM DERECHO','MALEOLO DERECHO','BANDA TIBIAL DERECHA','CENTRO ARTICULAR','urknee','vrknee','wrknee');
xlabel('Eje X');
ylabel('Eje Y');
zlabel('Eje Z');
title('Trayectoria de marcadores y diagrama de u,v,w para la rodilla derecha');
grid on;


%-----------------------------------RODILLA IZQUIERDA

Avc=p10-p12;
Bvc=Avc.^2;
normvc=sqrt(sum(Bvc,2));
vlknee=Avc./normvc;

Au=(p10-p12);
Bu=(p11-p12);
Cu=cross(Au,Bu);
normuc=sqrt(sum(Cu.^2,2));
ulknee=Cu./normuc;
wlknee=cross(ulknee,vlknee);
plknee=p12+0*A11*urknee+0*A11*vrknee-0.5*A11*wrknee;


%GRAFICO

figure;
plot3(p12(:,1),p12(:,2),p12(:,3),'k','LineWidth',2);
hold on;
plot3(p11(:,1),p11(:,2),p11(:,3),'r','LineWidth',2);
hold on;
plot3(p10(:,1),p10(:,2),p10(:,3),'b','LineWidth',2);
hold on;
plot3(plknee(:,1),plknee(:,2),plknee(:,3),'g','LineWidth',2);
hold on;

for i=1:10:length(p12)
    quiver3(p12(i,1),p12(i,2),p12(i,3),ulknee(i,1)/10,ulknee(i,2)/10,ulknee(i,3)/10,'b');
    hold on;
    quiver3(p12(i,1),p12(i,2),p12(i,3),vlknee(i,1)/10,vlknee(i,2)/10,vlknee(i,3)/10,'r');
    hold on;
    quiver3(p12(i,1),p12(i,2),p12(i,3),wlknee(i,1)/10,wlknee(i,2)/10,wlknee(i,3)/10,'g');
    hold on;
end;
legend('EPICONDILO FEM IZQUIERDO','BANDA TIBIAL IZQUIERDA','MALEOLO IZQUIERDO','CENTRO ARTICULAR','ulknee','vlknee','wlknee');
xlabel('Eje X');
ylabel('Eje Y');
zlabel('Eje Z');
title('Trayectoria de marcadores y diagrama de u,v,w sobre el marcador de la rodilla izquierda');
grid on;


%-----------------------------------TOBILLO DERECHO

Avc=p1-p2;
Bvc=Avc.^2;
normvc=sqrt(sum(Bvc,2));
urankle=Avc./normvc;

Au=(p1-p3);
Bu=(p2-p3);
Cu=cross(Au,Bu);
normuc=sqrt(sum(Cu.^2,2));
wrankle=Cu./normuc;
vrankle=cross(wrankle,urankle);
prankle=p3+0.016*A13*urankle+0.392*A15*vrankle+0.478*A17*wrankle;

%-----------------------------------PUNTA DEL PIE DERECHO
prtoe=p3+0.742*A13*urankle+1.074*A15*vrankle-0.187*A19*wrankle;


%GRAFICO

figure;
plot3(p3(:,1),p3(:,2),p3(:,3),'k','LineWidth',2);
hold on;
% plot3(p2(:,1),p2(:,2),p2(:,3),'r','LineWidth',2);,'Talon derecho',
% hold on;
% plot3(p1(:,1),p1(:,2),p1(:,3),'b','LineWidth',2);'Cabeza 2do metatarsiano'
% hold on;
plot3(prankle(:,1),prankle(:,2),prankle(:,3),'g','LineWidth',2);
hold on;
plot3(prtoe(:,1),prtoe(:,2),prtoe(:,3),'g','LineWidth',2);
hold on;

for i=1:10:length(p3)
    quiver3(p3(i,1),p3(i,2),p3(i,3),urankle(i,1)/10,urankle(i,2)/10,urankle(i,3)/10,'b');
    hold on;
    quiver3(p3(i,1),p3(i,2),p3(i,3),vrankle(i,1)/10,vrankle(i,2)/10,vrankle(i,3)/10,'r');
    hold on;
    quiver3(p3(i,1),p3(i,2),p3(i,3),wrankle(i,1)/10,wrankle(i,2)/10,wrankle(i,3)/10,'g');
    hold on;
end;
legend('Maléolo lateral derecho','Centro articular tobillo','Centro articular punta del pie','urankle','vrankle','wrankle');
xlabel('Eje X');
ylabel('Eje Y');
zlabel('Eje Z');
title('Trayectoria de marcadores y diagrama de u,v,w sobre el marcador del maleolo lateral derecho');
grid on;


%-----------------------------------TOBILLO IZQUIERDO

Avc=p8-p9;
Bvc=Avc.^2;
normvc=sqrt(sum(Bvc,2));
ulankle=Avc./normvc;

Au=(p8-p10);
Bu=(p9-p10);
Cu=cross(Au,Bu);
normuc=sqrt(sum(Cu.^2,2));
wlankle=Cu./normuc;
vlankle=cross(wlankle,ulankle);
plankle=p10+0.016*A14*ulankle+0.392*A16*vlankle-0.478*A18*wlankle;


%-----------------------------------PUNTA DEL PIE IZQUIERDO
pltoe=p10+0.742*A14*ulankle+1.074*A16*vlankle+0.187*A20*wlankle;
%GRAFICO

figure;
plot3(p10(:,1),p10(:,2),p10(:,3),'k','LineWidth',2);
hold on;
% plot3(p9(:,1),p9(:,2),p9(:,3),'r','LineWidth',2);'Talon izquierdo',
% hold on;
% plot3(p8(:,1),p8(:,2),p8(:,3),'b','LineWidth',2);'Cabeza 2do metatarsiano',
% hold on;
plot3(plankle(:,1),plankle(:,2),plankle(:,3),'g','LineWidth',2);
hold on;
plot3(pltoe(:,1),pltoe(:,2),pltoe(:,3),'g','LineWidth',2);
hold on;

for i=1:10:length(p10)
    quiver3(p10(i,1),p10(i,2),p10(i,3),ulankle(i,1)/10,ulankle(i,2)/10,ulankle(i,3)/10,'b');
    hold on;
    quiver3(p10(i,1),p10(i,2),p10(i,3),vlankle(i,1)/10,vlankle(i,2)/10,vlankle(i,3)/10,'r');
    hold on;
    quiver3(p10(i,1),p10(i,2),p10(i,3),wlankle(i,1)/10,wlankle(i,2)/10,wlankle(i,3)/10,'g');
    hold on;
end;
legend('Maléolo lateral izquierdo','Centro articular del tobillo','Centro articular de la punta del pie izquierdo','ulankle','vlankle','wlankle');
xlabel('Eje X');
ylabel('Eje Y');
zlabel('Eje Z');
title('Trayectoria de marcadores y diagrama de u,v,w sobre el marcador del maleolo lateral izquierdo');
grid on;



%% CENTRO DE MASA DE CADA SEGMENTO 
CM_rthigh=prhip+0.39.*(prknee-prhip);
CM_lthigh=plhip+0.39.*(plknee-plhip);
CM_rcalf=prknee+0.42.*(prankle-prknee);
CM_lcalf=plknee+0.42.*(plankle-plknee);
CM_rfoot=p2+0.44.*(prtoe-p2);
CM_lfoot=p9+0.44.*(pltoe-p9);

%------------------------------GRAFICO


figure;
plot3(CM_rthigh(:,1),CM_rthigh(:,2),CM_rthigh(:,3),'b--','LineWidth',2);
hold on;
plot3(CM_rcalf(:,1),CM_rcalf(:,2),CM_rcalf(:,3),'b--','LineWidth',2);
hold on;
% plot3(CM_rfoot(:,1),CM_rfoot(:,2),CM_rfoot(:,3),'b--','LineWidth',2); 'Centro de masa pie derecho',
% hold on;
plot3(prhip(:,1),prhip(:,2),prhip(:,3),'r','LineWidth',2);
hold on;
plot3(p2(:,1),p2(:,2),p2(:,3),'g','LineWidth',2);
hold on;
% plot3(prtoe(:,1),prtoe(:,2),prtoe(:,3),'k','LineWidth',2);'Centro articular pie derecho',
% hold on;
plot3(prknee(:,1),prknee(:,2),prknee(:,3),'y','LineWidth',2);
hold on;
plot3(prankle(:,1),prankle(:,2),prankle(:,3),'b','LineWidth',2);
hold on;
legend('Centro de masa de muslo derecho','Centro de masa pierna derecha','Centro articular cadera derecha','Marcador de talon derecho','Centro articular rodilla derecha','Centro articular tobillo derecho');
xlabel('Eje X');
ylabel('Eje Y');
zlabel('Eje Z');
title('Trayectoria del centro de masa de la mitad derecha del miembro inferior');
grid on;

figure;
plot3(CM_lthigh(:,1),CM_lthigh(:,2),CM_lthigh(:,3),'b--','LineWidth',2);
hold on;
plot3(CM_lcalf(:,1),CM_lcalf(:,2),CM_lcalf(:,3),'b--','LineWidth',2);
hold on;
% plot3(CM_lfoot(:,1),CM_lfoot(:,2),CM_lfoot(:,3),'b--','LineWidth',2); 'Centro de masa pie izquierdo',
% hold on;
plot3(plhip(:,1),plhip(:,2),plhip(:,3),'r','LineWidth',2);
hold on;
plot3(p9(:,1),p9(:,2),p9(:,3),'g','LineWidth',2);
hold on;
% plot3(pltoe(:,1),pltoe(:,2),pltoe(:,3),'k','LineWidth',2);'Centro articular pie izquierdo',
% hold on;
plot3(plknee(:,1),plknee(:,2),plknee(:,3),'y','LineWidth',2);
hold on;
plot3(plankle(:,1),plankle(:,2),plankle(:,3),'b','LineWidth',2);
hold on;
legend('Centro de masa de muslo izquierdo','Centro de masa pierna izquierda','Centro articular de cadera izquierda','Marcador de talon izquierdo','Centro articular rodilla izquierda','Centro articular tobillo izquierdo');
xlabel('Eje X');
ylabel('Eje Y');
zlabel('Eje Z');
title('Trayectoria del centro de masa de la mitad izquierda del miembro inferior');
grid on;

figure;
plot3(CM_lfoot(:,1),CM_lfoot(:,2),CM_lfoot(:,3),'b--','LineWidth',2);
hold on;
plot3(p9(:,1),p9(:,2),p9(:,3),'g','LineWidth',2);
hold on;
plot3(pltoe(:,1),pltoe(:,2),pltoe(:,3),'k','LineWidth',2);
hold on;
legend('Centro de masa pie izquierdo','Marcador de talon izquierdo','Centro articular pie izquierdo');
xlabel('Eje X');
ylabel('Eje Y');
zlabel('Eje Z');
title('Trayectoria del centro de masa del pie izquierdo');

figure;
plot3(CM_rfoot(:,1),CM_rfoot(:,2),CM_rfoot(:,3),'b--','LineWidth',2);
hold on;
plot3(p9(:,1),p9(:,2),p9(:,3),'g','LineWidth',2);
hold on;
plot3(prtoe(:,1),prtoe(:,2),prtoe(:,3),'k','LineWidth',2);
hold on;
legend('Centro de masa pie derecho','Marcador de talon derecho','Centro articular pie derecho');
xlabel('Eje X');
ylabel('Eje Y');
zlabel('Eje Z');
title('Trayectoria del centro de masa del pie derecho');
%% SISTEMAS LOCALES ANCLADOS EN SEGMENTOS
%-----------------------------------PELVIS
ipelvis=wpelvis; 
jpelvis=upelvis;
kpelvis=vpelvis;

%-----------------------------------MUSLO
Num=prhip-prknee;
Den=sqrt(sum(Num.^2,2));
irmuslo=Num./Den;
Num=cross((p6-prhip),(prknee-prhip));
Den=sqrt(sum(Num.^2,2));
jrmuslo=Num./Den;
krmuslo=cross(irmuslo,jrmuslo);




Num=plhip-plknee;
Den=sqrt(sum(Num.^2,2));
ilmuslo=Num./Den;
Num=cross((plknee-plhip),(p13-plhip));
Den=sqrt(sum(Num.^2,2));
jlmuslo=Num./Den;
klmuslo=cross(ilmuslo,jlmuslo);
%-----------------------------------PIERNA

Num=prknee-prankle;
Den=sqrt(sum(Num.^2,2));
irpierna=Num./Den;

Num=cross((p5-prknee),(prankle-prknee));
Den=sqrt(sum(Num.^2,2));
jrpierna=Num./Den;
krpierna=cross(irpierna,jrpierna);

Num=plknee-plankle;
Den=sqrt(sum(Num.^2,2));
ilpierna=Num./Den;

Num=cross((plankle-plknee),(p12-plknee));
Den=sqrt(sum(Num.^2,2));
jlpierna=Num./Den;
klpierna=cross(ilpierna,jlpierna); 

%-----------------------------------PIE
Num=p2-prtoe;
Den=sqrt(sum(Num.^2,2));
irpie=Num./Den;

Num=cross((prankle-p2),(prtoe-p2));
Den=sqrt(sum(Num.^2,2));
krpie=Num./Den;

jrpie=cross(krpie,irpie);



Num=p9-pltoe;
Den=sqrt(sum(Num.^2,2));
ilpie=Num./Den;

Num=cross((plankle-p9),(pltoe-p9));
Den=sqrt(sum(Num.^2,2));
klpie=Num./Den;

jlpie=cross(klpie,ilpie);











%-----------------------------------GRAFICAS
figure;
plot3(p15(:,1),p15(:,2),p15(:,3),'y','LineWidth',2);
hold on;
plot3(CM_rthigh(:,1),CM_rthigh(:,2),CM_rthigh(:,3),'y','LineWidth',2);
hold on;
plot3(CM_lthigh(:,1),CM_lthigh(:,2),CM_lthigh(:,3),'y','LineWidth',2);
hold on;
plot3(CM_rcalf(:,1),CM_rcalf(:,2),CM_rcalf(:,3),'y','LineWidth',2);
hold on;
plot3(CM_lcalf(:,1),CM_lcalf(:,2),CM_lcalf(:,3),'y','LineWidth',2);
hold on;
plot3(CM_rfoot(:,1),CM_rfoot(:,2),CM_rfoot(:,3),'y','LineWidth',2);
hold on;
plot3(CM_lfoot(:,1),CM_lfoot(:,2),CM_lfoot(:,3),'y','LineWidth',2);
hold on;


for i=1:20:length(p15)
    quiver3(p15(i,1),p15(i,2),p15(i,3),ipelvis(i,1)/10,ipelvis(i,2)/10,ipelvis(i,3)/10,'r');
    hold on;
    quiver3(p15(i,1),p15(i,2),p15(i,3),jpelvis(i,1)/10,jpelvis(i,2)/10,jpelvis(i,3)/10,'g');
    hold on;
    quiver3(p15(i,1),p15(i,2),p15(i,3),kpelvis(i,1)/10,kpelvis(i,2)/10,kpelvis(i,3)/10,'b');
    hold on;
end;

for i=1:20:length(p15)
    quiver3(CM_rthigh(i,1),CM_rthigh(i,2),CM_rthigh(i,3),irmuslo(i,1)/10,irmuslo(i,2)/10,irmuslo(i,3)/10,'r');
    hold on;
    quiver3(CM_rthigh(i,1),CM_rthigh(i,2),CM_rthigh(i,3),jrmuslo(i,1)/10,jrmuslo(i,2)/10,jrmuslo(i,3)/10,'g');
    hold on;
    quiver3(CM_rthigh(i,1),CM_rthigh(i,2),CM_rthigh(i,3),krmuslo(i,1)/10,krmuslo(i,2)/10,krmuslo(i,3)/10,'b');
    hold on;
end;

for i=1:20:length(p15)
    quiver3(CM_lthigh(i,1),CM_lthigh(i,2),CM_lthigh(i,3),ilmuslo(i,1)/10,ilmuslo(i,2)/10,ilmuslo(i,3)/10,'r');
    hold on;
    quiver3(CM_lthigh(i,1),CM_lthigh(i,2),CM_lthigh(i,3),jlmuslo(i,1)/10,jlmuslo(i,2)/10,jlmuslo(i,3)/10,'g');
    hold on;
    quiver3(CM_lthigh(i,1),CM_lthigh(i,2),CM_lthigh(i,3),klmuslo(i,1)/10,klmuslo(i,2)/10,klmuslo(i,3)/10,'b');
    hold on;
end;

for i=1:20:length(p15)
    quiver3(CM_rcalf(i,1),CM_rcalf(i,2),CM_rcalf(i,3),irpierna(i,1)/10,irpierna(i,2)/10,irpierna(i,3)/10,'r');
    hold on;
    quiver3(CM_rcalf(i,1),CM_rcalf(i,2),CM_rcalf(i,3),jrpierna(i,1)/10,jrpierna(i,2)/10,jrpierna(i,3)/10,'g');
    hold on;
    quiver3(CM_rcalf(i,1),CM_rcalf(i,2),CM_rcalf(i,3),krpierna(i,1)/10,krpierna(i,2)/10,krpierna(i,3)/10,'b');
    hold on;
end;
for i=1:20:length(p15)
    quiver3(CM_lcalf(i,1),CM_lcalf(i,2),CM_lcalf(i,3),ilpierna(i,1)/10,ilpierna(i,2)/10,ilpierna(i,3)/10,'r');
    hold on;
    quiver3(CM_lcalf(i,1),CM_lcalf(i,2),CM_lcalf(i,3),jlpierna(i,1)/10,jlpierna(i,2)/10,jlpierna(i,3)/10,'g');
    hold on;
    quiver3(CM_lcalf(i,1),CM_lcalf(i,2),CM_lcalf(i,3),klpierna(i,1)/10,klpierna(i,2)/10,klpierna(i,3)/10,'b');
    hold on;
end;
for i=1:20:length(p15)
    quiver3(CM_rfoot(i,1),CM_rfoot(i,2),CM_rfoot(i,3),irpie(i,1)/10,irpie(i,2)/10,irpie(i,3)/10,'r');
    hold on;
    quiver3(CM_rfoot(i,1),CM_rfoot(i,2),CM_rfoot(i,3),jrpie(i,1)/10,jrpie(i,2)/10,jrpie(i,3)/10,'g');
    hold on;
    quiver3(CM_rfoot(i,1),CM_rfoot(i,2),CM_rfoot(i,3),krpie(i,1)/10,krpie(i,2)/10,krpie(i,3)/10,'b');
    hold on;
end;
for i=1:20:length(p15)
    quiver3(CM_lfoot(i,1),CM_lfoot(i,2),CM_lfoot(i,3),ilpie(i,1)/10,ilpie(i,2)/10,ilpie(i,3)/10,'r');
    hold on;
    quiver3(CM_lfoot(i,1),CM_lfoot(i,2),CM_lfoot(i,3),jlpie(i,1)/10,jlpie(i,2)/10,jlpie(i,3)/10,'g');
    hold on;
    quiver3(CM_lfoot(i,1),CM_lfoot(i,2),CM_lfoot(i,3),klpie(i,1)/10,klpie(i,2)/10,klpie(i,3)/10,'b');
    hold on;
end;

legend('Marcador del Sacro','Centro de masa muslo derecho','Centro de masa muslo izquierdo','Centro de masa pierna derecha','Centro de masa pierna izquierda','Centro de masa del pie derecho','Centro de masa del pie izquierdo','i de pelvis','j de pelvis','k de pelvis','i de muslo izquierdo','j de muslo izquierdo','k de muslo izquierdo','i de pierna derecha','j de pierna derecha','k de pierna derecha','i de pierna izquierda','j de pierna izquierda','k de pierna izquierda','i de muslo derecho','j de muslo derecho','k de muslo derecho','i de pie derecho','j de pie derecho','k de pie derecho','i de pie izquierdo','j de pie izquierdo','k de pie izquierdo');
xlabel('Eje X');
ylabel('Eje Y');
zlabel('Eje Z');
title('Trayectoria de marcadores, centro de masa y diagrama de i, j, k sobre marcador de la pelvis y centro de masa de los muslos y piernas');
grid on;


%% CALCULO DE ANGULOS

%CADERA DERECHA

Num = cross(kpelvis,irmuslo);
Den = sqrt(sum(Num.^2,2));
Irighthip=Num./Den;

Ccader = dot(Irighthip,ipelvis,2);
alfarighthip = asind(Ccader); %FLEXION-EXTENSION

Dcadder = dot(kpelvis,irmuslo,2);
betarighthip = asind(Dcadder); %ABDUCCION-ADUCCION

Ecadder = dot(Irighthip,krmuslo,2);
gamarighthip = -asind(Ecadder);  %ROTACION INTERNA-ROTACION EXTERNA

%CADERA IZQUIERDA

Num = cross(kpelvis,ilmuslo);
Den = sqrt(sum(Num.^2,2));
Ilefthip=Num./Den;

Ccader = dot(Ilefthip,ipelvis,2);
alfalefthip = asind(Ccader); %FLEXION-EXTENSION

Dcadder = dot(kpelvis,ilmuslo,2);
betalefthip = -asind(Dcadder); %ABDUCCION-ADUCCION

Ecadder = dot(Ilefthip,klmuslo,2);
gamalefthip = asind(Ecadder);  %ROTACION INTERNA-ROTACION EXTERNA


%RODILLA DERECHA

Num = cross(krmuslo,irpierna);
Den = sqrt(sum(Num.^2,2));
Irightrodilla=Num./Den;

Ccader = dot(Irightrodilla,irmuslo,2);
alfarightrodilla = -asind(Ccader); %FLEXION-EXTENSION

Dcadder = dot(krmuslo,irpierna,2);
betarightrodilla = asind(Dcadder); %ABDUCCION-ADUCCION

Ecadder = dot(Irightrodilla,krpierna,2);
gamarightrodilla = -asind(Ecadder);  %ROTACION INTERNA-ROTACION EXTERNA

%RODILLA IZQUIERDA

Num = cross(klmuslo,ilpierna);
Den = sqrt(sum(Num.^2,2));
Ileftrodilla=Num./Den;

Ccader = dot(Ileftrodilla,ilmuslo,2);
alfaleftrodilla = -asind(Ccader); %FLEXION-EXTENSION

Dcadder = dot(klmuslo,ilpierna,2);
betaleftrodilla = -asind(Dcadder); %ABDUCCION-ADUCCION

Ecadder = dot(Ileftrodilla,klpierna,2);
gamaleftrodilla = asind(Ecadder);  %ROTACION INTERNA-ROTACION EXTERNA


%TOBILLO DERECHO

Num = cross(krpierna,irpie);
Den = sqrt(sum(Num.^2,2));
Irighttobillo=Num./Den;

Ccader = dot(Irighttobillo,jrpierna,2);
alfarighttobillo = -asind(Ccader); %DORSIFLEXION-PLANTAFLEXION

Dcadder = dot(krpierna,irpie,2);
betarighttobillo = asind(Dcadder); %ABDUCCION-ADUCCION

Ecadder = dot(Irighttobillo,krpie,2);
gamarighttobillo = asind(Ecadder);  %INVERSION-EVERSION


%TOBILLO IZQUIERDO

Num = cross(klpierna,ilpie);
Den = sqrt(sum(Num.^2,2));
Ilefttobillo=Num./Den;

Ccader = dot(Ilefttobillo,jlpierna,2);
alfalefttobillo = -asind(Ccader); %DORSIFLEXION-PLANTAFLEXION

Dcadder = dot(klpierna,ilpie,2);
betalefttobillo = -asind(Dcadder); %ABDUCCION-ADUCCION

Ecadder = dot(Ilefttobillo,klpie,2);
gamalefttobillo = -asind(Ecadder);  %INVERSION-EVERSION


%% RECORTO E INTERPOLO A 100 MUESTRAS
%------------------------------------------------------CADERA
alfarighthip = alfarighthip(RHS1-inicio:RHS2-inicio);
betarighthip = betarighthip(RHS1-inicio:RHS2-inicio);
gamarighthip = gamarighthip(RHS1-inicio:RHS2-inicio);

alfalefthip = alfalefthip(1:LHS2-inicio);
betalefthip = betalefthip(1:LHS2-inicio);
gamalefthip = gamalefthip(1:LHS2-inicio);

alfarighthip = InterpolaA100Muestras(alfarighthip);
alfalefthip = InterpolaA100Muestras(alfalefthip);
betarighthip = InterpolaA100Muestras(betarighthip);
betalefthip = InterpolaA100Muestras(betalefthip);
gamarighthip = InterpolaA100Muestras(gamarighthip);
gamalefthip = InterpolaA100Muestras(gamalefthip);

%-------------------------------------------------------RODILLA
alfarightrodilla = alfarightrodilla(RHS1-inicio:RHS2-inicio);
betarightrodilla = betarightrodilla(RHS1-inicio:RHS2-inicio);
gamarightrodilla = gamarightrodilla(RHS1-inicio:RHS2-inicio);

alfaleftrodilla = alfaleftrodilla(1:LHS2-inicio);
betaleftrodilla = betaleftrodilla(1:LHS2-inicio);
gamaleftrodilla = gamaleftrodilla(1:LHS2-inicio);

alfarightrodilla = InterpolaA100Muestras(alfarightrodilla);
alfaleftrodilla = InterpolaA100Muestras(alfaleftrodilla);
betarightrodilla = InterpolaA100Muestras(betarightrodilla);
betaleftrodilla = InterpolaA100Muestras(betaleftrodilla);
gamarightrodilla = InterpolaA100Muestras(gamarightrodilla);
gamaleftrodilla = InterpolaA100Muestras(gamaleftrodilla);

%------------------------------------------------------------TOBILLO
alfarighttobillo = alfarighttobillo(RHS1-inicio:RHS2-inicio);
betarighttobillo = betarighttobillo(RHS1-inicio:RHS2-inicio);
gamarighttobillo = gamarighttobillo(RHS1-inicio:RHS2-inicio);

alfalefttobillo = alfalefttobillo(1:LHS2-inicio);
betalefttobillo = betalefttobillo(1:LHS2-inicio);
gamalefttobillo = gamalefttobillo(1:LHS2-inicio);

alfarighttobillo = InterpolaA100Muestras(alfarighttobillo);
alfalefttobillo = InterpolaA100Muestras(alfalefttobillo);
gamarighttobillo = InterpolaA100Muestras(gamarighttobillo);
gamalefttobillo = InterpolaA100Muestras(gamalefttobillo);
betarighttobillo = InterpolaA100Muestras(betarighttobillo);
betalefttobillo = InterpolaA100Muestras(betalefttobillo);

%% MOSTRAR LOS ANGULOS

% figure;
% plot(alfarighthip,'r');
% hold on;
% plot(alfalefthip, 'b');
% title('Angulo de flexion (+) y extension (-) de cadera');
% ylabel('Grados');
% grid on;
%hay q recortar solo un ciclo



figure;
plot(alfarighthip,'r');
hold on;
plot(alfalefthip, 'b');
title('Angulo de flexion (+) y extension (-) de cadera');
ylabel('Grados');
grid on;



figure;
plot(alfarightrodilla,'r');
hold on;
plot(alfaleftrodilla, 'b');
title('Angulo de flexion (+) y extension (-) de rodillas');
ylabel('Grados');
grid on;


figure;
plot(alfarighttobillo,'r');
hold on;
plot(alfalefttobillo, 'b');
title('Angulo de dorsiflexion (+) y plantaextension (-) de tobillos');
ylabel('Grados');
grid on;


figure;
plot(gamarighttobillo,'r');
hold on;
plot(gamalefttobillo, 'b');
title('Ángulo de abduccion (+) y aduccion (-) de tobillos');
ylabel('Grados');
grid on;

figure;
plot(betarighttobillo,'r');
hold on;
plot(betalefttobillo, 'b');
title('Ángulo de inversion (+) y eversion (-) de tobillos');
ylabel('Grados');
grid on;




%% LE PEDI A GPT QUE ME HAGA LOS GRAFICOS 



% Definir los títulos de las filas y columnas
filas = {'CADERA','RODILLA','TOBILLO'};
columnas = {'ALFA','BETA','GAMA'};

% Crear la figura y ajustar su tamaño
figure('Name','Angulos Articulares');
set(gcf,'Position',[50 50 800 600]);

% Iterar sobre las filas y columnas para graficar cada variable en su posición correspondiente
for i = 1:3
    for j = 1:3
        % Definir el título de cada sub-gráfico
        titulo = sprintf('%s de %s',columnas{j},filas{i});
        
        % Seleccionar la variable a graficar en función de la posición actual
        switch i
            case 1
                switch j
                    case 1
                        data1 = alfarighthip;
                        data2 = alfalefthip;
                    case 2
                        data1 = betarighthip;
                        data2 = betalefthip;
                    case 3
                        data1 = gamarighthip;
                        data2 = gamalefthip;
                end
            case 2
                switch j
                    case 1
                        data1 = alfarightrodilla;
                        data2 = alfaleftrodilla;
                    case 2
                        data1 = betarightrodilla;
                        data2 = betaleftrodilla;
                    case 3
                        data1 = gamarightrodilla;
                        data2 = gamaleftrodilla;
                end
            case 3
                switch j
                    case 1
                        data1 = alfarighttobillo;
                        data2 = alfalefttobillo;
                    case 2
                        data1 = betarighttobillo;
                        data2 = betalefttobillo;
                    case 3
                        data1 = gamarighttobillo;
                        data2 = gamalefttobillo;
                end
        end
        
        % Crear el sub-gráfico y graficar las variables
        subplot(3,3,(i-1)*3+j);
        plot(data1,'r');
        hold on;
        plot(data2,'b');
        title(titulo);
        ylabel('Grados');
        grid on;
        
        % Añadir etiquetas de eje X únicamente a los gráficos de la última fila
        if i == 3
            xlabel('% Ciclo');
        end
    end
end

% Añadir un título general a toda la figura
sgtitle('Angulos Articulares');
