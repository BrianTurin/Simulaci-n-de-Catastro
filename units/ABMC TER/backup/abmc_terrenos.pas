unit ABMC_TERRENOS;

{$mode ObjFPC}{$H+}

interface

uses
  ARBOLES,ARCHIVO_PROPIETARIOS,ARCHIVO_TER,sysutils,crt,ABMC_PROPIETARIOS,MARCO;

Function mayor_reg (REG:t_dato_terreno;X:t_dato_terreno):boolean;
Procedure leer_t_dato_terreno(VAR X:t_dato_terreno);
Procedure ALTA_TERRENO(VAR ARCH_TER:t_archivo_terreno);
//Procedure leer_datos(VAR DNI:integer; VAR num_men:word);
Procedure seleccionar_terreno(VAR ARCH_TER:t_archivo_terreno;I:word;num_con:word);
Function sin_terreno(VAR ARCH_TER:t_archivo_terreno;num_con:word):boolean;
Procedure borrar_terreno(VAR ARCH_PROP:t_archivo_propietario;VAR ARCH_TER:t_archivo_terreno;pos:word);
Procedure BAJA_TERRENO(VAR ARCH_PROP:t_archivo_propietario;VAR ARCH_TER:t_archivo_terreno;VAR RAIZ_DNI:t_puntero_DNI);
Procedure primer_terreno(VAR ARCH_TER:t_archivo_terreno;num_con:word;VAR I:word);
Procedure leer_modificacion_ter(VAR REG:t_dato_terreno);
Procedure modifica_ter(VAR ARCH_TER:t_archivo_terreno;num_con:word);
Procedure MODIFICACION_TERRENO(VAR ARCH_TER:t_archivo_terreno;VAR ARCH_PROP:t_archivo_propietario;VAR RAIZ_DNI:t_puntero_DNI);
Procedure mostrar_terreno(REG_TER:t_dato_terreno);
Procedure CONSULTA_TERRENO (VAR ARCH_TER:t_archivo_terreno;VAR ARCH_PROP:t_archivo_propietario;RAIZ_DNI:t_puntero_DNI;VAR DNI:integer;VAR ENC:boolean);
Procedure MENU_ABMC_TERRENOS(VAR ARCH_TER:t_archivo_terreno;VAR ARCH_PROP:t_archivo_propietario;VAR RAIZ_DNI:t_puntero_DNI);
Procedure estados(VAR ARCH_PROP:t_archivo_propietario;VAR ARCH_TER:t_archivo_terreno);

implementation

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

Procedure leer_t_dato_terreno(VAR X:t_dato_terreno);
begin
  clrscr;
  BOX;
  gotoxy(20,10);
  writeln('NUMERO DE CONTRIBUYENTE: ');
  gotoxy(60,10);
  readln(X.num_con);
  gotoxy(20,11);
  writeln('NUMERO DE MENSURA');
  gotoxy(60,11);
  readln(X.num_mensura);
  gotoxy(20,12);
  writeln('AVALUO');
  gotoxy(60,12);
  readln(X.avaluo);
  gotoxy(20,13);
  writeln('FECHA DE INSCRIPCION: DD/MM/AAAA');
  gotoxy(60,13);
  readln(X.fecha_ins);
  gotoxy(20,14);
  writeln('DOMICILIO PARCELARIO');
  gotoxy(60,14);
  readln(X.dom_par);
  gotoxy(20,15);
  writeln('SUPERFICIE DEL TERRENO(SIN UNIDADES)');
  gotoxy(60,15);
  readln(X.superficie_terreno);
  gotoxy(20,16);
  writeln('ZONA');
  gotoxy(60,16);
  readln(X.zona);
  gotoxy(20,17);
  writeln('TIPO DE EDIFICACION');
  gotoxy(60,17);
  readln(X.tipo_edif);
end;

Procedure ALTA_TERRENO(VAR ARCH_TER:t_archivo_terreno);
VAR
  X:t_dato_terreno;
begin
  clrscr;
  leer_t_dato_terreno(X);
  ingresar_dato_arch_ter(ARCH_TER,X);
  gotoxy(20,20);
  writeln('TERRENO INGRESADO SATISFACTORIAMENTE');
  readkey;
