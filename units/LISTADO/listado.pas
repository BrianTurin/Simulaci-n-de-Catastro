unit LISTADO;
interface
uses
  MARCO,crt,ARCHIVO_TER,ABMC_TERRENOS,sysutils;
Procedure leer_anio(VAR anio:string);
Procedure crear_arch_ter_aux_anio(VAR ARCH_TER:t_archivo_terreno;VAR ARCH_AUX:t_archivo_terreno;anio:string);
Procedure ordenar_arch_ter_aux_anio(VAR ARCH_AUX:t_archivo_terreno);
Procedure mostrar_arch_ter_aux(VAR ARCH_AUX:t_archivo_terreno);
Procedure LISTADO_ANIO (VAR ARCH_TER:t_archivo_terreno);
Function existe_anio(VAR ARCH_TER:t_archivo_terreno;anio:string):boolean;
Procedure generar_arch_aux_zona(VAR ARCH_TER:t_archivo_terreno;VAR ARCH_AUX:t_archivo_terreno);
Procedure cerrar_borrar_arch_ter_aux(VAR ARCH_AUX:t_archivo_terreno);
Procedure LISTADO_POR_ZONA (VAR ARCH_TER:t_archivo_terreno);

implementation

Procedure leer_anio(VAR anio:string);
begin
  clrscr;
  BOX;
  gotoxy(30,10);
  writeln('INGRESE ANIO. EJ: 2022');
  gotoxy(30,11);
  readln(anio);
end;

Procedure crear_arch_ter_aux_anio(VAR ARCH_TER:t_archivo_terreno;VAR ARCH_AUX:t_archivo_terreno;anio:string);
VAR
  I,J:word;
  anio_aux:string;
  X:t_dato_terreno;
begin
  J:=0;
  For I:=0 to filesize(ARCH_TER)-1 do
  begin
   obtener_reg_arch_ter(ARCH_TER,I,X);
   anio_aux:=convertir_fecha(X);
   If anio=copy(anio_aux,1,4) then
   begin
     seek(ARCH_AUX,filesize(ARCH_AUX));
     write(ARCH_AUX,X);
     //ingresar_dato_ter(ARCH_AUX,X,J);
     J:=J+1;
   end;
  end;
end;

Procedure ordenar_arch_ter_aux_anio(VAR ARCH_AUX:t_archivo_terreno);
VAR
  I,J:word;
  X,Xsig:t_dato_terreno;
  fecha,fechasig:string;
begin
  If filesize(ARCH_AUX)>1 then
  For I:=0 to filesize(ARCH_AUX)-1 do
   For J:=0 to filesize(ARCH_AUX)-2 do
    begin
      obtener_reg_arch_ter(ARCH_AUX,J,X);
      obtener_reg_arch_ter(ARCH_AUX,J+1,Xsig);
      fecha:=convertir_fecha(X);
      fechasig:=convertir_fecha(Xsig);
      If fecha>fechasig then
      begin
        ingresar_dato_ter(ARCH_AUX,X,J+1);
        ingresar_dato_ter(ARCH_AUX,Xsig,J);
      end;
    end;
end;

Procedure  mostrar_arch_ter_aux(VAR ARCH_AUX:t_archivo_terreno);
VAR
  I:word;
  X:t_dato_terreno;
begin
  For I:=0 to filesize(ARCH_AUX)-1 do
   begin
     clrscr;
     obtener_reg_arch_ter(ARCH_AUX,I,X);
     mostrar_terreno(X);
   end;
end;

Function existe_anio(VAR ARCH_TER:t_archivo_terreno;anio:string):boolean;
VAR
  I:word;
  X:t_dato_terreno;
  cadena:string;
