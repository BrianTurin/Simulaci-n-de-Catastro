unit ABMC_PROPIETARIOS;
interface

uses
  MARCO,ARBOLES,ARCHIVO_PROPIETARIOS,ARCHIVO_TER,sysutils,crt;

Type
  uno_al_nueve=set of 1..9;

Procedure generar_datos_arboles(I:word;VAR XArbol_apynom:t_dato_arbol_apynom;VAR XArbol_DNI:t_dato_arbol_DNI;X:t_dato_propietario);
//Procedure generar_dato_arbol_DNI(I:word;VAR XDNI:t_dato_arbol_DNI;X:t_dato_propietario);
Procedure generar_arboles (VAR RAIZ_apynom:t_puntero_apynom;VAR RAIZ_DNI:t_puntero_DNI;VAR ARCH_PROP:t_archivo_propietario);
//ABMC PROPIETARIOS
Procedure leer_DNI(VAR DNI:integer);
Procedure leer_t_dato_prop(VAR X:t_dato_propietario);
Function bajado_logicamente(VAR ARCH_PROP:t_archivo_propietario;X:t_dato_propietario):integer;
Procedure ALTA_CONTRIBUYENTE(VAR ARCH_PROP:t_archivo_propietario);
Procedure BAJA_CONTRIBUYENTE(VAR ARCH_PROP:t_archivo_propietario;VAR ARCH_TER:t_archivo_terreno;VAR RAIZ_DNI:t_puntero_DNI);
Procedure CONSULTA_CONTRIBUYENTE(VAR ARCH_PROP:t_archivo_propietario;VAR RAIZ_DNI:t_puntero_DNI;VAR RAIZ_apynom:t_puntero_apynom);
Procedure mostrar_contribuyente(VAR ARCH_PROP:t_archivo_propietario;pos:word);
Procedure modifica_prop(VAR ARCH_PROP:t_archivo_propietario;pos:word);
Procedure MODIFICACION_CONTRIBUYENTE(VAR ARCH_PROP:t_archivo_propietario;VAR RAIZ_DNI:t_puntero_DNI);
Procedure MENU_ABMC_PROPIETARIOS(VAR ARCH_PROP:t_archivo_propietario;VAR ARCH_TER:t_archivo_terreno;VAR RAIZ_DNI:t_puntero_DNI;VAR RAIZ_apynom:t_puntero_apynom);

implementation
Procedure generar_datos_arboles(I:word;VAR XArbol_apynom:t_dato_arbol_apynom;VAR XArbol_DNI:t_dato_arbol_DNI;X:t_dato_propietario);
begin
    XArbol_apynom.clave:=X.apellido+X.nombre;
    XArbol_apynom.pos:=I;
    XArbol_DNI.clave:=X.DNI;
    XArbol_DNI.pos:=I;
end;
{
Procedure generar_dato_arbol_DNI(I:word;VAR XDNI:t_dato_arbol_DNI;X:t_dato_propietario);
begin
  XDNI.DNI:=X.DNI;
  XDNI.pos:=I;
end;
}
Procedure generar_arboles (VAR RAIZ_apynom:t_puntero_apynom;VAR RAIZ_DNI:t_puntero_DNI;VAR ARCH_PROP:t_archivo_propietario);
VAR
  I:word;
  X:t_dato_propietario;
  XArbol_apynom:t_dato_arbol_apynom;
  XArbol_DNI:t_dato_arbol_DNI;
begin
  If filesize(ARCH_PROP)>0 then
  begin
    For I:=0 to filesize(ARCH_PROP)-1 do
    begin
       obtener_reg_arch_prop(ARCH_PROP,I,X);
       generar_datos_arboles(I,XArbol_apynom,XArbol_DNI,X);
       agregar_apynom(RAIZ_apynom,XArbol_apynom);
       agregar_DNI(RAIZ_DNI,XArbol_DNI);
    end;
  end;
end;

Procedure leer_DNI(VAR DNI:integer);
begin
  clrscr;
  BOX;
  gotoxy(30,10);
  writeln('DNI: ');
  gotoxy(34,10);
  readln(DNI);
