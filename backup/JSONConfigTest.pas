program JSONConfigTest;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.Classes, System.TypInfo, ConfigTypes, BaseConfig, JSONConfig;
  
begin
  try
    WriteLn('娴嬭瘯JSONConfig');
    ReadLn;
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;
end. 