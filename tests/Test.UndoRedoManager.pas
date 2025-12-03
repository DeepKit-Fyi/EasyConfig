unit Test.UndoRedoManager;

{*******************************************************************************
  UndoRedoManager 属性测试
  
  Property 6: 撤销/重做栈一致性
  *For any* 配置修改操作序列，执行 N 次修改后执行 N 次撤销应恢复到初始状态；
  执行撤销后执行重做应恢复到撤销前的状态；执行新修改后重做栈应为空。
  
  **Validates: Requirements 7.1, 7.2, 7.3, 7.4**
*******************************************************************************}

interface

uses
  System.SysUtils, System.JSON,
  DUnitX.TestFramework,
  UndoRedoManager;

type
  // 用于测试的值持有者
  TValueHolder = class
  public
    Value: string;
  end;

  [TestFixture]
  TUndoRedoManagerTests = class
  private
    FManager: TUndoRedoManager;
    FValueHolder: TValueHolder;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    
    // ========== Property 6: 撤销/重做栈一致性测试 ==========
    
    [Test]
    procedure Test_ExecuteCommand_AddsToUndoStack;
    
    [Test]
    procedure Test_Undo_RestoresPreviousState;
    
    [Test]
    procedure Test_Redo_RestoresUndoneState;
    
    [Test]
    procedure Test_NewCommand_ClearsRedoStack;
    
    [Test]
    procedure Test_MultipleUndos_RestoreInitialState;
    
    [Test]
    procedure Test_UndoRedo_RoundTrip;
    
    // ========== 边界情况测试 ==========
    
    [Test]
    procedure Test_CanUndo_EmptyStack_ReturnsFalse;
    
    [Test]
    procedure Test_CanRedo_EmptyStack_ReturnsFalse;
    
    [Test]
    procedure Test_Undo_EmptyStack_DoesNothing;
    
    [Test]
    procedure Test_Redo_EmptyStack_DoesNothing;
    
    [Test]
    procedure Test_MaxUndoLevels_TrimsOldCommands;
  end;

implementation

{ TUndoRedoManagerTests }

procedure TUndoRedoManagerTests.Setup;
begin
  FManager := TUndoRedoManager.Create(100);
  FValueHolder := TValueHolder.Create;
  FValueHolder.Value := 'initial';
end;

procedure TUndoRedoManagerTests.TearDown;
begin
  FManager.Free;
  FValueHolder.Free;
end;

// ========== Property 6: 撤销/重做栈一致性测试 ==========

procedure TUndoRedoManagerTests.Test_ExecuteCommand_AddsToUndoStack;
var
  Cmd: TSetINIValueCommand;
  Holder: TValueHolder;
begin
  Holder := FValueHolder;
  Cmd := TSetINIValueCommand.Create('section', 'key', 'old', 'new',
    procedure(S, K, V: string) begin Holder.Value := V; end);
  
  FManager.ExecuteCommand(Cmd);
  
  Assert.AreEqual(1, FManager.GetUndoCount, 'Undo stack should have one command');
  Assert.IsTrue(FManager.CanUndo, 'Should be able to undo');
end;


procedure TUndoRedoManagerTests.Test_Undo_RestoresPreviousState;
var
  Cmd: TSetINIValueCommand;
  Holder: TValueHolder;
begin
  Holder := FValueHolder;
  Holder.Value := 'old';
  Cmd := TSetINIValueCommand.Create('section', 'key', 'old', 'new',
    procedure(S, K, V: string) begin Holder.Value := V; end);
  FManager.ExecuteCommand(Cmd);
  Assert.AreEqual('new', Holder.Value, 'Value should be new after execute');
  
  FManager.Undo;
  
  Assert.AreEqual('old', Holder.Value, 'Value should be restored to old');
  Assert.AreEqual(0, FManager.GetUndoCount, 'Undo stack should be empty');
  Assert.AreEqual(1, FManager.GetRedoCount, 'Redo stack should have one command');
end;

procedure TUndoRedoManagerTests.Test_Redo_RestoresUndoneState;
var
  Cmd: TSetINIValueCommand;
  Holder: TValueHolder;
begin
  Holder := FValueHolder;
  Holder.Value := 'old';
  Cmd := TSetINIValueCommand.Create('section', 'key', 'old', 'new',
    procedure(S, K, V: string) begin Holder.Value := V; end);
  FManager.ExecuteCommand(Cmd);
  FManager.Undo;
  Assert.AreEqual('old', Holder.Value);
  
  FManager.Redo;
  
  Assert.AreEqual('new', Holder.Value, 'Value should be restored to new');
  Assert.AreEqual(1, FManager.GetUndoCount, 'Undo stack should have one command');
  Assert.AreEqual(0, FManager.GetRedoCount, 'Redo stack should be empty');
