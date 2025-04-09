program ConvertFilesToUTF8;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  UTF8Converter in 'UTF8Converter.pas' {frmUTF8Converter};

var
  Params: TArray<string>;
  i: Integer;
  SuccessCount: Integer;

begin
  try
    WriteLn('UTF-8 文件转换工具');
    WriteLn('-------------------');

    // 如果没有命令行参数，则使用默认参数
    if ParamCount = 0 then
    begin
      // 默认转换这些文件
      Params := [
        'ConfigManager.pas',
        'JSONConfig.pas',
        'ConfigEditor.dpr',
        '-d',
        GetCurrentDir
      ];
    end
    else
    begin
      // 使用命令行参数
      SetLength(Params, ParamCount);
      for i := 1 to ParamCount do
        Params[i-1] := ParamStr(i);
    end;

    // 执行转换
    SuccessCount := TfrmUTF8Converter.ExecuteCommandLine(Params);

    WriteLn(Format('转换完成，共成功转换 %d 个文件', [SuccessCount]));
    WriteLn('按任意键退出...');
    ReadLn;
  except
    on E: Exception do
    begin
      WriteLn('发生错误: ' + E.Message);
      ReadLn;
    end;
  end;
end.
