unit MARCO;
interface
uses
  crt;

Procedure BOX;

implementation

Procedure BOX;
  VAR
   x1,y1:byte;
begin
    x1:=15;
    y1:=5;
    repeat
      gotoxy(x1,5);
      writeln('#');
      gotoxy(x1,25);
      writeln('#');
      x1:=x1+1;
    until x1=100;

    repeat
      gotoxy(x1,y1);
      writeln('#');
      gotoxy(14,y1);
      writeln('#');
      y1:=y1+1;
    until y1=25;
end;

end.

