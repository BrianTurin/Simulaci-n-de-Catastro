unit ARBOLES;

interface

uses
  crt;

Type
  t_dato_arbol_apynom=record
    clave:string;
    pos:word;
  end;

  t_dato_arbol_DNI=record
    clave:integer;
    pos:word;
  end;

 t_puntero_apynom=^t_nodo_apynom;

 t_nodo_apynom=record
   info:t_dato_arbol_apynom;
   SAI,SAD:t_puntero_apynom
 end;

  t_puntero_DNI=^t_nodo_DNI;

  t_nodo_DNI=record
    info:t_dato_arbol_DNI;
    SAI,SAD:t_puntero_DNI;
  end;

  Procedure crear_arbol_apynom(VAR RAIZ_apynom:t_puntero_apynom);
  Procedure crear_arbol_DNI(VAR RAIZ_DNI:t_puntero_DNI);
  Procedure agregar_apynom (VAR RAIZ:t_puntero_apynom; X:t_dato_arbol_apynom);
  Procedure agregar_DNI (VAR RAIZ:t_puntero_DNI; X:t_dato_arbol_DNI);
 { Function arbol_vacio_apynom (RAIZ:t_puntero_apynom):boolean;
  Function arbol_vacio_DNI (RAIZ:t_puntero_DNI):boolean;
  Function arbol_lleno_apynom (RAIZ:t_puntero_apynom):boolean;
  Function arbol_lleno_DNI (RAIZ:t_puntero_DNI):boolean;
  Procedure inorden_apynom (VAR RAIZ:t_puntero_apynom);
  Procedure inorden_DNI(VAR RAIZ:t_puntero_DNI);}
  Function preorden_apynom (RAIZ:t_puntero_apynom;BUSCADO:string):t_puntero_apynom;
  Function preorden_DNI (RAIZ:t_puntero_DNI;BUSCADO:integer):t_puntero_DNI;

implementation

Procedure crear_arbol_apynom(VAR RAIZ_apynom:t_puntero_apynom);
begin
  RAIZ_apynom:=NIL;
end;

Procedure crear_arbol_DNI(VAR RAIZ_DNI:t_puntero_DNI);
begin
  RAIZ_DNI:=NIL;
end;

Procedure agregar_apynom (VAR RAIZ:t_puntero_apynom; X:t_dato_arbol_apynom);
begin
  If RAIZ=NIL then
  begin
    new(RAIZ);
    RAIZ^.info:=X;
    RAIZ^.SAI:=NIL;
    RAIZ^.SAD:=NIL;
  end
  else
  begin
    If RAIZ^.info.clave>X.clave then
    begin
      agregar_apynom(RAIZ^.SAI,X);
    end
    else
    begin
      agregar_apynom(RAIZ^.SAD,X);
    end;
  end;
end;

Procedure agregar_DNI (VAR RAIZ:t_puntero_DNI; X:t_dato_arbol_DNI);
begin
  If RAIZ=NIL then
  begin
    new(RAIZ);
    RAIZ^.info:=X;
    RAIZ^.SAI:=NIL;
    RAIZ^.SAD:=NIL;
  end
  else
  begin
    If RAIZ^.info.clave>X.clave then
    begin
      agregar_DNI(RAIZ^.SAI,X);
    end
    else
    begin
      agregar_DNI(RAIZ^.SAD,X);
    end;
  end;
end;
{
Function arbol_vacio_apynom (RAIZ:t_puntero_apynom):boolean;
begin
  arbol_vacio_apynom:=RAIZ=NIL;
end;

Function arbol_vacio_DNI (RAIZ:t_puntero_DNI):boolean;
begin
  arbol_vacio_DNI:=RAIZ=NIL;
end;

Function arbol_lleno_apynom (RAIZ:t_puntero_apynom):boolean;
begin
  arbol_lleno_apynom:=RAIZ=NIL;
end;

Function arbol_lleno_DNI (RAIZ:t_puntero_DNI):boolean;
begin
  arbol_lleno_DNI:=RAIZ=NIL;
end;

Procedure inorden_apynom (VAR RAIZ:t_puntero_apynom);
begin
  If RAIZ<>NIL then
  begin
    inorden_apynom(RAIZ^.SAI);
                                    ////writeln(RAIZ^.info.clave); ////////POSIBLE MODIFICACION
    inorden_apynom(RAIZ^.SAD);
  end;
end;

Procedure inorden_DNI(VAR RAIZ:t_puntero_DNI);
begin
  If RAIZ<>NIL then
  begin
    inorden_DNI(RAIZ^.SAI);
    writeln(RAIZ^.info.clave); ////////POSIBLE MODIFICACION
    inorden_DNI(RAIZ^.SAD);
  end;
end;
            }
Function preorden_apynom (RAIZ:t_puntero_apynom;BUSCADO:string):t_puntero_apynom;
begin
  If (RAIZ=NIL) then
  begin
    preorden_apynom:=NIL;
  end
  else
  begin
    If RAIZ^.info.clave=BUSCADO then
    begin
      preorden_apynom:=RAIZ;
    end
    else
    begin
      If RAIZ^.info.clave>BUSCADO then
      begin
        preorden_apynom:=preorden_apynom(RAIZ^.SAI,BUSCADO);
      end
      else
      begin
        preorden_apynom:=preorden_apynom(RAIZ^.SAD,BUSCADO);
      end;
    end;
  end;
end;

Function preorden_DNI (RAIZ:t_puntero_DNI;BUSCADO:integer):t_puntero_DNI;
begin
  If (RAIZ=NIL) then
  begin
    preorden_DNI:=NIL;
  end
  else
  begin
    If RAIZ^.info.clave=BUSCADO then
    begin
      preorden_DNI:=RAIZ;
    end
    else
    begin
      If RAIZ^.info.clave>BUSCADO then
      begin
        preorden_DNI:=preorden_DNI(RAIZ^.SAI,BUSCADO);
      end
      else
      begin
        preorden_DNI:=preorden_DNI(RAIZ^.SAD,BUSCADO);
      end;
    end;
  end;
end;
end.

