program EncodingTest;

{$APPTYPE CONSOLE}
{$WARN IMPLICIT_STRING_CAST OFF}

uses
  System.SysUtils,
  System.Classes,
  System.IniFiles;

var
  IniFile: TMemIniFile;
  EncodingOptions: array of TEncoding;
  EncodingUsed: TEncoding;
  i: Integer;
  TestFileName: string;
  TestSectionName: string;
  Keys: TStringList;
  SectionNames: TStringList;
  j: Integer;

begin
  try
    TestFileName := 'test_encoding.ini';
    TestSectionName := '测试节';
    
    // 创建一个包含中文的测试INI文件
    IniFile := TMemIniFile.Create(TestFileName, TEncoding.UTF8);
    try
      IniFile.WriteString(TestSectionName, '键1', '值1');
      IniFile.WriteString(TestSectionName, '键2', '值2');
      IniFile.WriteString(TestSectionName, '键3', '值3');
      IniFile.UpdateFile;
    finally
      IniFile.Free;
    end;
    
    WriteLn('已创建测试文件: ', TestFileName);
    
    // 定义要尝试的编码
    EncodingOptions := [TEncoding.UTF8, TEncoding.Unicode, TEncoding.Default, TEncoding.ASCII];
    
    // 尝试使用不同的编码读取INI文件
    for i := 0 to High(EncodingOptions) do
    begin
      EncodingUsed := EncodingOptions[i];
      WriteLn('尝试使用编码: ', EncodingUsed.ClassName);
      
      try
        IniFile := TMemIniFile.Create(TestFileName, EncodingUsed);
        try
          SectionNames := TStringList.Create;
          try
            IniFile.ReadSections(SectionNames);
            WriteLn('找到的节: ', SectionNames.Count);
            
            for j := 0 to SectionNames.Count - 1 do
            begin
              WriteLn('节名: ', SectionNames[j], ' (字节长度: ', ByteLength(SectionNames[j]), ')');
              
              Keys := TStringList.Create;
              try
                IniFile.ReadSection(SectionNames[j], Keys);
                WriteLn('节 ', SectionNames[j], ' 包含 ', Keys.Count, ' 个键');
                
                if Keys.Count > 0 then
                begin
                  WriteLn('示例键: ', Keys[0]);
                  WriteLn('示例值: ', IniFile.ReadString(SectionNames[j], Keys[0], ''));
                end;
              finally
                Keys.Free;
              end;
            end;
          finally
            SectionNames.Free;
          end;
        finally
          IniFile.Free;
        end;
        
        WriteLn('使用 ', EncodingUsed.ClassName, ' 编码成功读取');
      except
        on E: Exception do
        begin
          WriteLn('使用 ', EncodingUsed.ClassName, ' 编码读取失败: ', E.Message);
        end;
      end;
      
      WriteLn('---');
    end;
    
    WriteLn('测试完成，按回车键退出...');
    ReadLn;
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;
end. 