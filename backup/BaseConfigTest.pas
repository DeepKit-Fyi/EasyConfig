program BaseConfigTest;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.Classes, System.TypInfo, ConfigTypes, BaseConfig;
  
begin
  try
    WriteLn('娴嬭瘯BaseConfig');
    ReadLn;
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;
end. 