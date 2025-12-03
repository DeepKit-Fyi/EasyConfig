program ConfigTypesTest;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.Classes, System.TypInfo, ConfigTypes;
  
begin
  try
    WriteLn('娴嬭瘯ConfigTypes');
    WriteLn('etFont: ', GetEnumName(TypeInfo(TConfigType), Ord(etFont)));
    WriteLn('etDatabase: ', GetEnumName(TypeInfo(TConfigType), Ord(etDatabase)));
    ReadLn;
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;
end. 