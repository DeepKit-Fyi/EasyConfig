program INIConfigTest;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.Classes, System.TypInfo, ConfigTypes, BaseConfig, INIConfig;
  
begin
  try
    WriteLn('娴嬭瘯INIConfig');
    ReadLn;
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;
end. 