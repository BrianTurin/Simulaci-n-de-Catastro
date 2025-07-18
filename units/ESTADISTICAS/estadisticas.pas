unit ESTADISTICAS;
interface

uses
  MARCO,crt,ARCHIVO_TER,ARCHIVO_PROPIETARIOS;

Procedure leer_fechas(VAR fecha_inicio:string; VAR fecha_fin:string);
Procedure contador_ins_entre_fechas(fecha_inicio:string;fecha_fin:string;VAR ARCH_TER:t_archivo_terreno;VAR I:word);
Procedure inscripciones_entre_dos_fechas(VAR ARCH_TER:t_archivo_terreno);
Procedure cantidad_mas_de_una(VAR ARCH_TER:t_archivo_terreno;VAR J:word);
Procedure cantidad_prop(VAR ARCH_PROP:t_archivo_propietario;VAR cant_prop:word);
Procedure porcentaje_mas_de_una_propiedad(VAR ARCH_PROP:t_archivo_propietario; VAR ARCH_TER:t_archivo_terreno);
Procedure contar_cantidades(VAR ARCH_TER:t_archivo_terreno;VAR cat1:word;VAR cat2:word;VAR cat3:word;VAR cat4:word;VAR cat5:word);
Procedure porcentajes_tipos(cantidad,cat1,cat2,cat3,cat4,cat5:word;VAR por1:real;VAR por2:real;VAR por3:real;VAR por4:real;VAR por5:real);
Procedure escribir_porcentajes(por1:real; por2:real; por3:real; por4:real; por5:real);
Procedure porcentaje_tipo_edificacion(VAR ARCH_TER:t_archivo_terreno);
Procedure cantidad_baja(VAR ARCH_PROP:t_archivo_propietario; VAR I:word);
Procedure porcentaje_dados_de_baja (VAR ARCH_PROP:t_archivo_propietario);
Procedure MENU_ESTADISTICAS (VAR ARCH_PROP:t_archivo_propietario; VAR ARCH_TER:t_archivo_terreno);

implementation

Procedure leer_fechas(VAR fecha_inicio:string; VAR fecha_fin:string);
VAR
  X1,X2:t_dato_terreno;
begin
  repeat
  clrscr;
  BOX;
  gotoxy(30,10);
  writeln('INGRESE FECHA DE INICIO(DD/MM/AAAA)');
  gotoxy(30,11);
  readln(X1.fecha_ins);
  gotoxy(30,12);
  writeln('INGRESE FECHA DE FIN(DD/MM/AAAA)');
  gotoxy(30,13);
  readln(X2.fecha_ins);
  fecha_inicio:=convertir_fecha(X1);
  fecha_fin:=convertir_fecha(X2);
  clrscr;
  If fecha_inicio>=fecha_fin then
  begin
    clrscr;
    BOX;
    gotoxy(30,10);
    writeln('LA FECHA DE INICIO NO PUEDE SER IGUAL O MAYOR QUE LA DE FIN');
    readkey;
    clrscr;
  end;
  until fecha_inicio<fecha_fin;
end;

Procedure contador_ins_entre_fechas(fecha_inicio:string;fecha_fin:string;VAR ARCH_TER:t_archivo_terreno;VAR I:word);
VAR
  REG:t_dato_terreno;
  J:word;
  fecha_aux:string;
begin
  I:=0;
  For J:=0 to filesize(ARCH_TER)-1 do
  begin
    obtener_reg_arch_ter(ARCH_TER,J,REG);
    fecha_aux:=convertir_fecha(REG);
    If (fecha_aux>=fecha_inicio) and (fecha_aux<=fecha_fin) then
    begin
      I:=I+1;
    end;
  end;
end;

Procedure inscripciones_entre_dos_fechas(VAR ARCH_TER:t_archivo_terreno);
VAR
  fecha_inicio,fecha_fin:string;
  I:word;
