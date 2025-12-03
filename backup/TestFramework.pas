unit TestFramework;

interface

uses
  System.SysUtils, System.Classes;

type
  { 绠€鍗曞垪琛ㄧ被 }
  TTestList = class
  private
    FItems: array of Pointer;
    FCount: Integer;
    FCapacity: Integer;
    function GetItem(Index: Integer): Pointer;
    procedure SetItem(Index: Integer; Value: Pointer);
  public
    constructor Create;
    destructor Destroy; override;
    
    function Add(Item: Pointer): Integer;
    procedure Clear;
    procedure Delete(Index: Integer);
    
    property Count: Integer read FCount;
    property Items[Index: Integer]: Pointer read GetItem write SetItem; default;
  end;

  { 娴嬭瘯鐢ㄤ緥鍩虹被 }
  TTestCase = class
  private
    FTestName: string;
    FErrorMessage: string;
    FSucceeded: Boolean;
  protected
    procedure SetUp; virtual;
    procedure TearDown; virtual;
  public
    constructor Create(const ATestName: string); virtual;
    destructor Destroy; override;
    
    procedure Run; virtual;
    
    // 妫€鏌ユ柟娉?    procedure Check(ACondition: Boolean; const AMessage: string = ''); virtual;
    procedure CheckEquals(AExpected, AActual: string; const AMessage: string = ''); overload;
    procedure CheckEquals(AExpected, AActual: Integer; const AMessage: string = ''); overload;
    procedure CheckEquals(AExpected, AActual: Double; Delta: Double; const AMessage: string = ''); overload;
    procedure CheckEquals(AExpected, AActual: Boolean; const AMessage: string = ''); overload;
    procedure CheckNotNull(AObject: TObject; const AMessage: string = '');
    procedure CheckTrue(ACondition: Boolean; const AMessage: string = '');
    procedure CheckFalse(ACondition: Boolean; const AMessage: string = '');
    
    property TestName: string read FTestName;
    property ErrorMessage: string read FErrorMessage;
    property Succeeded: Boolean read FSucceeded;
  end;
  
  TTestCaseClass = class of TTestCase;
  
  { 娴嬭瘯濂椾欢绫?}
  TTestSuite = class
  private
    FTests: TTestList;
    FName: string;
    FTestClass: TTestCaseClass;
  public
    constructor Create(const AName: string); virtual;
    constructor CreateWithClass(const AName: string; ATestClass: TTestCaseClass); virtual;
    destructor Destroy; override;
    
    procedure AddTest(ATest: TTestCase);
    procedure Run;
    
    property Name: string read FName;
    property TestClass: TTestCaseClass read FTestClass;
  end;
  
  { 娴嬭瘯鎶ュ憡绫?}
  TTestReport = class
  private
    FReportFile: TextFile;
    FFileName: string;
    FIsOpen: Boolean;
  public
    constructor Create(const AFileName: string);
    destructor Destroy; override;
    
    procedure Open;
    procedure Close;
    procedure WriteLine(const ALine: string);
    procedure WriteHeader(const AHeader: string);
    procedure WriteSeparator;
    procedure WriteSummary(PassCount, FailCount: Integer);
    
    property FileName: string read FFileName;
    property IsOpen: Boolean read FIsOpen;
  end;
  
{ 娉ㄥ唽娴嬭瘯鐢ㄤ緥 }
procedure RegisterTest(ASuite: TTestSuite);
procedure RegisterTestSuite(ATestCaseClass: TTestCaseClass; const ATestName: string = '');

{ 鏂囨湰娴嬭瘯杩愯鍣?}
function RunRegisteredTests: Integer; overload;
function RunRegisteredTests(const ReportFileName: string): Integer; overload;

{ 娴嬭瘯杈呭姪鍑芥暟 }
function Suite: TTestSuite;

var
  GRegisteredTests: TTestList;

implementation

{ TTestList }

constructor TTestList.Create;
begin
  inherited Create;
  FCount := 0;
  FCapacity := 0;
  SetLength(FItems, 0);
end;

destructor TTestList.Destroy;
begin
  Clear;
  SetLength(FItems, 0);
  inherited;
end;

