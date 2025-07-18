unit ARCHIVO_TER;
interface
uses
  crt,sysutils;

const
  RUTA_TERRENOS='C:\archivos\terrenos.dat';

  RUTA_TERRENOS_AUX='C:\archivos\terrenos_aux.dat';

Type

  t_dato_terreno=record
    num_con:word;
    num_mensura:word;
    avaluo:real;
    fecha_ins:string[10];
    dom_par:string[40];
    superficie_terreno:real;
    zona:byte;
    tipo_edif:byte;
  end;

     t_archivo_terreno=file of t_dato_terreno;

Procedure crear_abrir_ter (VAR ARCH_TER:t_archivo_terreno);
Procedure crear_abrir_ter_aux (VAR ARCH_AUX:t_archivo_terreno);
Procedure cerrar_ter (VAR ARCH_TER:t_archivo_terreno);
Procedure borrar_arch_ter(VAR ARCH_TER:t_archivo_terreno);
Procedure obtener_reg_arch_ter(VAR ARCH_TER:t_archivo_terreno;I:word; VAR X:t_dato_terreno);
Procedure ingresar_dato_ter(VAR ARCH_TER:t_archivo_terreno;X:t_dato_terreno;pos:word);
Function convertir_fecha(X:t_dato_terreno):string;
Function mayor_reg (REG:t_dato_terreno;X:t_dato_terreno):boolean;
//Procedure desplazar_arch_ter(VAR ARCH_TER:t_archivo_terreno;pos:word);
Procedure ordenar_archivo_ter(VAR ARCH_TER:t_archivo_terreno);
Procedure ingresar_dato_arch_ter(VAR ARCH_TER:t_archivo_terreno;X:t_dato_terreno);
Procedure guarda_terrenos(VAR ARCH_TER:t_archivo_terreno; VAR ARCH_AUX:t_archivo_terreno; I:word);
Procedure devuelve_terrenos(VAR ARCH_TER:t_archivo_terreno; VAR ARCH_AUX:t_archivo_terreno; I:word);
Procedure cerrar_borrar_ter_aux(VAR ARCH_AUX:t_archivo_terreno);
Procedure bajar_terreno(VAR ARCH_TER:t_archivo_terreno;J:word);
Procedure REINICIAR_ARCHIVO_TER(VAR ARCH_TER:t_archivo_terreno);

implementation

Procedure crear_abrir_ter (VAR ARCH_TER:t_archivo_terreno);
begin
  assign(ARCH_TER,RUTA_TERRENOS);
  {$I-}
  reset(ARCH_TER);
  {$I+}
  If IOResult<>0 then
   rewrite(ARCH_TER);
end;

Procedure crear_abrir_ter_aux (VAR ARCH_AUX:t_archivo_terreno);
begin
  assign(ARCH_AUX,RUTA_TERRENOS_AUX);
  {$I-}
  reset(ARCH_AUX);
  {$I+}
  If IOResult<>0 then
   rewrite(ARCH_AUX);
end;

Procedure cerrar_ter (VAR ARCH_TER:t_archivo_terreno);
begin
  close(ARCH_TER);
end;

Procedure borrar_arch_ter(VAR ARCH_TER:t_archivo_terreno);
begin
  close(ARCH_TER);
  erase(ARCH_TER);
end;

Procedure obtener_reg_arch_ter(VAR ARCH_TER:t_archivo_terreno;I:word; VAR X:t_dato_terreno);
begin
  seek(ARCH_TER,I);
  read(ARCH_TER,X);
end;

Procedure ingresar_dato_ter(VAR ARCH_TER:t_archivo_terreno;X:t_dato_terreno;pos:word);
begin
  seek(ARCH_TER,pos);
  write(ARCH_TER,X);
end;
{
Procedure desplazar_arch_ter(VAR ARCH_TER:t_archivo_terreno;pos:word);
VAR
  aux1:t_dato_terreno;
  aux2:t_dato_terreno;
  I:word;
begin
  seek(ARCH_TER,pos);
  read(ARCH_TER,aux1);
  If filesize(ARCH_TER)>1 then
    For I:=pos to filesize(ARCH_TER)-1 do
    begin
      seek(ARCH_TER,I+1);
      read(ARCH_TER,aux2);
      write(ARCH_TER,aux1);
      aux1:=aux2;
    end;
  seek(ARCH_TER,filesize(ARCH_TER));
  write(ARCH_TER,aux1);
end;
}
Function convertir_fecha(X:t_dato_terreno):string;
VAR
  auxA:string[4];
  auxM:string[2];
  auxD:string[2];
