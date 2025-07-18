unit LISTADO_APYNOM;
interface
uses
 MARCO,ABMC_TERRENOS,crt,ARCHIVO_PROPIETARIOS,ARCHIVO_TER,ARBOLES;

Procedure mostrar_nom_ap (X:t_dato_propietario);
Procedure contador_terrenos(VAR ARCH_TER:t_archivo_terreno;num_con:word;VAR I:word);
Procedure calcular_valor_ter( X:t_dato_terreno;VAR valor:real);
Procedure muestra_terreno(X:t_dato_terreno;valor:real);
Procedure mostrar_prop_val(VAR ARCH_TER:t_archivo_terreno;J:word);
Procedure LISTADO_CON_PROP_VAL(VAR ARCH_PROP:t_archivo_propietario; VAR ARCH_TER:t_archivo_terreno);

implementation

Procedure mostrar_nom_ap (X:t_dato_propietario);
begin
 clrscr;
 BOX;
 gotoxy(30,10);
 writeln('NOMBRE: ',X.nombre);
 gotoxy(30,13);
 writeln('APELLIDO: ',X.apellido);
 gotoxy(30,20);
 writeln('PULSE UNA TECLA PARA CONTINUAR');
 readkey;
end;

Procedure contador_terrenos(VAR ARCH_TER:t_archivo_terreno;num_con:word;VAR I:word);
VAR
  X:t_dato_terreno;
  L:word;
begin
 I:=1;
 primer_terreno(ARCH_TER,num_con,L);
 obtener_reg_arch_ter(ARCH_TER,L,X);
 while (X.num_con=num_con) and (L<filesize(ARCH_TER)-1) do
 begin
   I:=I+1;
   L:=L+1;
   obtener_reg_arch_ter(ARCH_TER,L,X);
 end;
end;

Procedure calcular_valor_ter( X:t_dato_terreno;VAR valor:real);
begin
 valor:=X.superficie_terreno*12308.60; /// ¿Esto esta incluido en avaluo?
 valor:=valor*X.zona;
 valor:=valor*X.tipo_edif;
end;

Procedure muestra_terreno(X:t_dato_terreno;valor:real);
begin
 clrscr;
 BOX;
 gotoxy(30,10);
 writeln('NUMERO DE CONTRIBUYENTE: ',X.num_con);
 gotoxy(30,11);
 writeln('NUMERO DE MENSURA: ',X.num_mensura);
 gotoxy(30,12);
 writeln('AVALUO: ',X.avaluo:6:2);
 gotoxy(30,13);
 writeln('FECHA DE INSCRIPCION: ',X.fecha_ins);
 gotoxy(30,14);
 writeln('DOMICILIO PARCELARIO: ',X.dom_par);
 gotoxy(30,15);
 writeln('SUPERFICIE DE TERRENO: ',X.superficie_terreno:6:2);
 gotoxy(30,16);
 writeln('ZONA: ',X.zona);
 gotoxy(30,17);
 writeln('TIPO DE EDIFICACION: ',X.tipo_edif);
 gotoxy(30,18);
 writeln('VALOR FINAL: ',valor:6:2);
 readkey;
end;

Procedure mostrar_prop_val(VAR ARCH_TER:t_archivo_terreno;J:word);
VAR
  X:t_dato_terreno;
  valor:real;
begin
   obtener_reg_arch_ter(ARCH_TER,J,X);
   calcular_valor_ter(X,valor);
   muestra_terreno(X,valor);
end;

Procedure LISTADO_CON_PROP_VAL(VAR ARCH_PROP:t_archivo_propietario; VAR ARCH_TER:t_archivo_terreno);
VAR
  I,L,J,K:word;
  info_act:t_puntero_apynom;
  X:t_dato_propietario;
  REG_TER:t_dato_terreno;
  actual:t_puntero_apynom;
begin
  If (filesize(ARCH_PROP)>0) and (filesize(ARCH_TER)>0) then
  begin
    For I:=0 to filesize(ARCH_PROP)-1 do
    begin
     clrscr;
     obtener_reg_arch_prop(ARCH_PROP,I,X);
     If (X.estado=true) then
     begin
       mostrar_nom_ap(X);
       J:=0;
       K:=0;
       L:=0;
       obtener_reg_arch_ter(ARCH_TER,0,REG_TER);
       while (X.num_con<>REG_TER.num_con) and (J<filesize(ARCH_TER)-1) do
       begin
        obtener_reg_arch_ter(ARCH_TER,J,REG_TER);
        J:=J+1;
       end;
       K:=J;
       while (X.num_con=REG_TER.num_con) and (K<filesize(ARCH_TER)-1) do
       begin
         obtener_reg_arch_ter(ARCH_TER,K,REG_TER);
         K:=K+1;
       end;
       For L:=J to K do
       begin
         obtener_reg_arch_ter(ARCH_TER,L,REG_TER);
         If REG_TER.num_con=X.num_con then
          mostrar_prop_val(ARCH_TER,L);
       end;
     end;
    end;
  { For I:=0 to filesize(ARCH_PROP)-1 do
   begin
     obtener_reg_arch_prop(ARCH_PROP,I,X);
     If X.estado=true then
     begin
       mostrar_nom_ap(X);
       contador_terrenos(ARCH_TER,X.num_con,J);
       primer_terreno(ARCH_TER,X.num_con,L);
       J:=J+L;
       For K:=L to J do
         mostrar_prop_val(ARCH_TER,X.num_con,K);
     end;
   end;}
  end
  else
  begin
   clrscr;
   BOX;
   gotoxy(30,10);
   writeln('NO EXISTEN DATOS SUFICIENTES');
   readkey;
  end;
 end;

end.