function TTestList.Add(Item: Pointer): Integer;
begin
  // 鎵╁睍瀹归噺
  if FCount = FCapacity then
  begin
    if FCapacity = 0 then
      FCapacity := 4
    else
      FCapacity := FCapacity * 2;
    SetLength(FItems, FCapacity);
  end;
  
  // 娣诲姞椤圭洰
  FItems[FCount] := Item;
  Result := FCount;
  Inc(FCount);
end;

procedure TTestList.Clear;
begin
  FCount := 0;
end;

procedure TTestList.Delete(Index: Integer);
var
  I: Integer;
begin
  if (Index < 0) or (Index >= FCount) then
    Exit;
    
  // 绉诲姩椤圭洰
  for I := Index to FCount - 2 do
    FItems[I] := FItems[I + 1];
    
  // 鍑忓皯璁℃暟
  Dec(FCount);
end;

function TTestList.GetItem(Index: Integer): Pointer;
begin
  if (Index < 0) or (Index >= FCount) then
    Result := nil
  else
    Result := FItems[Index];
end;

procedure TTestList.SetItem(Index: Integer; Value: Pointer);
begin
  if (Index >= 0) and (Index < FCount) then
    FItems[Index] := Value;
end;

{ TTestCase }

constructor TTestCase.Create(const ATestName: string);
begin
  inherited Create;
  FTestName := ATestName;
  FSucceeded := True;
end;

destructor TTestCase.Destroy;
begin
  inherited;
end;

procedure TTestCase.SetUp;
begin
  // 鍙瀛愮被閲嶅啓
end;

procedure TTestCase.TearDown;
begin
  // 鍙瀛愮被閲嶅啓
end;

procedure TTestCase.Run;
begin
  try
    SetUp;
    try
      // 鍏蜂綋娴嬭瘯鏂规硶鍦ㄥ瓙绫讳腑瀹炵幇
    finally
      TearDown;
    end;
  except
    on E: Exception do
    begin
      FSucceeded := False;
      FErrorMessage := '寮傚父: ' + E.Message;
    end;
  end;
end;

procedure TTestCase.Check(ACondition: Boolean; const AMessage: string);
begin
  if not ACondition then
  begin
    FSucceeded := False;
    if AMessage <> '' then
      FErrorMessage := AMessage
    else
      FErrorMessage := '妫€鏌ュけ璐?;
    
    WriteLn('  妫€鏌ュけ璐? ', FErrorMessage);
  end;
end;

procedure TTestCase.CheckEquals(AExpected, AActual: string; const AMessage: string);
begin
  if AExpected <> AActual then
  begin
    FSucceeded := False;
    FErrorMessage := '瀛楃涓蹭笉鍖归厤 - 棰勬湡: "' + AExpected + '", 瀹為檯: "' + AActual + '"';
    if AMessage <> '' then
      FErrorMessage := FErrorMessage + ' - ' + AMessage;
    
    WriteLn('  妫€鏌ュけ璐? ', FErrorMessage);
  end;
end;

procedure TTestCase.CheckEquals(AExpected, AActual: Integer; const AMessage: string);
begin
  if AExpected <> AActual then
  begin
    FSucceeded := False;
    FErrorMessage := '鏁存暟涓嶅尮閰?- 棰勬湡: ' + IntToStr(AExpected) + ', 瀹為檯: ' + IntToStr(AActual);
    if AMessage <> '' then
      FErrorMessage := FErrorMessage + ' - ' + AMessage;
    
    WriteLn('  妫€鏌ュけ璐? ', FErrorMessage);
  end;
end;

procedure TTestCase.CheckEquals(AExpected, AActual: Double; Delta: Double; const AMessage: string);
begin
  if (AActual < AExpected - Delta) or (AActual > AExpected + Delta) then
  begin
    FSucceeded := False;
    FErrorMessage := '娴偣鏁颁笉鍖归厤 - 棰勬湡: ' + FloatToStr(AExpected) + ', 瀹為檯: ' + FloatToStr(AActual);
    if AMessage <> '' then
      FErrorMessage := FErrorMessage + ' - ' + AMessage;
    
    WriteLn('  妫€鏌ュけ璐? ', FErrorMessage);
  end;
end;