begin
  auxA:=copy(X.fecha_ins,7,4);
  auxM:=copy(X.fecha_ins,4,2);
  auxD:=copy(X.fecha_ins,1,2);
  convertir_fecha:=auxA+auxM+auxD;
end;

Function mayor_reg (REG:t_dato_terreno;X:t_dato_terreno):boolean;
VAR
  auxX:integer;
  auxREG:integer;
begin
  auxX:=StrToInt(X.fecha_ins);
  auxREG:=StrToInt(REG.fecha_ins);
  If REG.num_con + auxREG > X.num_con + auxX then
  begin
    mayor_reg:=true;
  end
  else
  begin
    mayor_reg:=false;
  end;
end;

Procedure ordenar_archivo_ter(VAR ARCH_TER:t_archivo_terreno);
VAR
 I,J:word;
 X,Xsig:t_dato_terreno;
 Xcad,Xsigcad:string;
 valorx,valorxsig:integer;
begin
  For I:=0 to filesize(ARCH_TER)-1 do
   For J:=0 to filesize(ARCH_TER)-2 do
   begin
     obtener_reg_arch_ter(ARCH_TER,J,X);
     obtener_reg_arch_ter(ARCH_TER,J+1,Xsig);
     Xcad:=convertir_fecha(X);
     valorx:=StrToInt(Xcad);
     valorx:=valorx+X.num_con;
     Xsigcad:=convertir_fecha(Xsig);
     valorxsig:=StrToInt(Xsigcad);
     valorxsig:=valorxsig+Xsig.num_con;
     If valorx>valorxsig then
     begin
       ingresar_dato_ter(ARCH_TER,X,J+1);
       ingresar_dato_ter(ARCH_TER,Xsig,J);
     end;
   end;
end;

Procedure ingresar_dato_arch_ter(VAR ARCH_TER:t_archivo_terreno;X:t_dato_terreno);
{VAR
  Xnum,REGnum:string;
  valorX:integer;
  REG:t_dato_terreno;
  valorREG:integer;
  I:word; }
begin
  ingresar_dato_ter(ARCH_TER,X,filesize(ARCH_TER));
  If filesize(ARCH_TER)>1 then
  begin
    ordenar_archivo_ter(ARCH_TER);
  end;
 { If filesize(ARCH_TER)>0 then
  begin
    seek(ARCH_TER,0);
    read(ARCH_TER,REG);
    Xnum:=convertir_fecha(X);
    valorx:=StrToInt(Xnum);
    valorx:=valorx+X.num_con;
    REGnum:=convertir_fecha(REG);
    valorREG:=StrToInt(REGnum);
    valorREG:=valorREG+REG.num_con;
    If valorREG>valorx then
    begin
      desplazar_arch_ter(ARCH_TER,0);
      ingresar_dato_ter(ARCH_TER,X,0);
    end
    else
    begin
      I:=0;
      while (valorREG<valorx) and (I<filesize(ARCH_TER)-1) do
      begin
        I:=I+1;
        seek(ARCH_TER,I);
        read(ARCH_TER,REG);
        REGnum:=convertir_fecha(REG);
        valorREG:=StrToInt(REGnum);
        valorREG:=valorREG+REG.num_con;
      end;
      desplazar_arch_ter(ARCH_TER,I);
      ingresar_dato_ter(ARCH_TER,X,I);
    end;
  end
  else
  begin
    ingresar_dato_ter(ARCH_TER,X,0);
  end;}
end;

Procedure guarda_terrenos(VAR ARCH_TER:t_archivo_terreno; VAR ARCH_AUX:t_archivo_terreno; I:word);
VAR
  REG:t_dato_terreno;
begin
   seek(ARCH_TER,I);
   read(ARCH_TER,REG);
   seek(ARCH_AUX,filesize(ARCH_AUX));
   write(ARCH_AUX,REG);
end;

