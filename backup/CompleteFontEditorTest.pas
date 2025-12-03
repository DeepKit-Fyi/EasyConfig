program CompleteFontEditorTest;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.Classes, System.TypInfo, System.JSON, 
  ConfigTypes, BaseConfig, JSONConfig, INIConfig, ConfigEditors, FontEditor;
  
var
  Factory: TConfigEditorFactory;
  Editor: TConfigEditorBase;
  FontObj: TFont;
  JSONObj: TJSONObject;
  
begin
  try
    WriteLn('娴嬭瘯瀹屾暣FontEditor娴佺▼');
    
    // 鍒涘缓瀛椾綋瀵硅薄
    FontObj := TFont.Create;
    try
      FontObj.Name := 'Arial';
      FontObj.Size := 12;
      FontObj.Style := [fsBold];
      
      // 鍒涘缓JSON瀵硅薄
      JSONObj := TJSONObject.Create;
      try
        // 灏嗗瓧浣撳璞¤浆鎹负JSON
        JSONObj.AddPair('Name', FontObj.Name);
        JSONObj.AddPair('Size', TJSONNumber.Create(FontObj.Size));
        JSONObj.AddPair('Style', TJSONNumber.Create(Byte(FontObj.Style)));
        
        WriteLn('宸插垱寤篔SON瀵硅薄: ', JSONObj.ToString);
        
        // 鍒涘缓閰嶇疆缂栬緫鍣ㄥ伐鍘?
        Factory := TConfigEditorFactory.Create;
        try
          // 鍒涘缓瀛椾綋缂栬緫鍣?
          Editor := Factory.CreateEditor(etFont);
          try
            WriteLn('宸插垱寤篎ontEditor');
            
            // 鍔犺浇JSON鏁版嵁
            Editor.Load(JSONObj);
            WriteLn('宸插姞杞芥暟鎹埌缂栬緫鍣?);
            
            // 妯℃嫙缂栬緫鎿嶄綔
            WriteLn('缂栬緫鍣ㄧ被鍨? ', Editor.ClassName);
            
            // 鑾峰彇淇敼鍚庣殑鏁版嵁
            JSONObj := Editor.Save;
            WriteLn('淇濆瓨鍚庣殑JSON鏁版嵁: ', JSONObj.ToString);
            
          finally
            Editor.Free;
          end;
        finally
          Factory.Free;
        end;
      finally
        JSONObj.Free;
      end;
    finally
      FontObj.Free;
    end;
    
    WriteLn('娴嬭瘯瀹屾垚');
    ReadLn;
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;
end. 