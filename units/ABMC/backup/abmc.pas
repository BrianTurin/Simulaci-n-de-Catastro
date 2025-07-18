unit ABMC_PROPIETARIOS;
interface

uses
  ARBOLES,ARCHIVO_PROPIETARIOS,ARCHIVO_TER,sysutils,crt;

Type
  uno_al_nueve=set of 1..9;

Procedure generar_datos_arboles(I:word;VAR XArbol_apynom:t_dato_arbol_apynom;VAR XArbol_DNI:t_dato_arbol_DNI;X:t_dato_propietario);
//Procedure generar_dato_arbol_DNI(I:word;VAR XDNI:t_dato_arbol_DNI;X:t_dato_propietario);
Procedure generar_arboles (VAR RAIZ_apynom:t_puntero_apynom;VAR RAIZ_DNI:t_puntero_DNI;VAR ARCH_PROP:t_archivo_propietario);
//ABMC PROPIETARIOS
Procedure leer_DNI(VAR DNI:integer);
Procedure leer_t_dato_prop(VAR X:t_dato_propietario);
Procedure ALTA_CONTRIBUYENTE(VAR ARCH_PROP:t_archivo_propietario);
Procedure BAJA_CONTRIBUYENTE(VAR ARCH_PROP:t_archivo_propietario;VAR RAIZ_DNI:t_puntero_DNI);
Procedure CONSULTA_CONTRIBUYENTE(VAR ARCH_PROP:t_archivo_propietario;VAR RAIZ_DNI:t_puntero_DNI;VAR RAIZ_apynom:t_puntero_apynom);
Procedure modifica_prop(VAR ARCH_PROP:t_archivo_propietario;pos:word);
Procedure MODIFICACION_CONTRIBUYENTE(VAR ARCH_PROP:t_archivo_propietario;VAR RAIZ_DNI:t_puntero_DNI);
Procedure MENU_ABMC_PROPIETARIOS(VAR ARCH_PROP:t_archivo_propietario;VAR RAIZ_DNI:t_puntero_DNI;VAR RAIZ_apynom:t_puntero_apynom);
//ABMC TERRENOS

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
  crear_abrir_prop(ARCH_PROP);
  For I:=0 to filesize(ARCH_PROP)-1 do
  begin
     obtener_reg_arch_prop(ARCH_PROP,I,X);
     generar_datos_arboles(I,XArbol_apynom,XArbol_DNI,X);
     agregar_apynom(RAIZ_apynom,XArbol_apynom);
     agregar_DNI(RAIZ_DNI,XArbol_DNI);
  end;
  cerrar_prop(ARCH_PROP);
end;

Procedure leer_DNI(VAR DNI:integer);
begin
  writeln('DNI: ');
  readln(DNI);
end;

Procedure leer_t_dato_prop(VAR X:t_dato_propietario);
begin
  writeln('Numero de Contribuyente: ');
  readln(X.num_con);
  writeln('Apellido/s');
  readln(X.apellido);
  writeln('Nombre/s');
  readln(X.nombre);
  writeln('Direccion');
  readln(X.direccion);
  writeln('Ciudad');
  readln(X.ciudad);
  writeln('DNI');
  readln(X.DNI);
  writeln('Fecha de nacimiento');
  readln(X.fecha_nac);
  writeln('Telefono');
  readln(X.tel);
  writeln('Mail');
  readln(X.mail);
  X.estado:=false;
end;

Procedure ALTA_CONTRIBUYENTE(VAR ARCH_PROP:t_archivo_propietario);
VAR
  X:t_dato_propietario;
begin
  leer_t_dato_prop(X);
  ingresar_dato_arch_prop(ARCH_PROP,X);
end;

Procedure BAJA_CONTRIBUYENTE(VAR ARCH_PROP:t_archivo_propietario;VAR RAIZ_DNI:t_puntero_DNI);
VAR
  DNI:integer;
  XDNI:t_puntero_DNI;
  pos:word;
