program TempFontEditorTest;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.Classes, System.TypInfo, System.JSON, ConfigTypes,
  TempFontEditor;
  
var
  Editor: TFontEditor;
  JSONObj: TJSONObject;
  NewJSONObj: TJSONObject;
  
begin
  try
    WriteLn('娴嬭瘯TempFontEditor娴佺▼');
    
    // 鍒涘缓JSON瀵硅薄
    JSONObj := TJSONObject.Create;
    try
      JSONObj.AddPair('Name', 'Arial');
      JSONObj.AddPair('Size', TJSONNumber.Create(12));
      JSONObj.AddPair('Style', TJSONNumber.Create(1)); // fsBold
      JSONObj.AddPair('Color', TJSONNumber.Create(255)); // clRed
      
      WriteLn('鍘熷JSON瀵硅薄: ', JSONObj.ToString);
      
      // 鍒涘缓瀛椾綋缂栬緫鍣?
      Editor := TFontEditor.Create;
      try
        WriteLn('宸插垱寤篢empFontEditor');
        WriteLn('缂栬緫鍣ㄧ被鍨? ', GetEnumName(TypeInfo(TConfigType), Ord(Editor.GetEditorType)));
        
        // 鍔犺浇JSON鏁版嵁
        Editor.Load(JSONObj);
        WriteLn('宸插姞杞芥暟鎹埌缂栬緫鍣?);
        
        // 淇濆瓨鏁版嵁
        NewJSONObj := Editor.Save;
        try
          WriteLn('淇濆瓨鍚庣殑JSON鏁版嵁: ', NewJSONObj.ToString);
        finally
          NewJSONObj.Free;
        end;
      finally
        Editor.Free;
      end;
    finally
      JSONObj.Free;
    end;
    
    WriteLn('娴嬭瘯瀹屾垚');
    ReadLn;
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;
end. 