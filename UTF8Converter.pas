unit UTF8Converter;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.IOUtils;

type
  TfrmUTF8Converter = class(TForm)
    memLog: TMemo;
    btnClose: TButton;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure AddLog(const Msg: string);
    function ConvertFileToUTF8(const FileName: string): Boolean;
    function DetectFileEncoding(const FileName: string): TEncoding;
    function IsUTF8File(const FileName: string): Boolean;
  public
    class function Execute(const FileName: string = ''): Boolean;
    class function ExecuteCommandLine(const Params: TArray<string>): Integer;
    function ConvertFilesToUTF8(const FileNames: TArray<string>): Integer;
    function ConvertDirectoryToUTF8(const Directory: string; const FileMask: string = '*.pas;*.dfm'): Integer;
  end;

var
  frmUTF8Converter: TfrmUTF8Converter;

implementation

{$R *.dfm}

procedure TfrmUTF8Converter.AddLog(const Msg: string);
begin
  memLog.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ': ' + Msg);
  Application.ProcessMessages;
end;

procedure TfrmUTF8Converter.btnCloseClick(Sender: TObject);
begin
  Close;
end;

function TfrmUTF8Converter.ConvertFileToUTF8(const FileName: string): Boolean;
var
  FileContent: TStringList;
  Encoding: TEncoding;
  BackupFileName: string;
begin
  Result := False;

  if not FileExists(FileName) then
  begin
    AddLog('文件不存在：' + FileName);
    Exit;
  end;

  if IsUTF8File(FileName) then
  begin
    AddLog('文件已经是UTF-8编码：' + FileName);
    Result := True;
    Exit;
  end;

  try
    FileContent := TStringList.Create;
    try
      // 检测文件编码
      Encoding := DetectFileEncoding(FileName);

      // 读取文件内容
      FileContent.LoadFromFile(FileName, Encoding);

      // 创建备份
      BackupFileName := ChangeFileExt(FileName, '.bak');
      if FileExists(BackupFileName) then
        DeleteFile(BackupFileName);
      TFile.Copy(FileName, BackupFileName);

      // 以UTF-8编码保存文件
      FileContent.SaveToFile(FileName, TEncoding.UTF8);

      AddLog('成功转换文件为UTF-8编码：' + FileName);
      Result := True;
    finally
      FileContent.Free;
    end;
  except
    on E: Exception do
    begin
      AddLog('转换文件时出错：' + E.Message);
      Result := False;
    end;
  end;
end;

function TfrmUTF8Converter.ConvertFilesToUTF8(const FileNames: TArray<string>): Integer;
var
  FileName: string;
  SuccessCount: Integer;
begin
  SuccessCount := 0;

  for FileName in FileNames do
  begin
    if ConvertFileToUTF8(FileName) then
      Inc(SuccessCount);
  end;

  Result := SuccessCount;
  AddLog(Format('共处理 %d 个文件，成功转换 %d 个文件', [Length(FileNames), SuccessCount]));
end;

function TfrmUTF8Converter.ConvertDirectoryToUTF8(const Directory: string; const FileMask: string): Integer;
var
  Files: TArray<string>;
  Masks: TArray<string>;
  Mask: string;
  AllFiles: TArray<string>;
  i: Integer;
begin
  if not DirectoryExists(Directory) then
  begin
    AddLog('目录不存在：' + Directory);
    Result := 0;
    Exit;
  end;

  AllFiles := [];
  Masks := FileMask.Split([';']);

  for Mask in Masks do
  begin
    Files := TDirectory.GetFiles(Directory, Mask, TSearchOption.soAllDirectories);
    for i := 0 to Length(Files) - 1 do
    begin
      SetLength(AllFiles, Length(AllFiles) + 1);
      AllFiles[Length(AllFiles) - 1] := Files[i];
    end;
  end;

  Result := ConvertFilesToUTF8(AllFiles);
end;

function TfrmUTF8Converter.DetectFileEncoding(const FileName: string): TEncoding;
var
  Stream: TFileStream;
  Buffer: TBytes;
  Preamble: TBytes;
  Encodings: array of TEncoding;
  i: Integer;