begin
  If filesize(ARCH_TER)>0 then
  begin
    leer_fechas(fecha_inicio,fecha_fin);
    contador_ins_entre_fechas(fecha_inicio,fecha_fin,ARCH_TER,I);
    clrscr;
    BOX;
    gotoxy(30,10);
    writeln('LA CANTIDAD DE INSCRIPCIONES ENTRE LAS FECHAS INGRESADAS ES: ',I);
    readkey;
    clrscr;
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

Procedure cantidad_mas_de_una(VAR ARCH_TER:t_archivo_terreno;VAR J:word);
VAR
  REG:t_dato_terreno;
  aux:word;
  L:word;
begin
  J:=0;
  aux:=0;
  If filesize(ARCH_TER)>1 then
    For L:=0 to filesize(ARCH_TER)-2 do
    begin
      obtener_reg_arch_ter(ARCH_TER,L,REG);
      If REG.num_con<>aux then
      begin
        aux:=REG.num_con;
        obtener_reg_arch_ter(ARCH_TER,L+1,REG);
        If aux=REG.num_con then
         J:=J+1;
      end;
    end;
  end;

Procedure cantidad_prop(VAR ARCH_PROP:t_archivo_propietario;VAR cant_prop:word);
VAR
  I:word;
  REG_PROP:t_dato_propietario;
begin
  cant_prop:=0;
  If filesize(ARCH_PROP)>0 then
    For I:=0 to filesize(ARCH_PROP)-1 do
    begin
     obtener_reg_arch_prop(ARCH_PROP,I,REG_PROP);
      If REG_PROP.estado=true then
       cant_prop:=cant_prop+1;
    end;
end;

Procedure porcentaje_mas_de_una_propiedad(VAR ARCH_PROP:t_archivo_propietario; VAR ARCH_TER:t_archivo_terreno);
VAR
  J,cant_prop:word;
  porcentaje:real;
begin
  If filesize(ARCH_TER)>0 then
  begin
   cantidad_mas_de_una(ARCH_TER,J);
   cantidad_prop(ARCH_PROP,cant_prop);
   If cant_prop>0 then
   begin
    porcentaje:=(J*100)/cant_prop;
   end;
   clrscr;
   BOX;
   gotoxy(30,10);
   writeln('EL PORCENTAJE DE PROPIETARIOS CON MAS DE UNA PROPIEDAD ES: %',porcentaje:6:2);
   readkey;
   clrscr;
  end
  else
  begin
    clrscr;
    BOX;
    gotoxy(30,10);
    writeln('NO EXISTEN DATOS SUFICIENTES PARA PROPORCIONAR ESTADISTICA');
    readkey;
  end;
end;

Procedure contar_cantidades(VAR ARCH_TER:t_archivo_terreno;VAR cat1:word;VAR cat2:word;VAR cat3:word;VAR cat4:word;VAR cat5:word);
VAR
  I:word;
  REG:t_dato_terreno;
  categoria:byte;
begin
  cat1:=0;
  cat2:=0;
  cat3:=0;
  cat4:=0;
  cat5:=0;
  For I:=0 to filesize(ARCH_TER)-1 do
  begin
    obtener_reg_arch_ter(ARCH_TER,I,REG);
    categoria:=REG.tipo_edif;
    Case categoria of
    1:cat1:=cat1+1;
    2:cat2:=cat2+1;
    3:cat3:=cat3+1;
    4:cat4:=cat4+1;
    5:cat5:=cat5+1;
    end;
  end;
end;

Procedure porcentajes_tipos(cantidad,cat1,cat2,cat3,cat4,cat5:word;VAR por1:real;VAR por2:real;VAR por3:real;VAR por4:real;VAR por5:real);
begin
  por1:=(cat1*100)/cantidad;
  por2:=(cat2*100)/cantidad;
  por3:=(cat3*100)/cantidad;
  por4:=(cat4*100)/cantidad;
  por5:=(cat5*100)/cantidad;
