function [Datos,fileName] = CargarRegistro();
% El llamado a esta funci�n permite cargar el archivo c3d. AHORA tiene la ventaja que los archivos pueden estar en cualquier carpeta del r�gido 
% y no hace falta cambiar de directorio. Este cambio permite conservar la ruta y el nombre del archivo y mantener el directorio actual sin mover.
% esta funci�n no requiere ningun par�metro de ida y regresa con par�mtros:
% "Datos" donde est� toda la estructura del registro y 
 %"Archivo" que es solamente el nombre del archivo que permite ver en el workspace el archivo sobre el que estoy trabajando


[DatosMarcadores, infoCinematica,Fuerzas,infoDinamica,Antropometria,Eventos,fileName]= leer_c3d();
Datos.Pasada.Marcadores.Crudos=DatosMarcadores;% Se asignan los datos de los marcadores a esta parte de la estructura
Datos.Pasada.Fuerzas=Fuerzas % Se asignan los datos de la plataforma1 a esta parte de la estructura
Datos.info.Cinematica=infoCinematica; % Se asignan los datos de la informaci�n cin�matica a esta parte de la estructura
Datos.info.Dinamica=infoDinamica; % Se asignan los datos de la informaci�n de plataforma de fuerzas a esta parte de la estructura
Datos.antropometria=Antropometria; %  Se asignan los datos de antropometr�a a esta parte de la estructura
Datos.eventos=Eventos; %  Se asignan los datos de los instantes de tiempo en que se producen los eventos del ciclo de marcha a esta parte de la estructura
%cd(Ubact);