begin
  Result := TEncoding.Default; // 默认使用ANSI编码

  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  try
    // 读取文件前几个字节用于检测BOM
    SetLength(Buffer, 4);
    Stream.ReadBuffer(Buffer[0], 4);

    // 检查是否有BOM标记
    Encodings := [TEncoding.UTF8, TEncoding.Unicode, TEncoding.BigEndianUnicode, TEncoding.UTF7];

    for i := 0 to High(Encodings) do
    begin
      Preamble := Encodings[i].GetPreamble;
      if (Length(Preamble) > 0) and (Length(Preamble) <= Length(Buffer)) then
      begin
        if CompareMem(@Preamble[0], @Buffer[0], Length(Preamble)) then
        begin
          Result := Encodings[i];
          Exit;
        end;
      end;
    end;

    // 如果没有BOM，尝试检测是否为UTF-8
    if IsUTF8File(FileName) then
      Result := TEncoding.UTF8;
  finally
    Stream.Free;
  end;
end;

class function TfrmUTF8Converter.Execute(const FileName: string): Boolean;
var
  Converter: TfrmUTF8Converter;
begin
  Result := False;

  Converter := TfrmUTF8Converter.Create(nil);
  try
    if FileName <> '' then
    begin
      if FileExists(FileName) then
        Result := Converter.ConvertFileToUTF8(FileName)
      else if DirectoryExists(FileName) then
        Result := Converter.ConvertDirectoryToUTF8(FileName) > 0;
    end;

    Converter.ShowModal;
  finally
    Converter.Free;
  end;
end;

class function TfrmUTF8Converter.ExecuteCommandLine(const Params: TArray<string>): Integer;
var
  Converter: TfrmUTF8Converter;
  i: Integer;
  Param: string;
  SuccessCount: Integer;
begin
  Result := 0;
  SuccessCount := 0;

  if Length(Params) = 0 then
  begin
    WriteLn('请指定要转换的文件或目录');
    Exit;
  end;

  Converter := TfrmUTF8Converter.Create(nil);
  try
    for i := 0 to High(Params) do
    begin
      Param := Params[i];
      
      if FileExists(Param) then
      begin
        if Converter.ConvertFileToUTF8(Param) then
          Inc(SuccessCount);
      end
      else if DirectoryExists(Param) then
      begin
        Inc(SuccessCount, Converter.ConvertDirectoryToUTF8(Param));
      end
      else
      begin
        WriteLn('目录不存在：' + Param);
      end;
    end;

    Result := SuccessCount;
  finally
    Converter.Free;
  end;
end;

function TfrmUTF8Converter.IsUTF8File(const FileName: string): Boolean;
var
  Stream: TFileStream;
  Buffer: TBytes;
  BytesRead: Integer;
  i: Integer;
  UTF8Preamble: TBytes;
begin
  Result := False;

  // 首先检查是否有UTF-8的BOM
  UTF8Preamble := TEncoding.UTF8.GetPreamble;
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  try
    SetLength(Buffer, Length(UTF8Preamble));
    BytesRead := Stream.Read(Buffer[0], Length(UTF8Preamble));

    if (BytesRead = Length(UTF8Preamble)) and
       CompareMem(@Buffer[0], @UTF8Preamble[0], Length(UTF8Preamble)) then
    begin
      Result := True;
      Exit;
    end;

    // 如果没有BOM，检查文件内容是否符合UTF-8编码规则
    Stream.Position := 0;
    SetLength(Buffer, 4096); // 读取4KB进行检查
    BytesRead := Stream.Read(Buffer[0], Length(Buffer));
    SetLength(Buffer, BytesRead);

    i := 0;
    while i < BytesRead do
    begin
      if Buffer[i] < $80 then
        Inc(i)
      else if Buffer[i] < $C0 then
        Exit // 非法UTF-8序列
      else if Buffer[i] < $E0 then
      begin
        if (i + 1 >= BytesRead) or
           ((Buffer[i + 1] and $C0) <> $80) then
          Exit;
        Inc(i, 2);
      end
      else if Buffer[i] < $F0 then
      begin
        if (i + 2 >= BytesRead) or
           ((Buffer[i + 1] and $C0) <> $80) or
           ((Buffer[i + 2] and $C0) <> $80) then
          Exit;
        Inc(i, 3);
      end
      else if Buffer[i] < $F5 then
      begin
        if (i + 3 >= BytesRead) or
           ((Buffer[i + 1] and $C0) <> $80) or
           ((Buffer[i + 2] and $C0) <> $80) or
           ((Buffer[i + 3] and $C0) <> $80) then
          Exit;
        Inc(i, 4);
      end
      else
        Exit; // 非法UTF-8序列
    end;

    Result := True; // 如果没有发现非法序列，则认为是UTF-8编码
  finally
    Stream.Free;
  end;
end;

end.
