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
    AddLog('文件不存在: ' + FileName);
    Exit;
  end;

  if IsUTF8File(FileName) then
  begin
    AddLog('文件已经是UTF-8编码: ' + FileName);
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

      AddLog('成功转换文件为UTF-8编码: ' + FileName);
      Result := True;
    finally
      FileContent.Free;
    end;
  except
    on E: Exception do
    begin
      AddLog('转换文件时出错: ' + E.Message);
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
    AddLog('目录不存在: ' + Directory);
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

procedure TfrmUTF8Converter.FormCreate(Sender: TObject);
begin
  memLog.Clear;
  AddLog('UTF-8转换工具已启动');
end;

function TfrmUTF8Converter.IsUTF8File(const FileName: string): Boolean;
var
  Stream: TFileStream;
  Buffer: TBytes;
  Preamble: TBytes;
  i, Count: Integer;
  c, c2, c3, c4: Byte;
begin
  Result := False;

  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  try
    // 首先检查BOM
    Preamble := TEncoding.UTF8.GetPreamble;
    if (Preamble <> nil) and (Length(Preamble) > 0) and (Stream.Size >= Length(Preamble)) then
    begin
      SetLength(Buffer, Length(Preamble));
      Stream.ReadBuffer(Buffer[0], Length(Preamble));

      if CompareMem(@Preamble[0], @Buffer[0], Length(Preamble)) then
      begin
        Result := True;
        Exit;
      end;
    end;

    // 如果没有BOM，尝试通过内容检测
    Stream.Position := 0;
    Count := Min(Stream.Size, 4096); // 只检查前4KB
    SetLength(Buffer, Count);
    Stream.ReadBuffer(Buffer[0], Count);

    i := 0;
    while i < Count do
    begin
      c := Buffer[i];

      // ASCII字符
      if c < $80 then
      begin
        Inc(i);
        Continue;
      end;

      // 检查UTF-8多字节序列
      if (c >= $C2) and (c <= $DF) and (i + 1 < Count) then
      begin
        c2 := Buffer[i + 1];
        if (c2 >= $80) and (c2 <= $BF) then
        begin
          Inc(i, 2);
          Result := True;
          Continue;
        end;
      end
      else if (c >= $E0) and (c <= $EF) and (i + 2 < Count) then
      begin
        c2 := Buffer[i + 1];
        c3 := Buffer[i + 2];
        if (c2 >= $80) and (c2 <= $BF) and (c3 >= $80) and (c3 <= $BF) then
        begin
          Inc(i, 3);
          Result := True;
          Continue;
        end;
      end
      else if (c >= $F0) and (c <= $F4) and (i + 3 < Count) then
      begin
        c2 := Buffer[i + 1];
        c3 := Buffer[i + 2];
        c4 := Buffer[i + 3];
        if (c2 >= $80) and (c2 <= $BF) and (c3 >= $80) and (c3 <= $BF) and (c4 >= $80) and (c4 <= $BF) then
        begin
          Inc(i, 4);
          Result := True;
          Continue;
        end;
      end;

      // 如果到这里，说明不是有效的UTF-8序列
      Inc(i);
    end;
  finally
    Stream.Free;
  end;
end;

class function TfrmUTF8Converter.ExecuteCommandLine(const Params: TArray<string>): Integer;
var
  Converter: TfrmUTF8Converter;
  i: Integer;
  Param: string;
  Files: TArray<string>;
  Directories: TArray<string>;
  SuccessCount: Integer;
begin
  Result := 0;

  if Length(Params) = 0 then
  begin
    WriteLn('用法: UTF8Converter [文件路径...] [-d 目录路径...]');
    WriteLn('  -d: 指定要处理的目录');
    Exit;
  end;

  Converter := TfrmUTF8Converter.Create(nil);
  try
    Files := [];
    Directories := [];

    i := 0;
    while i < Length(Params) do
    begin
      Param := Params[i];

      if Param = '-d' then
      begin
        Inc(i);
        if i < Length(Params) then
        begin
          SetLength(Directories, Length(Directories) + 1);
          Directories[High(Directories)] := Params[i];
        end;
      end
      else
      begin
        SetLength(Files, Length(Files) + 1);
        Files[High(Files)] := Param;
      end;

      Inc(i);
    end;

    // 处理文件
    if Length(Files) > 0 then
    begin
      WriteLn('处理指定文件...');
      SuccessCount := Converter.ConvertFilesToUTF8(Files);
      WriteLn(Format('共处理 %d 个文件，成功转换 %d 个文件', [Length(Files), SuccessCount]));
      Result := Result + SuccessCount;
    end;

    // 处理目录
    for Param in Directories do
    begin
      if DirectoryExists(Param) then
      begin
        WriteLn('处理目录: ' + Param);
        SuccessCount := Converter.ConvertDirectoryToUTF8(Param);
        WriteLn(Format('目录转换完成，共成功转换 %d 个文件', [SuccessCount]));
        Result := Result + SuccessCount;
      end
      else
      begin
        WriteLn('目录不存在: ' + Param);
      end;
    end;
  finally
    Converter.Free;
  end;
end;

end.