procedure TTestCase.CheckEquals(AExpected, AActual: Boolean; const AMessage: string);
begin
  if AExpected <> AActual then
  begin
    FSucceeded := False;
    FErrorMessage := '甯冨皵鍊间笉鍖归厤 - 棰勬湡: ' + BoolToStr(AExpected, True) + ', 瀹為檯: ' + BoolToStr(AActual, True);
    if AMessage <> '' then
      FErrorMessage := FErrorMessage + ' - ' + AMessage;
    
    WriteLn('  妫€鏌ュけ璐? ', FErrorMessage);
  end;
end;

procedure TTestCase.CheckNotNull(AObject: TObject; const AMessage: string);
begin
  if AObject = nil then
  begin
    FSucceeded := False;
    if AMessage <> '' then
      FErrorMessage := AMessage
    else
      FErrorMessage := '瀵硅薄涓簄il';
    
    WriteLn('  妫€鏌ュけ璐? ', FErrorMessage);
  end;
end;

procedure TTestCase.CheckTrue(ACondition: Boolean; const AMessage: string);
begin
  Check(ACondition, AMessage);
end;

procedure TTestCase.CheckFalse(ACondition: Boolean; const AMessage: string);
begin
  Check(not ACondition, AMessage);
end;

{ TTestSuite }

constructor TTestSuite.Create(const AName: string);
begin
  inherited Create;
  FName := AName;
  FTests := TTestList.Create;
  FTestClass := nil;
end;

constructor TTestSuite.CreateWithClass(const AName: string; ATestClass: TTestCaseClass);
begin
  Create(AName);
  FTestClass := ATestClass;
end;

destructor TTestSuite.Destroy;
begin
  if Assigned(FTests) then
  begin
    FTests.Free;
    FTests := nil;
  end;
  inherited;
end;

procedure TTestSuite.AddTest(ATest: TTestCase);
begin
  FTests.Add(ATest);
end;

procedure TTestSuite.Run;
var
  I: Integer;
  TestCase: TTestCase;
begin
  if FTests = nil then
    Exit;
  
  WriteLn('杩愯娴嬭瘯濂椾欢: ', FName);
  
  for I := 0 to FTests.Count - 1 do
  begin
    TestCase := TTestCase(FTests[I]);
    if TestCase <> nil then
    begin
      WriteLn('杩愯娴嬭瘯: ', TestCase.TestName);
      TestCase.Run;
      
      if TestCase.Succeeded then
        WriteLn('  娴嬭瘯閫氳繃')
      else
        WriteLn('  娴嬭瘯澶辫触: ', TestCase.ErrorMessage);
    end;
  end;
end;

{ TTestReport }

constructor TTestReport.Create(const AFileName: string);
begin
  inherited Create;
  FFileName := AFileName;
  FIsOpen := False;
end;

destructor TTestReport.Destroy;
begin
  if FIsOpen then
    Close;
  inherited;
end;

procedure TTestReport.Open;
begin
  if not FIsOpen then
  begin
    AssignFile(FReportFile, FFileName);
    Rewrite(FReportFile);
    FIsOpen := True;
  end;
end;

procedure TTestReport.Close;
begin
  if FIsOpen then
  begin
    CloseFile(FReportFile);
    FIsOpen := False;
  end;
end;

procedure TTestReport.WriteLine(const ALine: string);
begin
  if FIsOpen then
    WriteLn(FReportFile, ALine);
end;

procedure TTestReport.WriteHeader(const AHeader: string);
begin
  if FIsOpen then
  begin
    WriteLine('');
    WriteLine('============================================');
    WriteLine('  ' + AHeader);
    WriteLine('============================================');
    WriteLine('');
  end;
end;

procedure TTestReport.WriteSeparator;
begin
  if FIsOpen then
    WriteLine('--------------------------------------------');
end;