end;

{Procedure leer_datos(VAR DNI:integer; VAR num_men:word);
begin
  writeln('DNI DE PROPIETARIO');
  readln(DNI);
  writeln('NUMERO DE PLANO DE MENSURA');
  readln(num_men);
end;}

Procedure seleccionar_terreno(VAR ARCH_TER:t_archivo_terreno;I:word;num_con:word);
VAR
  num_mensura:word;
  REG_TER:t_dato_terreno;
  J:word;
begin
  repeat
    clrscr;
    writeln('INGRESE NUMERO DE PLANO DE MENSURA U INGRESE 0 PARA SALIR');
    readln(num_mensura);
    If num_mensura<>0 then
    begin
      obtener_reg_arch_ter(ARCH_TER,0,REG_TER);
      J:=0;
      while (REG_TER.num_mensura<>num_mensura) and (REG_TER.num_con=num_con) and (J<filesize(ARCH_TER)) do
      begin
        J:=J+1;
        obtener_reg_arch_ter(ARCH_TER,J,REG_TER);
      end;
      If REG_TER.num_mensura=num_mensura then
      begin
        bajar_terreno(ARCH_TER,J);
        writeln('TERRENO DADO DE BAJA');
        readkey;
      end
      else
      begin
        writeln('TERRENO NO ENCONTRADO');
        readkey;
      end;
    end;
  until num_mensura=0;
end;

Function sin_terreno(VAR ARCH_TER:t_archivo_terreno;num_con:word):boolean;
VAR
  REG:t_dato_terreno;
  I:word;
begin
  I:=0;
  If filesize(ARCH_TER)>0 then
    repeat
     obtener_reg_arch_ter(ARCH_TER,I,REG);
     I:=I+1;
    until (REG.num_con=num_con) or (I=filesize(ARCH_TER));
  sin_terreno:=REG.num_con<>num_con;
    {obtener_reg_arch_ter(ARCH_TER,0,REG);
    while (REG.num_con<num_con) and (I<filesize(ARCH_TER)-1) do
    begin
      I:=I+1;
      obtener_reg_arch_ter(ARCH_TER,I,REG);
    end;
    sin_terreno:=REG.num_con=num_con;}
end;

Procedure borrar_terreno(VAR ARCH_PROP:t_archivo_propietario;VAR ARCH_TER:t_archivo_terreno;pos:word);
VAR
  REG_PROP:t_dato_propietario;
  REG_TER:t_dato_terreno;
  num_con_aux:word;
  I:word;
begin
  seek(ARCH_PROP,pos);
  read(ARCH_PROP,REG_PROP);
  num_con_aux:=REG_PROP.num_con;
  obtener_reg_arch_ter(ARCH_TER,0,REG_TER);
  I:=0;
  While (num_con_aux<>REG_TER.num_con) and (I<filesize(ARCH_TER)) do
  begin
    I:=I+1;
    obtener_reg_arch_ter(ARCH_TER,I,REG_TER);
  end;
  seleccionar_terreno(ARCH_TER,I,num_con_aux);
  If sin_terreno(ARCH_TER,num_con_aux) then
         baja_logica(ARCH_PROP,I);
end;

Procedure BAJA_TERRENO(VAR ARCH_PROP:t_archivo_propietario;VAR ARCH_TER:t_archivo_terreno;VAR RAIZ_DNI:t_puntero_DNI);
VAR
  DNI:integer;
  XDNI:t_puntero_DNI;
  REG_PROP:t_dato_propietario;
begin
  If filesize(ARCH_TER)>0 then
  begin
    clrscr;
    leer_DNI(DNI);
    clrscr;
    XDNI:=preorden_DNI(RAIZ_DNI,DNI);
    If XDNI=NIL then
    begin
      clrscr;
      BOX;
      gotoxy(30,10);
      writeln('PROPIETARIO NO EXISTENTE');
      readkey;
    end
    else
    begin
      obtener_reg_arch_prop(ARCH_PROP,XDNI^.info.pos,REG_PROP);
      If REG_PROP.estado=true then
      begin
       borrar_terreno(ARCH_PROP,ARCH_TER,XDNI^.info.pos);
      end
      else
      begin
        clrscr;
        BOX;
        gotoxy(30,10);
        writeln('PROPIETARIO NO ACTIVO');
        readkey;
        clrscr;
      end;
    end;
  end
  else
  begin
    clrscr;
    BOX;
    gotoxy(30,10);
    writeln('NO EXISTEN TERRENOS');
    readkey;
    clrscr;
  end;
