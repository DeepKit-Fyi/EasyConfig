program ConfigEditorsTest;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.Classes, System.TypInfo, System.JSON, ConfigTypes, 
  BaseConfig, JSONConfig, INIConfig, ConfigEditors;
  
begin
  try
    WriteLn('娴嬭瘯ConfigEditors');
    ReadLn;
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;
end. 