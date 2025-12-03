program SimpleTest;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.Classes;
  
begin
  try
    WriteLn('Hello, world!');
    ReadLn;
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;
end. 