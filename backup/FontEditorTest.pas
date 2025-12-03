program FontEditorTest;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.Classes, System.TypInfo, System.JSON, ConfigTypes;
  
begin
  try
    WriteLn('娴嬭瘯FontEditor');
    WriteLn('etFont鍊? ', Ord(etFont));
    WriteLn('etFont鍚嶇О: ', GetEnumName(TypeInfo(TConfigType), Ord(etFont)));
    ReadLn;
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;
end. 