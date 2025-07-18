unit COMPROBANTE;
interface
uses
  crt,ABMC_TERRENOS,ARCHIVO_TER,ARCHIVO_PROPIETARIOS,ARBOLES,MARCO;

Procedure TICKET_COMPROBANTE(VAR ARCH_TER:t_archivo_terreno;VAR ARCH_PROP:t_archivo_propietario;RAIZ_DNI:t_puntero_DNI);

implementation

Procedure TICKET_COMPROBANTE(VAR ARCH_TER:t_archivo_terreno;VAR ARCH_PROP:t_archivo_propietario;RAIZ_DNI:t_puntero_DNI);
VAR
  XDNI:t_puntero_DNI;
  ENC:boolean;
  DNI:integer;
  REG_PROP:t_dato_propietario;
begin
  CONSULTA_TERRENO(ARCH_TER,ARCH_PROP,RAIZ_DNI,DNI,ENC);
  XDNI:=preorden_DNI(RAIZ_DNI,DNI);
  If XDNI<>NIL then
  begin
    obtener_reg_arch_prop(ARCH_PROP,XDNI^.info.pos,REG_PROP);
    If (REG_PROP.estado=true) and ENC then
    begin
    gotoxy(30,20);
    writeln('SE CERTIFICA POR MEDIO DE ESTE COMPROBANTE LA PROPIEDAD DEL TERRENO');
    gotoxy(30,21);
    writeln('DE ',REG_PROP.apellido,' ',REG_PROP.nombre);
    end;
  end;
  readkey;
end;

end.

