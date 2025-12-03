program GUITestRunner;

{$APPTYPE GUI}

uses
  System.SysUtils, System.Classes, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Dialogs, Vcl.Graphics,
  TestFramework in 'TestFramework.pas';

type
  // 测试注册表类 - 实现单例模式
  TTestRegistry = class
  private
    FTestList: TTestList;
  public
    constructor Create;
    destructor Destroy; override;
    
    procedure RegisterTest(ATest: TTestCase);
    procedure RegisterSuite(ASuite: TTestSuite);
    
    class function Instance: TTestRegistry;
    property Tests: TTestList read FTestList;
  end;

  TMainForm = class(TForm)
  private
    FTreeView: TTreeView;
    FMemo: TMemo;
    FStatusBar: TStatusBar;
    FPanel: TPanel;
    FRunButton: TButton;
    FSaveReportButton: TButton;
    FReportFileName: string;
    FTestPassed: Integer;
    FTestFailed: Integer;
    
    procedure InitializeComponents;
    procedure LoadTestsIntoTree;
    procedure RunSelectedTest(Sender: TObject);
    procedure SaveReport(Sender: TObject);
    procedure UpdateStatusBar;
    
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  // 单例实例
  GlobalTestRegistry: TTestRegistry = nil;

{ TTestRegistry }

constructor TTestRegistry.Create;
begin
  inherited Create;
  FTestList := TTestList.Create;
end;

destructor TTestRegistry.Destroy;
begin
  FTestList.Free;
  inherited;
end;

procedure TTestRegistry.RegisterTest(ATest: TTestCase);
begin
  FTestList.Add(ATest);
end;

procedure TTestRegistry.RegisterSuite(ASuite: TTestSuite);
begin
  FTestList.Add(ASuite);
end;

class function TTestRegistry.Instance: TTestRegistry;
begin
  if GlobalTestRegistry = nil then
    GlobalTestRegistry := TTestRegistry.Create;
  Result := GlobalTestRegistry;
end;

{ TMainForm }

constructor TMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  InitializeComponents;
  LoadTestsIntoTree;
  
  FReportFileName := 'GUITestReport.txt';
  FTestPassed := 0;
  FTestFailed := 0;
  
  UpdateStatusBar;
end;

destructor TMainForm.Destroy;
begin
  inherited;
end;

procedure TMainForm.InitializeComponents;
begin
  // 设置窗体属性
  Caption := '配置管理系统 - GUI测试运行器';
  Width := 800;
  Height := 600;
  Position := poScreenCenter;
  
  // 创建面板
  FPanel := TPanel.Create(Self);
  FPanel.Parent := Self;
  FPanel.Align := alTop;
  FPanel.Height := 40;
  
  // 创建树状视图
  FTreeView := TTreeView.Create(Self);
  FTreeView.Parent := Self;
  FTreeView.Align := alLeft;
  FTreeView.Width := 250;
  
  // 创建文本框
  FMemo := TMemo.Create(Self);
  FMemo.Parent := Self;
  FMemo.Align := alClient;
  FMemo.ScrollBars := ssVertical;
  FMemo.ReadOnly := True;
  
  // 创建状态栏
  FStatusBar := TStatusBar.Create(Self);
  FStatusBar.Parent := Self;
  FStatusBar.SimplePanel := True;
  
  // 创建运行按钮
  FRunButton := TButton.Create(Self);
  FRunButton.Parent := FPanel;
  FRunButton.Caption := '运行所选测试';
  FRunButton.Left := 10;
  FRunButton.Top := 8;
  FRunButton.Width := 120;
  FRunButton.OnClick := RunSelectedTest;
  
  // 创建保存报告按钮
  FSaveReportButton := TButton.Create(Self);
  FSaveReportButton.Parent := FPanel;
  FSaveReportButton.Caption := '保存测试报告';
  FSaveReportButton.Left := 140;
  FSaveReportButton.Top := 8;
  FSaveReportButton.Width := 120;
  FSaveReportButton.OnClick := SaveReport;
end;

procedure TMainForm.LoadTestsIntoTree;
var
  RootNode, SuiteNode: TTreeNode;
  I: Integer;
  TestItem: TObject;
begin
  FTreeView.Items.Clear;
  
  RootNode := FTreeView.Items.AddChild(nil, '所有测试');
  
  // 添加已注册的测试
  for I := 0 to TTestRegistry.Instance.Tests.Count - 1 do
  begin
    TestItem := TObject(TTestRegistry.Instance.Tests[I]);
    
    if TestItem is TTestSuite then
    begin
      SuiteNode := FTreeView.Items.AddChild(RootNode, TTestSuite(TestItem).Name);
      SuiteNode.Data := TestItem;
    end
    else if TestItem is TTestCase then
    begin
      SuiteNode := FTreeView.Items.AddChild(RootNode, TTestCase(TestItem).TestName);
      SuiteNode.Data := TestItem;
    end;
  end;
  
  FTreeView.FullExpand;
