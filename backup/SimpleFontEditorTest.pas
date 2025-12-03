program SimpleFontEditorTest;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.Classes, System.TypInfo, System.JSON, ConfigTypes, 
  Vcl.Graphics, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Controls;
  
var
  Color: TColor;
  Style: TFontStyles;
  StyleOrd: Byte;
  
begin
  try
    WriteLn('娴嬭瘯瀛椾綋鐨勫熀鏈睘鎬?);
    
    // 娴嬭瘯TColor
    Color := clRed;
    WriteLn('Red Color = ', Color);
    
    // 娴嬭瘯TFontStyles
    Style := [fsBold, fsItalic];
    StyleOrd := Byte(Style);
    WriteLn('Bold+Italic Style = ', StyleOrd);
    
    // TConfigType鏋氫妇绫诲瀷
    WriteLn('etFont鍊? ', Ord(etFont));
    WriteLn('etFont鍚嶇О: ', GetEnumName(TypeInfo(TConfigType), Ord(etFont)));
    
    // 娴嬭瘯鍒涘缓JSON瀵硅薄
    with TJSONObject.Create do
    try
      AddPair('Name', 'Arial');
      AddPair('Size', TJSONNumber.Create(12));
      AddPair('Style', TJSONNumber.Create(StyleOrd));
      AddPair('Color', TJSONNumber.Create(Integer(Color)));
      
      WriteLn('Font JSON: ', ToString);
    finally
      Free;
    end;
    
    WriteLn('娴嬭瘯瀹屾垚');
    ReadLn;
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;
end. 