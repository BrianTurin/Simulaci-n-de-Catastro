unit ARCHIVO_PROPIETARIOS;
interface
uses
  crt;

CONST
  RUTA_PROPIETARIO='C:\archivos\propietarios.dat';

Type
  t_dato_propietario=record
    num_con:word;
    apellido:string[40];
    nombre:string[40];
    direccion:string[40];
    ciudad:string[40];
    DNI:integer;
    fecha_nac:string[10];
    tel:cardinal;
    mail:string[70] ;
    estado:boolean;
  end;

   t_archivo_propietario=file of t_dato_propietario;

Procedure crear_abrir_prop (VAR ARCH_PROP:t_archivo_propietario);
Procedure cerrar_prop (VAR ARCH_PROP:t_archivo_propietario);
Procedure obtener_reg_arch_prop(VAR ARCH_PROP:t_archivo_propietario;I:word; VAR X:t_dato_propietario);
Procedure ingresar_dato_arch_prop(VAR ARCH_PROP:t_archivo_propietario;X:t_dato_propietario);
{Procedure baja_logica_prop(VAR ARCH_PROP:t_archivo_propietario;pos:word);}
Procedure baja_logica (VAR ARCH_PROP:t_archivo_propietario;pos:word);
Procedure REINICIAR_ARCHIVO_PROP(VAR ARCH_PROP:t_archivo_propietario);

implementation
Procedure crear_abrir_prop (VAR ARCH_PROP:t_archivo_propietario);
begin
  assign(ARCH_PROP,RUTA_PROPIETARIO);
  {$I-}
  reset(ARCH_PROP);
  {$I+}
  If IOResult<>0 then
   rewrite(ARCH_PROP);
end;

Procedure cerrar_prop (VAR ARCH_PROP:t_archivo_propietario);
begin
  close(ARCH_PROP);
end;

Procedure obtener_reg_arch_prop(VAR ARCH_PROP:t_archivo_propietario;I:word; VAR X:t_dato_propietario);
begin
  seek(ARCH_PROP,I);
  read(ARCH_PROP,X);
end;

Procedure ingresar_dato_arch_prop(VAR ARCH_PROP:t_archivo_propietario;X:t_dato_propietario);
begin
  If filesize(ARCH_PROP)=0 then
  begin
    seek(ARCH_PROP,0);
    write(ARCH_PROP,X);
  end
  else
  begin
    seek(ARCH_PROP,filesize(ARCH_PROP));
    write(ARCH_PROP,X);
  end;
end;

{Procedure baja_logica_prop(VAR ARCH_PROP:t_archivo_propietario;pos:word);
VAR
  REG:t_dato_propietario;
begin
  seek(ARCH_PROP,pos);
  read(ARCH_PROP,REG);
  REG.estado:=false;
  write(ARCH_PROP,REG);
end;}

Procedure baja_logica (VAR ARCH_PROP:t_archivo_propietario;pos:word);
VAR
  REG:t_dato_propietario;
begin
  seek(ARCH_PROP,pos);
  read(ARCH_PROP,REG);
  REG.estado:=false;
  seek(ARCH_PROP,pos);
  write(ARCH_PROP,REG);
end;

Procedure REINICIAR_ARCHIVO_PROP(VAR ARCH_PROP:t_archivo_propietario);
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
    close(ARCH_PROP);
    erase(ARCH_PROP);
    crear_abrir_prop(ARCH_PROP);
  end;
end;

end.