end;

procedure TUndoRedoManagerTests.Test_NewCommand_ClearsRedoStack;
var
  Cmd1, Cmd2: TSetINIValueCommand;
  Holder: TValueHolder;
begin
  Holder := FValueHolder;
  Holder.Value := 'v1';
  Cmd1 := TSetINIValueCommand.Create('section', 'key', 'v1', 'v2',
    procedure(S, K, V: string) begin Holder.Value := V; end);
  FManager.ExecuteCommand(Cmd1);
  FManager.Undo;
  Assert.AreEqual(1, FManager.GetRedoCount, 'Redo stack should have one command');
  
  Cmd2 := TSetINIValueCommand.Create('section', 'key', 'v1', 'v3',
    procedure(S, K, V: string) begin Holder.Value := V; end);
  FManager.ExecuteCommand(Cmd2);
  
  Assert.AreEqual(0, FManager.GetRedoCount, 'Redo stack should be cleared');
  Assert.AreEqual('v3', Holder.Value);
end;

procedure TUndoRedoManagerTests.Test_MultipleUndos_RestoreInitialState;
var
  I: Integer;
  Holder: TValueHolder;
begin
  Holder := FValueHolder;
  Holder.Value := 'v0';
  for I := 1 to 5 do
  begin
    FManager.ExecuteCommand(
      TSetINIValueCommand.Create('section', 'key', 
        'v' + IntToStr(I-1), 'v' + IntToStr(I),
        procedure(S, K, V: string) begin Holder.Value := V; end));
  end;
  Assert.AreEqual('v5', Holder.Value);
  
  for I := 1 to 5 do
    FManager.Undo;
  
  Assert.AreEqual('v0', Holder.Value, 'Should restore to initial state');
  Assert.AreEqual(0, FManager.GetUndoCount, 'Undo stack should be empty');
  Assert.AreEqual(5, FManager.GetRedoCount, 'Redo stack should have 5 commands');
end;

procedure TUndoRedoManagerTests.Test_UndoRedo_RoundTrip;
var
  Cmd: TSetINIValueCommand;
  Holder: TValueHolder;
begin
  Holder := FValueHolder;
  Holder.Value := 'original';
  Cmd := TSetINIValueCommand.Create('section', 'key', 'original', 'modified',
    procedure(S, K, V: string) begin Holder.Value := V; end);
  FManager.ExecuteCommand(Cmd);
  
  FManager.Undo;
  Assert.AreEqual('original', Holder.Value);
  
  FManager.Redo;
  Assert.AreEqual('modified', Holder.Value);
  
  FManager.Undo;
  Assert.AreEqual('original', Holder.Value);
  
  FManager.Redo;
  Assert.AreEqual('modified', Holder.Value);
end;

// ========== 边界情况测试 ==========

procedure TUndoRedoManagerTests.Test_CanUndo_EmptyStack_ReturnsFalse;
begin
  Assert.IsFalse(FManager.CanUndo, 'Empty stack should not allow undo');
end;

procedure TUndoRedoManagerTests.Test_CanRedo_EmptyStack_ReturnsFalse;
begin
  Assert.IsFalse(FManager.CanRedo, 'Empty stack should not allow redo');
end;

procedure TUndoRedoManagerTests.Test_Undo_EmptyStack_DoesNothing;
begin
  FValueHolder.Value := 'test';
  FManager.Undo;
  Assert.AreEqual('test', FValueHolder.Value, 'Value should not change');
end;

procedure TUndoRedoManagerTests.Test_Redo_EmptyStack_DoesNothing;
begin
  FValueHolder.Value := 'test';
  FManager.Redo;
  Assert.AreEqual('test', FValueHolder.Value, 'Value should not change');
end;

procedure TUndoRedoManagerTests.Test_MaxUndoLevels_TrimsOldCommands;
var
  I: Integer;
  Holder: TValueHolder;
begin
  FManager.MaxUndoLevels := 5;
  Holder := FValueHolder;
  Holder.Value := 'v0';
  
  for I := 1 to 10 do
  begin
    FManager.ExecuteCommand(
      TSetINIValueCommand.Create('section', 'key', 
        'v' + IntToStr(I-1), 'v' + IntToStr(I),
        procedure(S, K, V: string) begin Holder.Value := V; end));
  end;
  
  Assert.AreEqual(5, FManager.GetUndoCount, 'Undo stack should be trimmed to 5');
end;

initialization
  TDUnitX.RegisterTestFixture(TUndoRedoManagerTests);

end.