Procedure devuelve_terrenos(VAR ARCH_TER:t_archivo_terreno; VAR ARCH_AUX:t_archivo_terreno; I:word);
VAR
  REG:t_dato_terreno;
begin
  seek(ARCH_AUX,I);
  read(ARCH_AUX,REG);
  seek(ARCH_TER,filesize(ARCH_TER));
  write(ARCH_TER,REG);
end;

Procedure cerrar_borrar_ter_aux(VAR ARCH_AUX:t_archivo_terreno);
begin
  close(ARCH_AUX);
  erase(ARCH_AUX);
end;

Procedure bajar_terreno(VAR ARCH_TER:t_archivo_terreno;J:word);
VAR
  ARCH_AUX:t_archivo_terreno;
  REG:t_dato_terreno;
  I:word;
begin
  crear_abrir_ter_aux(ARCH_AUX);
  If filesize(ARCH_TER)>0 then
    For I:=0 to filesize(ARCH_TER)-1 do
     If I<>J then
      guarda_terrenos(ARCH_TER,ARCH_AUX,I);
 { If filesize(ARCH_TER)=1 then
  begin
    guarda_terrenos(ARCH_TER,ARCH_AUX,0);
  end
  else
  begin
    If filesize(ARCH_TER)=2 then
    begin
      If J=1 then
      begin
        guarda_terrenos(ARCH_TER,ARCH_AUX,1);
      end
      else
      begin
        guarda_terrenos(ARCH_TER,ARCH_AUX,0);
      end;
    end
    else
    begin
      If J=0 then
      begin
        For I:=1 to filesize(ARCH_TER)-1 do
        begin
          guarda_terrenos(ARCH_TER,ARCH_AUX,I);
        end;
      end
      else
      begin
        If J=filesize(ARCH_TER)-1 then
        begin
          For I:=0 to filesize(ARCH_TER)-2 do
          begin
            guarda_terrenos(ARCH_TER,ARCH_AUX,I);
          end;
        end
        else
        begin
          For I:=0 to J-1 do
          begin
            guarda_terrenos(ARCH_TER,ARCH_AUX,I);
          end;
        end;
      end;
    end;
  end;   }
  {If filesize(ARCH_TER)>2 then
  begin
    If (J<>0) then
    begin
      If (J<>filesize(ARCH_TER)-1) then
      begin
      For I:=0 to J-1 do
         guarda_terrenos(ARCH_TER,ARCH_AUX,I);
      For I:=J+1 to filesize(ARCH_TER)-1 do
         guarda_terrenos(ARCH_TER,ARCH_AUX,I);
      end
      else
      begin
       For I:=0 to J-1 do
         guarda_terrenos(ARCH_TER,ARCH_AUX,I);
      end;
    end
    else
    begin
      For I:=1 to filesize(ARCH_TER)-1 do
        guarda_terrenos(ARCH_TER,ARCH_AUX,I);
    end;
  end
  else
  begin
      If filesize(ARCH_TER)=2 then
      begin
      If J=0 then
      begin
       guarda_terrenos(ARCH_TER,ARCH_AUX,J+1);
      end
      else
      begin
        guarda_terrenos(ARCH_TER,ARCH_AUX,J);
    end;
   end;
  end;}
    borrar_arch_ter(ARCH_TER);
    crear_abrir_ter(ARCH_TER);
    If filesize(ARCH_AUX)>0 then
      For I:=0 to filesize(ARCH_AUX)-1 do
      begin
        devuelve_terrenos(ARCH_TER,ARCH_AUX,I);
      end;
   cerrar_borrar_ter_aux(ARCH_AUX);
end;

Procedure REINICIAR_ARCHIVO_TER(VAR ARCH_TER:t_archivo_terreno);
VAR
  resp:string;
begin
  repeat
   clrscr;
   writeln('SE REINICIARA EL ARCHIVO DE PROPIETARIOS ¿CONTINUA? INGRESE SI O NO');
   readln(resp);
   resp:=UpCase(copy(resp,1,1))+UpCase(copy(resp,2,1));
  until (resp='SI') or (resp='NO');
  If resp='SI' then
  begin
  close(ARCH_TER);
  rewrite(ARCH_TER);
  end;
end;

end.

