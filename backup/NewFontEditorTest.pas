program NewFontEditorTest;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.Classes, System.TypInfo, System.JSON, ConfigTypes,
  ConfigEditorsBase, NewConfigEditors, NewFontEditor;
  
var
  Editor: IConfigEditor;
  JSONObj: TJSONObject;
  
begin
  try
    WriteLn('娴嬭瘯鏂版灦鏋勭殑FontEditor娴佺▼');
    
    // 娉ㄥ唽缂栬緫鍣ㄥ垱寤哄嚱鏁?
    RegisterConfigEditor(etFont, CreateFontEditor);
    WriteLn('宸叉敞鍐屽瓧浣撶紪杈戝櫒');
    
    // 鍒涘缓JSON瀵硅薄
    JSONObj := TJSONObject.Create;
    try
      JSONObj.AddPair('Name', 'Arial');
      JSONObj.AddPair('Size', TJSONNumber.Create(12));
      JSONObj.AddPair('Style', TJSONNumber.Create(1)); // fsBold
      JSONObj.AddPair('Color', TJSONNumber.Create(255)); // clRed
      
      WriteLn('鍘熷JSON瀵硅薄: ', JSONObj.ToString);
      
      // 閫氳繃宸ュ巶鍒涘缓瀛椾綋缂栬緫鍣?
      Editor := TConfigEditorFactory.CreateEditor(etFont);
      if Assigned(Editor) then
      try
        WriteLn('宸插垱寤篘ewFontEditor, 绫诲瀷: ', Editor.EditorType);
        
        // 鍔犺浇JSON鏁版嵁
        Editor.Load(JSONObj);
        WriteLn('宸插姞杞芥暟鎹埌缂栬緫鍣?);
        
        // 淇濆瓨鏁版嵁
        JSONObj := Editor.Save;
        WriteLn('淇濆瓨鍚庣殑JSON鏁版嵁: ', JSONObj.ToString);
      finally
        // 鎺ュ彛浼氳嚜鍔ㄩ噴鏀?
      end
      else
        WriteLn('鍒涘缓缂栬緫鍣ㄥけ璐?);
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