end;

procedure TMainForm.RunSelectedTest(Sender: TObject);
var
  SelectedNode: TTreeNode;
  SelectedTest: TObject;
begin
  SelectedNode := FTreeView.Selected;
  
  if SelectedNode = nil then
  begin
    ShowMessage('请选择要运行的测试');
    Exit;
  end;
  
  if SelectedNode.Data = nil then
  begin
    // 根节点选择，运行所有测试
    FMemo.Clear;
    FMemo.Lines.Add('运行所有测试...');
    FMemo.Lines.Add('');
    
    FTestPassed := 0;
    FTestFailed := 0;
    
    // 运行所有测试并记录结果
    FMemo.Lines.Add('测试结果将保存到: ' + FReportFileName);
    FMemo.Lines.Add('');
    FTestFailed := RunRegisteredTests(FReportFileName);
    
    UpdateStatusBar;
  end
  else
  begin
    SelectedTest := TObject(SelectedNode.Data);
    
    FMemo.Clear;
    FMemo.Lines.Add('运行选中的测试...');
    FMemo.Lines.Add('');
    
    FTestPassed := 0;
    FTestFailed := 0;
    
    if SelectedTest is TTestSuite then
    begin
      // 运行测试套件
      FMemo.Lines.Add('运行测试套件: ' + TTestSuite(SelectedTest).Name);
      TTestSuite(SelectedTest).Run;
    end
    else if SelectedTest is TTestCase then
    begin
      // 运行单个测试
      FMemo.Lines.Add('运行测试: ' + TTestCase(SelectedTest).TestName);
      TTestCase(SelectedTest).Run;
      
      if TTestCase(SelectedTest).Succeeded then
      begin
        Inc(FTestPassed);
        FMemo.Lines.Add('测试通过');
      end
      else
      begin
        Inc(FTestFailed);
        FMemo.Lines.Add('测试失败: ' + TTestCase(SelectedTest).ErrorMessage);
      end;
    end;
    
    UpdateStatusBar;
  end;
end;

procedure TMainForm.SaveReport(Sender: TObject);
var
  SaveDialog: TSaveDialog;
  Report: TTestReport;
begin
  SaveDialog := TSaveDialog.Create(Self);
  try
    SaveDialog.Filter := '文本文件|*.txt';
    SaveDialog.DefaultExt := 'txt';
    SaveDialog.FileName := FReportFileName;
    
    if SaveDialog.Execute then
    begin
      FReportFileName := SaveDialog.FileName;
      Report := TTestReport.Create(FReportFileName);
      try
        Report.Open;
        Report.WriteHeader('GUI测试运行器报告');
        Report.WriteLine('');
        Report.WriteLine('测试执行时间: ' + DateTimeToStr(Now));
        Report.WriteLine('');
        Report.WriteLine(FMemo.Text);
        Report.WriteSummary(FTestPassed, FTestFailed);
        Report.Close;
        
        ShowMessage('测试报告已保存到: ' + FReportFileName);
      finally
        Report.Free;
      end;
    end;
  finally
    SaveDialog.Free;
  end;
end;

procedure TMainForm.UpdateStatusBar;
begin
  FStatusBar.SimpleText := Format('测试统计: 通过: %d  失败: %d  总计: %d', 
                                 [FTestPassed, FTestFailed, FTestPassed + FTestFailed]);
end;

var
  MainForm: TMainForm;

// 示例测试类
type
  TSimpleTest = class(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
    procedure TestPassed;
    procedure TestFailed;
    procedure Run; override;
  end;

{ TSimpleTest }

procedure TSimpleTest.SetUp;
begin
  // 简单设置
end;

procedure TSimpleTest.TearDown;
begin
  // 简单清理
end;

procedure TSimpleTest.TestPassed;
begin
  Check(True, '这个测试应该通过');
end;

procedure TSimpleTest.TestFailed;
begin
  Check(False, '这个测试应该失败');
end;

procedure TSimpleTest.Run;
begin
  SetUp;
  try
    WriteLn('执行测试: ', TestName);
    TestPassed;
    TestFailed;
  finally
    TearDown;
  end;
end;

begin
  Application.Initialize;
  
  // 注册测试
  TTestRegistry.Instance.RegisterTest(TSimpleTest.Create('简单测试'));
  
  // 创建并显示主窗体
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end. 