procedure TTestReport.WriteSummary(PassCount, FailCount: Integer);
begin
  if FIsOpen then
  begin
    WriteLine('');
    WriteLine('============================================');
    WriteLine('  娴嬭瘯鎵ц姹囨€?);
    WriteLine('============================================');
    WriteLine('  閫氳繃鏁伴噺: ' + IntToStr(PassCount));
    WriteLine('  澶辫触鏁伴噺: ' + IntToStr(FailCount));
    WriteLine('  鎬昏: ' + IntToStr(PassCount + FailCount));
    WriteLine('============================================');
  end;
end;

{ 鍏ㄥ眬鍑芥暟 }

procedure RegisterTest(ASuite: TTestSuite);
begin
  if GRegisteredTests = nil then
    GRegisteredTests := TTestList.Create;
  GRegisteredTests.Add(ASuite);
end;

procedure RegisterTestSuite(ATestCaseClass: TTestCaseClass; const ATestName: string);
var
  Suite: TTestSuite;
  TestName: string;
begin
  if ATestName = '' then
    TestName := '娴嬭瘯濂椾欢'
  else
    TestName := ATestName;
    
  Suite := TTestSuite.CreateWithClass(TestName, ATestCaseClass);
  RegisterTest(Suite);
end;

function RunRegisteredTests: Integer;
begin
  Result := RunRegisteredTests('');
end;

function RunRegisteredTests(const ReportFileName: string): Integer;
var
  I, J: Integer;
  Suite: TTestSuite;
  Test: TTestCase;
  PassCount, FailCount: Integer;
  Report: TTestReport;
  UseReport: Boolean;
  TestClass: TTestCaseClass;
begin
  PassCount := 0;
  FailCount := 0;
  
  UseReport := ReportFileName <> '';
  Report := nil;
  
  try
    if UseReport then
    begin
      Report := TTestReport.Create(ReportFileName);
      Report.Open;
      Report.WriteHeader('閰嶇疆绠＄悊绯荤粺娴嬭瘯鎶ュ憡');
    end;
    
    if GRegisteredTests <> nil then
    begin
      for I := 0 to GRegisteredTests.Count - 1 do
      begin
        Suite := TTestSuite(GRegisteredTests[I]);
        if Suite <> nil then
        begin
          WriteLn('娴嬭瘯濂椾欢姝ｅ湪杩愯: ', Suite.Name);
          if UseReport then
          begin
            Report.WriteHeader('娴嬭瘯濂椾欢: ' + Suite.Name);
          end;
          
          // 濡傛灉濂椾欢涓病鏈夋祴璇曚絾鏈塗estClass锛屽垯鍒涘缓涓€涓疄渚?          if (Suite.FTests.Count = 0) and (Suite.TestClass <> nil) then
          begin
            TestClass := Suite.TestClass;
            Test := TestClass.Create(Suite.Name);
            Suite.AddTest(Test);
          end;
          
          Suite.Run;
          
          // 璁＄畻閫氳繃鍜屽け璐ユ暟閲?          for J := 0 to Suite.FTests.Count - 1 do
          begin
            Test := TTestCase(Suite.FTests[J]);
            if Test <> nil then
            begin
              if UseReport then
              begin
                if Test.Succeeded then
                begin
                  Report.WriteLine('娴嬭瘯 "' + Test.TestName + '" 閫氳繃');
                  Inc(PassCount);
                end
                else
                begin
                  Report.WriteLine('娴嬭瘯 "' + Test.TestName + '" 澶辫触: ' + Test.ErrorMessage);
                  Inc(FailCount);
                end;
              end
              else
              begin
                if Test.Succeeded then
                  Inc(PassCount)
                else
                  Inc(FailCount);
              end;
            end;
          end;
          
          if UseReport then
            Report.WriteSeparator;
        end;
      end;
    end
    else
    begin
      WriteLn('娌℃湁鎵惧埌娉ㄥ唽鐨勬祴璇?);
      if UseReport then
        Report.WriteLine('娌℃湁鎵惧埌娉ㄥ唽鐨勬祴璇?);
    end;
    
    WriteLn('');
    WriteLn('娴嬭瘯鎵ц瀹屾垚锛岄€氳繃: ', IntToStr(PassCount), '锛屽け璐? ', IntToStr(FailCount));
    
    if UseReport then
      Report.WriteSummary(PassCount, FailCount);
    
    Result := FailCount;
  finally
    if UseReport and Assigned(Report) then
    begin
      Report.Close;
      Report.Free;
    end;
  end;
end;

function Suite: TTestSuite;
begin
  Result := TTestSuite.Create('DefaultTestSuite');
end;

initialization
  GRegisteredTests := nil;

finalization
  if GRegisteredTests <> nil then
  begin
    GRegisteredTests.Free;
    GRegisteredTests := nil;
  end;
end. 