end;

Procedure leer_t_dato_prop(VAR X:t_dato_propietario);
begin
  clrscr;
  BOX;
  gotoxy(20,10);
  writeln('NUMERO DE CONTRIBUYENTE: ');
  gotoxy(55,10);
  readln(X.num_con);
  gotoxy(20,11);
  writeln('APELLIDO/S');
  gotoxy(55,11);
  readln(X.apellido);
  X.apellido:=UpCase(X.apellido);
  gotoxy(20,12);
  writeln('NOMBRE/S');
  gotoxy(55,12);
  readln(X.nombre);
  X.nombre:=UpCase(X.nombre);
  gotoxy(20,13);
  writeln('DIRECCION');
  gotoxy(55,13);
  readln(X.direccion);
  gotoxy(20,14);
  writeln('CIUDAD');
  gotoxy(55,14);
  readln(X.ciudad);
  gotoxy(20,15);
  writeln('DNI');
  gotoxy(55,15);
  readln(X.DNI);
  gotoxy(20,16);
  writeln('FECHA DE NACIMIENTO (DD/MM/AAAA)');
  gotoxy(55,16);
  readln(X.fecha_nac);
  gotoxy(20,17);
  writeln('TELEFONO');
  gotoxy(55,17);
  readln(X.tel);
  gotoxy(20,18);
  writeln('MAIL');
  gotoxy(55,18);
  readln(X.mail);
  gotoxy(20,19);
  X.estado:=false;
end;

Function bajado_logicamente(VAR ARCH_PROP:t_archivo_propietario;X:t_dato_propietario):integer;
VAR
  I:word;
  REG:t_dato_propietario;
begin
  I:=0;
  REG.DNI:=0;
  while (I<filesize(ARCH_PROP)) and (REG.DNI<>X.DNI) do
  begin
     obtener_reg_arch_prop(ARCH_PROP,I,REG);
     I:=I+1;
  end;
  If REG.DNI=X.DNI then
  begin
    bajado_logicamente:=I-1;
  end
  else
  begin
     bajado_logicamente:=-1;
  end;
end;

Procedure ALTA_CONTRIBUYENTE(VAR ARCH_PROP:t_archivo_propietario);
VAR
  X:t_dato_propietario;
begin
  leer_t_dato_prop(X);
  If bajado_logicamente(ARCH_PROP,X)=-1 then
  begin
  ingresar_dato_arch_prop(ARCH_PROP,X);
  end
  else
  begin
     seek(ARCH_PROP,bajado_logicamente(ARCH_PROP,X));
     write(ARCH_PROP,X);
  end;
  gotoxy(20,23);
  write('PROPIETADO INGRESADO SATISFACTORIAMENTE');
  readkey;
end;

Procedure BAJA_CONTRIBUYENTE(VAR ARCH_PROP:t_archivo_propietario;VAR ARCH_TER:t_archivo_terreno;VAR RAIZ_DNI:t_puntero_DNI);
VAR
  I:word;
  DNI:integer;
  XDNI:t_puntero_DNI;
  pos:word;
  REG_TER:t_dato_terreno;
  REG_PROP:t_dato_propietario;
begin
  If filesize(ARCH_PROP)>0 then
  begin
    clrscr;
    BOX;
    gotoxy(30,10);
    writeln('INGRESE DNI');
    gotoxy(30,11);
    readln(DNI);
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
      clrscr;
      baja_logica(ARCH_PROP,XDNI^.info.pos);
      obtener_reg_arch_prop(ARCH_PROP,XDNI^.info.pos,REG_PROP);
      For I:=0 to filesize(ARCH_TER)-1 do
      begin
       obtener_reg_arch_ter(ARCH_TER,I,REG_TER);
       If REG_TER.num_con=REG_PROP.num_con then
        bajar_terreno(ARCH_TER,I);
      end;
      BOX;
      gotoxy(30,10);
      writeln('BAJA REALIZADA SATISFACTORIAMENTE');
      readkey;
    end;
  end
  else
  begin
    clrscr;
    BOX;
    gotoxy(30,10);
    writeln('NO EXISTEN PROPIERTARIOS');
    readkey;
    clrscr;
  end;