end;

Procedure primer_terreno(VAR ARCH_TER:t_archivo_terreno;num_con:word;VAR I:word);
VAR
 REG_TER:t_dato_terreno;
begin
  If filesize(ARCH_TER)>0 then
  begin
    REG_TER.num_con:=0;
    I:=0;
    while (REG_TER.num_con<>num_con) and (I<filesize(ARCH_TER)) do
    begin
      obtener_reg_arch_ter(ARCH_TER,I,REG_TER);
      I:=I+1;
     { If J<=filesize(ARCH_TER)-1 then
      begin
        seek(ARCH_TER,J);
        read(ARCH_TER,REG_TER);
      end
      else
       num_con:=0; }
    end;
  end;
end;

Procedure leer_modificacion_ter(VAR REG:t_dato_terreno);
VAR
 resp,resp2:string;
begin
  resp:='';
  resp2:='';
  repeat
    repeat
     clrscr;
     BOX;
     gotoxy(30,10);
     writeln('INGRESE DATO A MODIFICAR');
     gotoxy(30,11);
     writeln('1:  NUMERO DE CONTRIBUYENTE');
     gotoxy(30,12);
     writeln('2:  NUMERO DE MENSURA');
     gotoxy(30,13);
     writeln('3:  AVALUO');
     gotoxy(30,14);
     writeln('4:  FECHA DE INSCRIPCION');
     gotoxy(30,15);
     writeln('5:  DOMICILIO PARCELARIO');
     gotoxy(30,16);
     writeln('6:  SUPERFICIE DE TERRENO');
     gotoxy(30,17);
     writeln('7:  ZONA');
     gotoxy(30,18);
     writeln('8:  TIPO DE EDIFICACION');
     gotoxy(30,19);
     writeln('0:  SALIR');
     gotoxy(30,20);
     readln(resp);
     resp:=copy(resp,1,1);
     clrscr;
     BOX;
     gotoxy(30,10);
     Case resp of
       '1':writeln('NUMERO DE CONTRIBUYENTE NUEVO: ');
       '2':writeln('NUMERO DE MENSURA NUEVO: ');
       '3':writeln('AVALUO NUEVO: ');
       '4':writeln('FECHA DE INSCRIPCION NUEVA(DD/MM/AAAA): ');
       '5':writeln('DOMICILIO PARCELARIO NUEVO: ');
       '6':writeln('SUPERFICIE DE TERRENO NUEVA: ');
       '7':writeln('ZONA NUEVA: ');
       '8':writeln('TIPO DE EDIFICACION NUEVA: ');
       end;
     gotoxy(70,10);
     Case resp of
       '1':read(REG.num_con);
       '2':read(REG.num_mensura);
       '3':read(REG.avaluo);
       '4':read(REG.fecha_ins);
       '5':read(REG.dom_par);
       '6':read(REG.superficie_terreno);
       '7':read(REG.zona);
       '8':read(REG.tipo_edif);
       end;
       clrscr;
    until resp='0';
    clrscr;
    BOX;
    gotoxy(30,10);
    writeln('SI NO DESEA REALIZAR MAS MODIFICACIONES INGRESE 0');
    gotoxy(30,11);
    readln(resp2);
  until resp2='0';
end;

Procedure modifica_ter(VAR ARCH_TER:t_archivo_terreno;num_con:word);
VAR
 I:word;
 resp:string;
 REG_TER:t_dato_terreno;