begin
  writeln('Ingrese DNI');
  readln(DNI);
  XDNI:=preorden_DNI(RAIZ_DNI,DNI);
  If XDNI=NIL then
  begin
  writeln('Contribuyente no encontrado');
  end
  else
  begin
    baja_logica_prop(ARCH_PROP,XDNI^.info.pos);
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
  repeat
  clrscr;
  writeln('Ingrese forma de busqueda. Por DNI o por NOMBRE');
  readln(resp);
  clrscr;
  uppercase(resp);
  until (resp='DNI') or (resp='NOMBRE');
  If resp='DNI' then
  begin
    leer_DNI(DNI);
    XDNI:=preorden_DNI(RAIZ_DNI,DNI);
    If XDNI=NIL then
    begin
      writeln('Contribuyente no encontrado');
    end
    else
    begin
      mostrar_contribuyente(ARCH_PROP,XDNI^.info.pos);
    end;
  end
  else
  begin
    writeln('Apellido/s');
    readln(apellido);
    writeln('Nombre/s');
    readln(nombre);
    nombre_tot:=apellido+nombre;
    X_apynom:=preorden_apynom(RAIZ_apynom,nombre_tot);
    If X_apynom=NIL then
    begin
      writeln('Contribuyente no encontrado');
    end
    else
    begin
      mostrar_contribuyente(ARCH_PROP,X_apynom^.info.pos);
    end;
  end;
end;

Procedure modifica_prop(VAR ARCH_PROP:t_archivo_propietario;pos:word);
VAR
  resp:string;
  num_aux:byte;
  REG:t_dato_propietario;
begin
  crear_abrir_prop(ARCH_PROP);
  seek(ARCH_PROP,pos);
  read(ARCH_PROP,REG);
  repeat
   writeln('INGRESE DATO A MODIFICAR');
   writeln('1:  Numero de Contribuyente');
   writeln('2:  Apellido/s');
   writeln('3:  Nombre/s');
   writeln('4:  Direccion');
   writeln('5:  Ciudad');
   writeln('6:  DNI');
   writeln('7:  Fecha de Nacimiento');
   writeln('8:  Telefono');
   writeln('9:  Mail');
   writeln('0:  Salir');
   readln(resp);
   resp:=copy(resp,1,1);
     Case resp of
     '1':readln(REG.num_con);
     '2':readln(REG.apellido);
     '3':readln(REG.nombre);
     '4':readln(REG.direccion);
     '5':readln(REG.ciudad);
     '6':readln(REG.DNI);
     '7':readln(REG.fecha_nac);
     '8':readln(REG.tel);
     '9':readln(REG.mail);
     end;
  until resp='0';
  cerrar_prop(ARCH_PROP);
end;

Procedure MODIFICACION_CONTRIBUYENTE(VAR ARCH_PROP:t_archivo_propietario;VAR RAIZ_DNI:t_puntero_DNI);
VAR
  DNI:integer;
  XDNI:t_puntero_DNI;
begin
  leer_DNI(DNI);
  XDNI:=preorden_DNI(RAIZ_DNI,DNI);
  If XDNI=NIL then
  begin
    writeln('Contribuyente no encontrado');
  end
  else
  begin
    modifica_prop(ARCH_PROP,XDNI^.info.pos);
  end;
end;

Procedure MENU_ABMC_PROPIETARIOS(VAR ARCH_PROP:t_archivo_propietario;VAR RAIZ_DNI:t_puntero_DNI;VAR RAIZ_apynom:t_puntero_apynom);
VAR
  resp:string;
begin
  repeat
   clrscr;
    writeln('1: ALTA DE PROPIETARIO');
    writeln('2: BAJA DE PROPIETARIO');
    writeln('3: MODIFICACION DE PROPIETARIO');
    writeln('4: CONSULTA DE PROPIETARIO');
    writeln('0: SALIR');
    readln(resp);
    resp:=copy(resp,1,1);
     case resp of
     '1': ALTA_CONTRIBUYENTE(ARCH_PROP);
     '2': BAJA_CONTRIBUYENTE(ARCH_PROP,RAIZ_DNI);
     '3': MODIFICACION_CONTRIBUYENTE(ARCH_PROP,RAIZ_DNI);
     '4': CONSULTA_CONTRIBUYENTE(ARCH_PROP,RAIZ_DNI,RAIZ_apynom);
     end;
     clrscr;
  until resp='0';
end;

end.