end;

Procedure escribir_porcentajes(por1:real; por2:real; por3:real; por4:real; por5:real);
begin
  clrscr;
  BOX;
  gotoxy(30,10);
  writeln('EL PORCENTAJE POR TIPO DE EDIFICACION ES:');
  gotoxy(30,11);
  writeln('TIPO 1: %',por1:6:2);
  gotoxy(30,12);
  writeln('TIPO 2: %',por2:6:2);
  gotoxy(30,13);
  writeln('TIPO 3: %',por3:6:2);
  gotoxy(30,14);
  writeln('TIPO 4: %',por4:6:2);
  gotoxy(30,15);
  writeln('TIPO 5: %',por5:6:2);
  readkey;
end;

Procedure porcentaje_tipo_edificacion(VAR ARCH_TER:t_archivo_terreno);
VAR
  cat1,cat2,cat3,cat4,cat5,cantidad:word;
  por1,por2,por3,por4,por5:real;
begin
  If filesize(ARCH_TER)>0 then
  begin
    cantidad:=filesize(ARCH_TER);
    contar_cantidades(ARCH_TER,cat1,cat2,cat3,cat4,cat5);
    porcentajes_tipos(cantidad,cat1,cat2,cat3,cat4,cat5,por1,por2,por3,por4,por5);
    escribir_porcentajes(por1,por2,por3,por4,por5);
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

Procedure cantidad_baja(VAR ARCH_PROP:t_archivo_propietario; VAR I:word);
VAR
  J:word;
  REG:t_dato_propietario;
begin
  I:=0;
  For J:=0 to filesize(ARCH_PROP)-1 do
  begin
    obtener_reg_arch_prop(ARCH_PROP,J,REG);
    If REG.estado=false then
     I:=I+1;
  end;
end;

Procedure porcentaje_dados_de_baja (VAR ARCH_PROP:t_archivo_propietario);
VAR
  I,cantidad:word;
  porcentaje:real;
begin
  If filesize(ARCH_PROP)>0 then
  begin
    cantidad_baja(ARCH_PROP,I);
    cantidad:=filesize(ARCH_PROP);
    porcentaje:=(I*100)/cantidad;
    clrscr;
    BOX;
    gotoxy(30,10);
    writeln('EL PORCENTAJE DE PROPIETARIOS DADOS DE BAJA ES: %',porcentaje:6:2);
    readkey;
    clrscr;
  end
  else
  begin
    clrscr;
    BOX;
    gotoxy(30,10);
    writeln('NO EXISTEN PROPIETARIOS');
    readkey;
  end;
end;

Procedure MENU_ESTADISTICAS (VAR ARCH_PROP:t_archivo_propietario; VAR ARCH_TER:t_archivo_terreno);
VAR
  resp:string;
begin
  repeat
    clrscr;
    BOX;
    gotoxy(30,10);
    writeln('1: CANTIDAD DE INSCRIPCIONES ENTRE DOS FECHAS');
    gotoxy(30,11);
    writeln('2: PORCENTAJE DE PROPIETARIOS CON MAS DE UNA PROPIEDAD');
    gotoxy(30,12);
    writeln('3: PORCENTAJE DE PROPIETARIOS POR TIPO DE EDIFICACION');
    gotoxy(30,13);
    writeln('4: CANTIDAD DE PROPIETARIOS DADOS DE BAJA');
    gotoxy(30,14);
    writeln('0: SALIR');
    gotoxy(30,15);
    readln(resp);
    clrscr;
    case resp of
    '1':inscripciones_entre_dos_fechas(ARCH_TER);
    '2':porcentaje_mas_de_una_propiedad(ARCH_PROP,ARCH_TER);
    '3':porcentaje_tipo_edificacion(ARCH_TER);
    '4':porcentaje_dados_de_baja(ARCH_PROP);
    end;
  until resp='0';
end;

end.

