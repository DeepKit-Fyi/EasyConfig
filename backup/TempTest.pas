program TempTest;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.Classes, System.JSON, System.TypInfo, ConfigTypes;
  
begin
  try
    WriteLn('娴嬭瘯閰嶇疆缂栬緫鍣?);
    WriteLn('杞崲鏋氫妇: ', GetEnumName(TypeInfo(TConfigType), Ord(etFont)));
    ReadLn;
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;
end. 