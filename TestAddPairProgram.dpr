program TestAddPairProgram;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.JSON,
  JSONHelpers,
  TestAddPair in 'TestAddPair.pas';

begin
  try
    TestJSON;
  except
    on E: Exception do
      WriteLn('Error: ' + E.Message);
  end;
  ReadLn;
end. 