begin
  If sin_terreno(ARCH_TER,num_con) then
  begin
    clrscr;
    BOX;
    gotoxy(30,10);
    writeln('EL PROPIETARIO NO POSEE TERRENOS');
    readkey;
  end
  else
  begin
    I:=0;
    primer_terreno(ARCH_TER,num_con,I);
    resp:='a';
    repeat
     obtener_reg_arch_ter(ARCH_TER,I,REG_TER);
     I:=I+1;
     clrscr;
     BOX;
     gotoxy(30,10);
     writeln('¿EL TERRENO A MODIFICAR POSEE NUMERO DE MENSURA IGUAL A: ',REG_TER.num_mensura,'?');
     gotoxy(30,11);
     writeln('INGRESE 1 PARA CONFIRMAR');
     gotoxy(30,12);
     readln(resp);
     clrscr;
    until (resp='1') or (num_con<>REG_TER.num_con);
    If resp<>'1' then
    begin
      clrscr;
      BOX;
      gotoxy(30,10);
      writeln('EL PROPIETARIO NO POSEE EL TERRENO QUE BUSCA.');
      clrscr;
    end
    else
    begin
      leer_modificacion_ter(REG_TER);
      seek(ARCH_TER,I-1);
      write(ARCH_TER,REG_TER);
    end;
  end;
end;

Procedure MODIFICACION_TERRENO(VAR ARCH_TER:t_archivo_terreno;VAR ARCH_PROP:t_archivo_propietario;VAR RAIZ_DNI:t_puntero_DNI);
VAR
  DNI:integer;
  XDNI:t_puntero_DNI;
  REG_PROP:t_dato_propietario;
begin
  If filesize(ARCH_TER)>0 then
  begin
    clrscr;
    BOX;
    gotoxy(30,10);
    writeln('DNI:');
    gotoxy(35,10);
    readln(DNI);
    clrscr;
    XDNI:=preorden_DNI(RAIZ_DNI,DNI);
    If XDNI=NIL then
    begin
      clrscr;
      BOX;
      gotoxy(30,10);
      writeln('CONTRIBUYENTE NO ENCONTRADO');
      readkey;
    end
    else
    begin
      obtener_reg_arch_prop(ARCH_PROP,XDNI^.info.pos,REG_PROP);
      modifica_ter(ARCH_TER,REG_PROP.num_con);
    end;
  end
  else
  begin
    clrscr;
    BOX;
    gotoxy(30,10);
    writeln('NO EXISTEN TERRENOS');
    readkey;
    clrscr;
  end;
end;

Procedure mostrar_terreno(REG_TER:t_dato_terreno);
begin
  BOX;
  gotoxy(30,10);
  writeln('DATOS DEL TERRENO');
  gotoxy(30,11);
  writeln('NUMERO DE CONTRIBUYENTE: ',REG_TER.num_con);
  gotoxy(30,12);
  writeln('NUMERO DE MENSURA: ',REG_TER.num_mensura);
  gotoxy(30,13);
  writeln('AVALUO: ',REG_TER.avaluo:6:2);
  gotoxy(30,14);
  writeln('FECHA DE INSCRIPCION: ',REG_TER.fecha_ins);
  gotoxy(30,15);
  writeln('DOMICILIO PARCELARIO: ',REG_TER.dom_par);
  gotoxy(30,16);
  writeln('SUPERFICIE DEL TERRENO: ',REG_TER.superficie_terreno:6:2,' M^2');
  gotoxy(30,17);
  writeln('ZONA: ',REG_TER.zona);
  gotoxy(30,18);
  writeln('TIPO DE EDIFICACION: ',REG_TER.tipo_edif);
  readkey;
end;

Procedure CONSULTA_TERRENO (VAR ARCH_TER:t_archivo_terreno;VAR ARCH_PROP:t_archivo_propietario;RAIZ_DNI:t_puntero_DNI;VAR DNI:integer;VAR ENC:boolean);
VAR
  XDNI:t_puntero_DNI;
  resp:string;
  I:word;
  REG_TER:t_dato_terreno;
  REG_PROP:t_dato_propietario;
