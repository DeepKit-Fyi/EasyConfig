program Test;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

begin
  try
    Writeln('Hello, World!');
    Readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end. 