end;

Procedure mostrar_contribuyente(VAR ARCH_PROP:t_archivo_propietario;pos:word);
VAR
  X:t_dato_propietario;
begin
  obtener_reg_arch_prop(ARCH_PROP,pos,X);
  If X.estado=true then
  begin
    clrscr;
    BOX;
    gotoxy(20,10);
    writeln('NUMERO DE CONTRIBUYENTE: ',X.num_con);
    gotoxy(20,11);
    writeln('APELLIDO/S: ',X.apellido);
    gotoxy(20,12);
    writeln('NOMBRE/S: ',X.nombre);
    gotoxy(20,13);
    writeln('DIRECCION: ',X.direccion);
    gotoxy(20,14);
    writeln('CIUDAD: ',X.ciudad);
    gotoxy(20,15);
    writeln('DNI: ',X.DNI);
    gotoxy(20,16);
    writeln('FECHA DE NACIMIENTO: ',X.fecha_nac);
    gotoxy(20,17);
    writeln('TELEFONO: ',X.tel);
    gotoxy(20,18);
    writeln('MAIL: ',X.mail);
    readkey;
  end
  else
  begin
    clrscr;
    BOX;
    gotoxy(30,10);
    writeln('EL PROPIETARIO HA SIDO DADO DE BAJA');
    readkey;
  end;
end;

Procedure CONSULTA_CONTRIBUYENTE(VAR ARCH_PROP:t_archivo_propietario;VAR RAIZ_DNI:t_puntero_DNI;VAR RAIZ_apynom:t_puntero_apynom);

VAR
  resp:string;
  DNI:integer;
  XDNI:t_puntero_DNI;
  X_apynom:t_puntero_apynom;
  apellido:string[40];
  nombre:string[40];
  nombre_tot:string;
begin
  If filesize(ARCH_PROP)>0 then
  begin
    repeat
    clrscr;
    BOX;
    gotoxy(30,10);
    writeln('INGRESE FORMA DE BUSQUEDA. POR DNI O POR NOMBRE');
    gotoxy(30,11);
    readln(resp);
    clrscr;
    resp:=upcase(resp);
    until (resp='DNI') or (resp='NOMBRE');
    If resp='DNI' then
    begin
      clrscr;
      BOX;
      leer_DNI(DNI);
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
        mostrar_contribuyente(ARCH_PROP,XDNI^.info.pos);
      end;
    end
    else
    begin
      clrscr;
      BOX;
      gotoxy(30,10);
      writeln('APELLIDO/S: ');
      gotoxy(41,10);
      readln(apellido);
      gotoxy(30,11);
      writeln('NOMBRE/S: ');
      gotoxy(41,11);
      readln(nombre);
      nombre_tot:=apellido+nombre;
      nombre_tot:=UpCase(nombre_tot);
      X_apynom:=preorden_apynom(RAIZ_apynom,nombre_tot);
      If X_apynom=NIL then
      begin
        clrscr;
        BOX;
        gotoxy(30,10);
        writeln('CONTRIBUYENTE NO ENCONTRADO');
        readkey;
      end
      else
      begin
        mostrar_contribuyente(ARCH_PROP,X_apynom^.info.pos);
      end;
    end;
  end
  else
  begin
    clrscr;
    BOX;
    gotoxy(30,10);
    writeln('NO EXISTEN PROPIETARIOS');
    readkey;
    clrscr;
  end;
end;

Procedure modifica_prop(VAR ARCH_PROP:t_archivo_propietario;pos:word);
VAR
  resp:string;
  num_aux:byte;
  REG:t_dato_propietario;
