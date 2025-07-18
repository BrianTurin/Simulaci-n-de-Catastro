unit MENU;
interface

uses
 crt,MARCO,ARBOLES,ARCHIVO_PROPIETARIOS,ARCHIVO_TER,ABMC_PROPIETARIOS,ABMC_TERRENOS,LISTADO_APYNOM,LISTADO,ESTADISTICAS,COMPROBANTE;

Procedure MENU_GENERAL;

implementation

Procedure MOSTRAR_TER(VAR ARCH_TER:t_archivo_terreno);
VAR
  I:word;
  X:t_dato_terreno;
begin
  If filesize(ARCH_TER)>0 then
    For I:=0 to filesize(ARCH_TER)-1 do
    begin
      obtener_reg_arch_ter(ARCH_TER,I,X);
      mostrar_terreno(X);
      writeln('');
      readkey;
    end;
end;

Procedure MENU_GENERAL;
VAR
  RAIZ_apynom:t_puntero_apynom;
  RAIZ_DNI:t_puntero_DNI;
  resp:string;
  ARCH_PROP:t_archivo_propietario;
  ARCH_TER:t_archivo_terreno;
begin
  crear_arbol_apynom(RAIZ_apynom);
  crear_arbol_DNI(RAIZ_DNI);
  repeat
     crear_abrir_prop(ARCH_PROP);
     crear_abrir_ter(ARCH_TER);
     generar_arboles(RAIZ_apynom,RAIZ_DNI,ARCH_PROP);
     estados(ARCH_PROP,ARCH_TER);
     clrscr;
     BOX;
     gotoxy(20,10);
     writeln('1: ABMC CONTRIBUYENTES');
     gotoxy(20,11);
     writeln('2: ABMC TERRENOS');
     gotoxy(20,12);
     writeln('3: LISTADO ORDENADO POR NOMBRE DE PROPIEDADES VALORIZADAS');
     gotoxy(20,13);
     writeln('4: LISTADO ORDENADO POR FECHA DE TODAS LAS INSCRIPCIONES EN CIERTO ANIO');
     gotoxy(20,14);
     writeln('5: LISTADO ORDENADO POR ZONAS DE TODOS LOS TERRENOS');
     gotoxy(20,15);
     writeln('6: IMPRESION DE COMPROBANTE');
     gotoxy(20,16);
     writeln('7: ESTADISTICAS');
     gotoxy(20,17);
     writeln('8: REINICIAR ARCHIVO PROPIETARIOS');
     gotoxy(20,18);
     writeln('9: REINICIAR ARCHIVO TERRENOS');
     gotoxy(20,19);
     writeln('0: SALIR');
     gotoxy(20,20);
     readln(resp);
     resp:=copy(resp,1,2);
     clrscr;
      case resp of
      '1':MENU_ABMC_PROPIETARIOS(ARCH_PROP,ARCH_TER,RAIZ_DNI,RAIZ_apynom);
      '2':MENU_ABMC_TERRENOS(ARCH_TER,ARCH_PROP,RAIZ_DNI);
      '3':LISTADO_CON_PROP_VAL(ARCH_PROP,ARCH_TER);
      '4':LISTADO_ANIO(ARCH_TER);
      '5':LISTADO_POR_ZONA(ARCH_TER);
      '6':TICKET_COMPROBANTE(ARCH_TER,ARCH_PROP,RAIZ_DNI);
      '7':MENU_ESTADISTICAS(ARCH_PROP,ARCH_TER);
      '8':REINICIAR_ARCHIVO_PROP(ARCH_PROP);
      '9':REINICIAR_ARCHIVO_TER(ARCH_TER);
      '10':MOSTRAR_TER(ARCH_TER);
      end;
      cerrar_prop(ARCH_PROP);
      cerrar_ter(ARCH_TER);
  until resp='0';
end;
end.