begin
  I:=0;
  obtener_reg_arch_ter(ARCH_TER,I,X);
  cadena:=convertir_fecha(X);
  existe_anio:=anio=copy(cadena,1,4);
  while (I<filesize(ARCH_TER)-1) and not existe_anio do
  begin
    obtener_reg_arch_ter(ARCH_TER,I,X);
    I:=I+1;
    cadena:=convertir_fecha(X);
    existe_anio:=anio=copy(cadena,1,4);
  end;
  {If length(anio)<>4 then
  begin
    existe_anio:=false;
  end
  else
  begin
    while (I<filesize(ARCH_TER)-1) and (existe_anio=false) do
    begin
      obtener_reg_arch_ter(ARCH_TER,I,X);
      I:=I+1;
      cadena:=convertir_fecha(X);
      cadena:=copy(cadena,1,4);
      If anio=cadena then
        existe_anio:=true;   }
     { cadena:=convertir_fecha(X);
      If anio=copy(cadena,1,4) then }
    {end;
  end;}
end;

Procedure LISTADO_ANIO (VAR ARCH_TER:t_archivo_terreno);
VAR
  anio:string;
  ARCH_AUX:t_archivo_terreno;
begin
 If filesize(ARCH_TER)>0 then
 begin
  crear_abrir_ter_aux(ARCH_AUX);
  leer_anio(anio);
  If existe_anio(ARCH_TER,anio) then
  begin
    crear_arch_ter_aux_anio(ARCH_TER,ARCH_AUX,anio);
    ordenar_arch_ter_aux_anio(ARCH_AUX);
    mostrar_arch_ter_aux(ARCH_AUX);
    cerrar_borrar_arch_ter_aux(ARCH_AUX);
  end
  else
  begin
    clrscr;
    BOX;
    gotoxy(30,10);
    writeln('NO EXISTEN TERRENOS INGRESADOS EN ESE ANIO');
    cerrar_borrar_arch_ter_aux(ARCH_AUX);
    readkey;
  end;
 end
 else
 begin
   clrscr;
   BOX;
   gotoxy(30,10);
   writeln('NO EXISTEN TERRENOS');
   readkey;
 end;
end;
Procedure generar_arch_aux_zona(VAR ARCH_TER:t_archivo_terreno;VAR ARCH_AUX:t_archivo_terreno);
VAR
  I,J:word;
  X,Xsig:t_dato_terreno;
  zona1,zona2:byte;
begin
  For I:=0 to filesize(ARCH_TER)-1 do
   For J:=0 to filesize(ARCH_TER)-2 do
    begin
      obtener_reg_arch_ter(ARCH_AUX,J,X);
      obtener_reg_arch_ter(ARCH_AUX,J+1,Xsig);
      zona1:=X.zona;
      zona2:=Xsig.zona;
        If zona1>zona2 then
        begin
          ingresar_dato_ter(ARCH_AUX,X,J+1);
          ingresar_dato_ter(ARCH_AUX,Xsig,J);
        end
        else
        begin
          ingresar_dato_ter(ARCH_AUX,X,J);
          ingresar_dato_ter(ARCH_AUX,Xsig,J+1);
        end;
    end;
end;

Procedure cerrar_borrar_arch_ter_aux(VAR ARCH_AUX:t_archivo_terreno);
begin
 close(ARCH_AUX);
 erase(ARCH_AUX);
end;

Procedure LISTADO_POR_ZONA (VAR ARCH_TER:t_archivo_terreno);
VAR
  ARCH_AUX:t_archivo_terreno;
  I:byte;
  J:word;
  REG:t_dato_terreno;
begin
 If filesize(ARCH_TER)>0 then
 begin
  For I:=1 to 5 do
  begin
    clrscr;
    BOX;
    gotoxy(30,10);
    writeln('TERRENOS ZONA NUMERO ',I);
    readkey;
    For J:=0 to filesize(ARCH_TER)-1 do
    begin
      obtener_reg_arch_ter(ARCH_TER,J,REG);
      If REG.zona=I then
      begin
         clrscr;
         mostrar_terreno(REG);
         writeln('');
      end;
    end;
    readkey;
  end;
  {crear_abrir_ter_aux(ARCH_AUX);
  generar_arch_aux_zona(ARCH_TER,ARCH_AUX);
  mostrar_arch_ter_aux(ARCH_AUX);
  cerrar_borrar_arch_ter_aux(ARCH_AUX);}
 end
 else
 begin
   clrscr;
   BOX;
   gotoxy(30,10);
   writeln('NO EXISTEN TERRENOS');
   readkey;
 end;
end;

end.