begin
  seek(ARCH_PROP,pos);
  read(ARCH_PROP,REG);
  repeat
   clrscr;
   BOX;
   gotoxy(30,10);
   writeln('INGRESE DATO A MODIFICAR');
   gotoxy(30,11);
   writeln('1:  NUMERO DE CONTRIBUYENTE');
   gotoxy(30,12);
   writeln('2:  APELLIDO/S');
   gotoxy(30,13);
   writeln('3:  NOMBRE/S');
   gotoxy(30,14);
   writeln('4:  DIRECCION');
   gotoxy(30,15);
   writeln('5:  CIUDAD');
   gotoxy(30,16);
   writeln('6:  DNI');
   gotoxy(30,17);
   writeln('7:  FECHA DE NACIMIENTO');
   gotoxy(30,18);
   writeln('8:  TELEFONO');
   gotoxy(30,19);
   writeln('9:  MAIL');
   gotoxy(30,20);
   writeln('0:  SALIR');
   gotoxy(30,21);
   readln(resp);
   clrscr;
   resp:=copy(resp,1,1);
   BOX;
   gotoxy(30,10);
    Case resp of
     '1':writeln('NUMERO DE CONTRIBUYENTE NUEVO: ');
     '2':writeln('APELLIDO/S NUEVO/S: ');
     '3':writeln('NOMBRE/S NUEVO/S: ');
     '4':writeln('DIRECCION NUEVA: ');
     '5':writeln('CIUDAD NUEVA: ');
     '6':writeln('DNI NUEVO: ');
     '7':writeln('FECHA DE NACIMIENTO NUEVA (DD/MM/AAAA): ');
     '8':writeln('TELEFONO NUEVO: ');
     '9':writeln('MAIL NUEVO: ');
     end;
    gotoxy(30,11);
    Case resp of
     '1':read(REG.num_con);
     '2':read(REG.apellido);
     '3':read(REG.nombre);
     '4':read(REG.direccion);
     '5':read(REG.ciudad);
     '6':read(REG.DNI);
     '7':read(REG.fecha_nac);
     '8':read(REG.tel);
     '9':read(REG.mail);
     end;
   clrscr;
  until resp='0';
end;

Procedure MODIFICACION_CONTRIBUYENTE(VAR ARCH_PROP:t_archivo_propietario;VAR RAIZ_DNI:t_puntero_DNI);
VAR
  DNI:integer;
  XDNI:t_puntero_DNI;
begin
  If filesize(ARCH_PROP)>0 then
  begin
    clrscr;
    leer_DNI(DNI);
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
      modifica_prop(ARCH_PROP,XDNI^.info.pos);
    end;
  end
  else
  begin
    clrscr;
    BOX;
    gotoxy(30,10);
    writeln('NO EXISTEN PROPIETARIOS');
    readkey;
    clrscr;
  end;
end;

Procedure MENU_ABMC_PROPIETARIOS(VAR ARCH_PROP:t_archivo_propietario;VAR ARCH_TER:t_archivo_terreno;VAR RAIZ_DNI:t_puntero_DNI;VAR RAIZ_apynom:t_puntero_apynom);
VAR
  resp:string;
begin
  repeat
    clrscr;
    BOX;
    gotoxy(20,10);
    writeln('1: ALTA DE PROPIETARIO');
    gotoxy(20,11);
    writeln('2: BAJA DE PROPIETARIO');
    gotoxy(20,12);
    writeln('3: MODIFICACION DE PROPIETARIO');
    gotoxy(20,13);
    writeln('4: CONSULTA DE PROPIETARIO');
    gotoxy(20,14);
    writeln('0: SALIR');
    gotoxy(20,15);
    readln(resp);
    resp:=copy(resp,1,1);
     case resp of
     '1': ALTA_CONTRIBUYENTE(ARCH_PROP);
     '2': BAJA_CONTRIBUYENTE(ARCH_PROP,ARCH_TER,RAIZ_DNI);
     '3': MODIFICACION_CONTRIBUYENTE(ARCH_PROP,RAIZ_DNI);
     '4': CONSULTA_CONTRIBUYENTE(ARCH_PROP,RAIZ_DNI,RAIZ_apynom);
     end;
     clrscr;
  until resp='0';
end;

end.