begin
  If filesize(ARCH_TER)>0 then
  begin
    clrscr;
    BOX;
    gotoxy(30,10);
    writeln('DNI DE CONTRIBUYENTE:');
    gotoxy(53,10);
    readln(DNI);
    XDNI:=preorden_DNI(RAIZ_DNI,DNI);
    If XDNI=NIL then
    begin
      clrscr;
      BOX;
      gotoxy(30,10);
      ENC:=false;
      writeln('CONTRIBUYENTE NO ENCONTRADO');
      readkey;
    end
    else
    begin
      obtener_reg_arch_prop(ARCH_PROP,XDNI^.info.pos,REG_PROP);
      If REG_PROP.estado=true then
      begin
        primer_terreno(ARCH_TER,REG_PROP.num_con,I);
        resp:='a';
        repeat
         obtener_reg_arch_ter(ARCH_TER,I-1,REG_TER);
         I:=I+1;
         clrscr;
         BOX;
         gotoxy(30,10);
         writeln('¿EL TERRENO POSEE NUMERO DE MENSURA IGUAL A: ',REG_TER.num_mensura,'?');
         gotoxy(30,11);
         writeln('INGRESE 1 PARA CONFIRMAR U INGRESE OTRO NUMERO PARA SIGUIENTE');
         gotoxy(30,12);
         readln(resp);
         clrscr;
        until (resp='1') or (REG_PROP.num_con<>REG_TER.num_con) or (I>=filesize(ARCH_TER));
        If (resp<>'1') then
        begin
          clrscr;
          BOX;
          gotoxy(30,10);
          ENC:=false;
          writeln('EL PROPIETARIO NO POSEE EL TERRENO QUE BUSCA.');
          readkey;
          clrscr;
        end
        else
        begin
          clrscr;
          ENC:=true;
          mostrar_terreno(REG_TER);
        end;
      end;
    end;
  end
  else
  begin
    clrscr;
    ENC:=false;
    BOX;
    gotoxy(30,10);
    writeln('NO EXISTEN TERRENOS');
    readkey;
  end;
end;

Procedure MENU_ABMC_TERRENOS(VAR ARCH_TER:t_archivo_terreno;VAR ARCH_PROP:t_archivo_propietario;VAR RAIZ_DNI:t_puntero_DNI);
VAR
  resp:string;
  DNI:integer;
  ENC:boolean;
begin
  repeat
    clrscr;
    BOX;
    gotoxy(20,10);
    writeln('1: ALTA DE TERRENO');
    gotoxy(20,11);
    writeln('2: BAJA DE TERRENO');
    gotoxy(20,12);
    writeln('3: MODIFICACION DE TERRENO');
    gotoxy(20,13);
    writeln('4: CONSULTA DE TERRENO');
    gotoxy(20,14);
    writeln('0: SALIR');
    gotoxy(20,15);
    readln(resp);
    resp:=copy(resp,1,1);
     case resp of
     '1': ALTA_TERRENO(ARCH_TER);
     '2': BAJA_TERRENO(ARCH_PROP,ARCH_TER,RAIZ_DNI);
     '3': MODIFICACION_TERRENO(ARCH_TER,ARCH_PROP,RAIZ_DNI);
     '4': CONSULTA_TERRENO(ARCH_TER,ARCH_PROP,RAIZ_DNI,DNI,ENC);
     end;
     clrscr;
  until resp='0';
end;

Procedure estados(VAR ARCH_PROP:t_archivo_propietario;VAR ARCH_TER:t_archivo_terreno);
VAR
  I:word;
  REG_PROP:t_dato_propietario;
begin
  If (filesize(ARCH_PROP)>0) and (filesize(ARCH_TER)>0) then
    For I:=0 to filesize(ARCH_PROP)-1 do
    begin
      obtener_reg_arch_prop(ARCH_PROP,I,REG_PROP);
        If (REG_PROP.estado=false) and not sin_terreno(ARCH_TER,REG_PROP.num_con) then
        begin
          REG_PROP.estado:=true;
          seek(ARCH_PROP,I);
          write(ARCH_PROP,REG_PROP);
        end;
        If (REG_PROP.estado=true) and sin_terreno(ARCH_TER,REG_PROP.num_con) then
        begin
          REG_PROP.estado:=false;
          seek(ARCH_PROP,I);
          write(ARCH_PROP,REG_PROP);
        end;
    end;
end;

end.

