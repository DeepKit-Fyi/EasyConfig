program ThemeTest;

{$APPTYPE CONSOLE}
{$WARN IMPLICIT_STRING_CAST OFF}

uses
  System.SysUtils,
  Vcl.Styles,
  Vcl.Themes;

var
  StyleNames: TArray<string>;
  i: Integer;

begin
  try
    WriteLn('正在查找可用的主题...');
    StyleNames := TStyleManager.StyleNames;
    WriteLn('找到 ', Length(StyleNames), ' 个主题:');
    for i := 0 to High(StyleNames) do
    begin
      WriteLn(i+1, '. ', StyleNames[i]);
    end;
    WriteLn('当前激活的主题: ', TStyleManager.ActiveStyle.Name);
    WriteLn('测试完成，按回车键退出...');
    ReadLn;
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;
end. 