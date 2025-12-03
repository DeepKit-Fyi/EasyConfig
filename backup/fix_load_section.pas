﻿procedure TfrmMain.LoadSectionToEditor(const ConfigPath, SectionName: string);
var
  FileExt: string;
  IniFile: TMemIniFile;
  JsonFile: TJSONObject;
  Keys: TStringList;
  i: Integer;
  Key, Value: string;
  FileContent: string;
  JsonProperty: TJSONPair;
  EncodingUsed: TEncoding;
  EncodingOptions: array of TEncoding;
  SuccessfullyLoaded: Boolean;
begin
  try
    FormHelper.AddDebugText(meoDebug, '===== 寮€濮嬪姞杞借妭鍐呭 =====');
    
    // 娓呯┖褰撳墠缂栬緫鍣ㄥ唴瀹?
    FValueListEditor.Strings.Clear;
    
    // 淇濆瓨褰撳墠閰嶇疆璺緞
    FCurrentBasicConfigPath := ConfigPath;
    
    // 鏍规嵁鏂囦欢鎵╁睍鍚嶇‘瀹氶厤缃被鍨?
    FileExt := LowerCase(ExtractFileExt(ConfigPath));
    
    FormHelper.AddDebugText(meoDebug, '鍔犺浇鏂囦欢: ' + ConfigPath);
    FormHelper.AddDebugText(meoDebug, '鑺傚悕: ' + SectionName + ' (瀛楄妭闀垮害: ' + IntToStr(ByteLength(SectionName)) + ')');
    
    if FileExt = '.ini' then
    begin
      // 瀹氫箟灏濊瘯鐨勭紪鐮侀『搴?
      EncodingOptions := [TEncoding.UTF8, TEncoding.Unicode, TEncoding.Default, TEncoding.ASCII];
      SuccessfullyLoaded := False;
      
      // 灏濊瘯浣跨敤涓嶅悓鐨勭紪鐮佸姞杞絀NI鏂囦欢
      for EncodingUsed in EncodingOptions do
      begin
        if SuccessfullyLoaded then
          Break;
          
        FormHelper.AddDebugText(meoDebug, '灏濊瘯浣跨敤缂栫爜: ' + EncodingUsed.ClassName);
        
        try
          IniFile := TMemIniFile.Create(ConfigPath, EncodingUsed);
          try
            Keys := TStringList.Create;
            try
              // 娣诲姞鑺傛爣棰?
              try
                var SectionHeader := '[' + SectionName + ']';
                FormHelper.AddDebugText(meoDebug, '姝ｅ湪娣诲姞鑺傛爣棰? ' + SectionHeader);
                
                FValueListEditor.InsertRow(SectionHeader, '', True);
                FormHelper.AddDebugText(meoDebug, '鎴愬姛娣诲姞鑺傛爣棰?);
                
                // 璇诲彇璇ヨ妭涓殑鎵€鏈夐敭
                IniFile.ReadSection(SectionName, Keys);
                
                FormHelper.AddDebugText(meoDebug, '鑺傚寘鍚?' + IntToStr(Keys.Count) + ' 涓敭');
                
                for i := 0 to Keys.Count - 1 do
                begin
                  Key := Keys[i];
                  Value := IniFile.ReadString(SectionName, Key, '');
                  
                  // 娣诲姞鍒板€煎垪琛ㄧ紪杈戝櫒
                  try
                    var FullKey := SectionName + '.' + Key;
                    FormHelper.AddDebugText(meoDebug, '娣诲姞閿€煎: ' + FullKey + ' = ' + Value);
                    
                    FValueListEditor.Values[FullKey] := Value;
                  except
                    on E: Exception do
                    begin
                      FormHelper.AddDebugText(meoDebug, '娣诲姞閿€煎鏃跺嚭閿? ' + E.Message);
                      // 缁х画灏濊瘯娣诲姞鍏朵粬閿€煎
                    end;
                  end;
                end;
                
                SuccessfullyLoaded := True;
                FormHelper.AddDebugText(meoDebug, '浣跨敤 ' + EncodingUsed.ClassName + ' 缂栫爜鎴愬姛鍔犺浇鑺傚唴瀹?);
              except
                on E: Exception do
                begin
                  FormHelper.AddDebugText(meoDebug, '浣跨敤 ' + EncodingUsed.ClassName + ' 缂栫爜娣诲姞鑺傛爣棰樻椂鍑洪敊: ' + E.Message);
                  // 灏嗗湪涓嬩竴娆″惊鐜腑灏濊瘯鍏朵粬缂栫爜
                end;
              end;
            finally
              Keys.Free;
            end;
          finally
            IniFile.Free;
          end;
        except
          on E: Exception do
          begin
            FormHelper.AddDebugText(meoDebug, '浣跨敤 ' + EncodingUsed.ClassName + ' 缂栫爜鍔犺浇鏂囦欢鏃跺嚭閿? ' + E.Message);
            // 灏嗗湪涓嬩竴娆″惊鐜腑灏濊瘯鍏朵粬缂栫爜
          end;
        end;
      end;
      
      if not SuccessfullyLoaded then
      begin
        FormHelper.AddDebugText(meoDebug, '鎵€鏈夌紪鐮佸皾璇曞潎澶辫触锛屾棤娉曞姞杞借妭鍐呭');
        ShowMessage('鏃犳硶鍔犺浇閰嶇疆鑺? ' + SectionName + '銆傚彲鑳藉寘鍚笉鏀寔鐨勫瓧绗︾紪鐮併€?);
      end;
    end
    else if FileExt = '.json' then
    begin
      // 灏濊瘯浣跨敤涓嶅悓鐨勭紪鐮佸姞杞絁SON鏂囦欢
      EncodingOptions := [TEncoding.UTF8, TEncoding.Unicode, TEncoding.Default];
      SuccessfullyLoaded := False;
      
      for EncodingUsed in EncodingOptions do
      begin
        if SuccessfullyLoaded then
          Break;
          
        FormHelper.AddDebugText(meoDebug, '灏濊瘯浣跨敤缂栫爜: ' + EncodingUsed.ClassName + ' 鍔犺浇JSON鏂囦欢');
        
        try
          if FileExists(ConfigPath) then
          begin
            try
              // 浣跨敤鎸囧畾缂栫爜璇诲彇鏂囦欢
              FileContent := TFile.ReadAllText(ConfigPath, EncodingUsed);
              JsonFile := TJSONObject(TJSONObject.ParseJSONValue(FileContent));
              
              if JsonFile <> nil then
              begin
                try
                  // 娣诲姞JSON鏍硅妭鐐规爣棰?
                  try
                    FValueListEditor.InsertRow('[JSON鏍硅妭鐐筣', '', True);
                    FormHelper.AddDebugText(meoDebug, '娣诲姞JSON鏍硅妭鐐规爣棰樻垚鍔?);
                  except
                    on E: Exception do
                    begin
                      FormHelper.AddDebugText(meoDebug, '娣诲姞JSON鏍硅妭鐐规爣棰樻椂鍑洪敊: ' + E.Message);
                      Continue; // 灏濊瘯涓嬩竴绉嶇紪鐮?
                    end;
                  end;
                
                  // 閬嶅巻JSON瀵硅薄鐨勬墍鏈夐敭鍊煎
                  for i := 0 to JsonFile.Count - 1 do
                  begin
                    JsonProperty := JsonFile.Pairs[i];
                    Key := JsonProperty.JsonString.Value;
                    
                    // 灏咼SON鍊艰浆鎹负瀛楃涓?
                    if JsonProperty.JsonValue is TJSONString then
                      Value := TJSONString(JsonProperty.JsonValue).Value
                    else if JsonProperty.JsonValue is TJSONNumber then
                      Value := TJSONNumber(JsonProperty.JsonValue).ToString
                    else if JsonProperty.JsonValue is TJSONBool then
                      Value := BoolToStr(TJSONBool(JsonProperty.JsonValue).AsBoolean, True)
                    else if JsonProperty.JsonValue is TJSONObject then
                      Value := '[Object]'
                    else if JsonProperty.JsonValue is TJSONArray then
                      Value := '[Array]'
                    else
                      Value := JsonProperty.JsonValue.ToString;
                    
                    // 娣诲姞鍒板€煎垪琛ㄧ紪杈戝櫒
                    try
                      var FullKey := 'JSON鏍硅妭鐐?' + Key;
                      FormHelper.AddDebugText(meoDebug, '娣诲姞JSON閿€煎: ' + FullKey);
                      
                      FValueListEditor.Values[FullKey] := Value;
                    except
                      on E: Exception do
                      begin
                        FormHelper.AddDebugText(meoDebug, '娣诲姞JSON閿€煎鏃跺嚭閿? ' + E.Message);
                        // 缁х画灏濊瘯娣诲姞鍏朵粬閿€煎
                      end;
                    end;
                  end;
                  
                  SuccessfullyLoaded := True;
                  FormHelper.AddDebugText(meoDebug, '浣跨敤 ' + EncodingUsed.ClassName + ' 缂栫爜鎴愬姛鍔犺浇JSON鍐呭');
                finally
                  JsonFile.Free;
                end;
              end;
            except
              on E: Exception do
              begin
                FormHelper.AddDebugText(meoDebug, '浣跨敤 ' + EncodingUsed.ClassName + ' 缂栫爜瑙ｆ瀽JSON澶辫触: ' + E.Message);
                // 灏嗗湪涓嬩竴娆″惊鐜腑灏濊瘯鍏朵粬缂栫爜
              end;
            end;
          end;
        except
          on E: Exception do
          begin
            FormHelper.AddDebugText(meoDebug, '浣跨敤 ' + EncodingUsed.ClassName + ' 缂栫爜鍔犺浇JSON鍐呭澶辫触: ' + E.Message);
            // 灏嗗湪涓嬩竴娆″惊鐜腑灏濊瘯鍏朵粬缂栫爜
          end;
        end;
      end;
      
      if not SuccessfullyLoaded then
      begin
        FormHelper.AddDebugText(meoDebug, '鎵€鏈夌紪鐮佸皾璇曞潎澶辫触锛屾棤娉曞姞杞絁SON鍐呭');
        ShowMessage('鏃犳硶鍔犺浇JSON閰嶇疆銆傚彲鑳藉寘鍚笉鏀寔鐨勫瓧绗︾紪鐮併€?);
      end;
    end;
    
    // 鏄剧ず鍩虹淇℃伅閫夐」鍗?
    FBasicInfoTab.TabVisible := True;
    pcEditors.ActivePage := FBasicInfoTab;
    
    FormHelper.AddDebugText(meoDebug, '===== 鑺傚唴瀹瑰姞杞藉畬鎴?=====');
  except
    on E: Exception do
    begin
      FormHelper.AddDebugText(meoDebug, '鍔犺浇鑺傛椂鍑虹幇鏈鐞嗙殑寮傚父: ' + E.Message);
      ShowMessage('鍑虹幇閿欒: ' + E.Message);
    end;
  end;
end; 
