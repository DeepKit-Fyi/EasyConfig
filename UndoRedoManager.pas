unit UndoRedoManager;

{*******************************************************************************
  撤销/重做管理器
  
  实现 Command 模式，统一管理配置修改操作的撤销和重做。
  
  Property 6: 撤销/重做栈一致性
  *For any* 配置修改操作序列，执行 N 次修改后执行 N 次撤销应恢复到初始状态；
  执行撤销后执行重做应恢复到撤销前的状态；执行新修改后重做栈应为空。
  
  **Validates: Requirements 7.1, 7.2, 7.3, 7.4**
*******************************************************************************}

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Generics.Collections;

type
  /// <summary>
  /// 配置命令基类 - 所有配置修改操作的抽象
  /// </summary>
  TConfigCommand = class
  protected
    FDescription: string;
    FTimestamp: TDateTime;
  public
    constructor Create(const ADescription: string);
    
    /// <summary>执行命令</summary>
    procedure Execute; virtual; abstract;
    /// <summary>撤销命令</summary>
    procedure Undo; virtual; abstract;
    /// <summary>获取命令描述</summary>
    function GetDescription: string; virtual;
    
    property Description: string read FDescription;
    property Timestamp: TDateTime read FTimestamp;
  end;
  
  /// <summary>
  /// 设置 INI 值命令
  /// </summary>
  TSetINIValueCommand = class(TConfigCommand)
  private
    FSection: string;
    FKey: string;
    FOldValue: string;
    FNewValue: string;
    FOnExecute: TProc<string, string, string>;  // Section, Key, Value
  public
    constructor Create(const ASection, AKey, AOldValue, ANewValue: string;
      AOnExecute: TProc<string, string, string>);
    procedure Execute; override;
    procedure Undo; override;
  end;
  
  /// <summary>
  /// 设置 JSON 对象命令
  /// </summary>
  TSetJSONCommand = class(TConfigCommand)
  private
    FPath: string;
    FOldJSON: TJSONObject;
    FNewJSON: TJSONObject;
    FOnExecute: TProc<string, TJSONObject>;  // Path, JSONObject
  public
    constructor Create(const APath: string; AOldJSON, ANewJSON: TJSONObject;
      AOnExecute: TProc<string, TJSONObject>);
    destructor Destroy; override;
    procedure Execute; override;
    procedure Undo; override;
  end;
  
  /// <summary>
  /// 复合命令 - 将多个命令组合为一个原子操作
  /// </summary>
  TCompositeCommand = class(TConfigCommand)
  private
    FCommands: TObjectList<TConfigCommand>;
  public
    constructor Create(const ADescription: string);
    destructor Destroy; override;
    procedure AddCommand(ACommand: TConfigCommand);
    procedure Execute; override;
    procedure Undo; override;
  end;
  
  /// <summary>
  /// 撤销/重做管理器
  /// </summary>
  TUndoRedoManager = class
  private
    FUndoStack: TObjectList<TConfigCommand>;
    FRedoStack: TObjectList<TConfigCommand>;
    FMaxUndoLevels: Integer;
    FOnStateChanged: TNotifyEvent;
    procedure DoStateChanged;
    procedure TrimUndoStack;
  public
    constructor Create(AMaxUndoLevels: Integer = 100);
    destructor Destroy; override;
    
    /// <summary>执行命令并记录到撤销栈</summary>
    procedure ExecuteCommand(ACommand: TConfigCommand);
    /// <summary>撤销上一个命令</summary>
    procedure Undo;
    /// <summary>重做上一个撤销的命令</summary>
    procedure Redo;
    
    /// <summary>是否可以撤销</summary>
    function CanUndo: Boolean;
    /// <summary>是否可以重做</summary>
    function CanRedo: Boolean;
    /// <summary>获取撤销操作的描述</summary>
    function GetUndoDescription: string;
    /// <summary>获取重做操作的描述</summary>
    function GetRedoDescription: string;
    
    /// <summary>清空所有历史</summary>
    procedure Clear;
    /// <summary>获取撤销栈深度</summary>
    function GetUndoCount: Integer;
    /// <summary>获取重做栈深度</summary>
    function GetRedoCount: Integer;
    
    property MaxUndoLevels: Integer read FMaxUndoLevels write FMaxUndoLevels;
    property OnStateChanged: TNotifyEvent read FOnStateChanged write FOnStateChanged;
  end;

implementation

{ TConfigCommand }

constructor TConfigCommand.Create(const ADescription: string);
begin
  inherited Create;
  FDescription := ADescription;
  FTimestamp := Now;
end;

function TConfigCommand.GetDescription: string;
begin
  Result := FDescription;
end;

{ TSetINIValueCommand }

constructor TSetINIValueCommand.Create(const ASection, AKey, AOldValue, ANewValue: string;
  AOnExecute: TProc<string, string, string>);
begin
  inherited Create(Format('修改 [%s]/%s', [ASection, AKey]));
  FSection := ASection;
  FKey := AKey;
  FOldValue := AOldValue;
  FNewValue := ANewValue;
  FOnExecute := AOnExecute;
end;

procedure TSetINIValueCommand.Execute;
begin
  if Assigned(FOnExecute) then
    FOnExecute(FSection, FKey, FNewValue);
end;

procedure TSetINIValueCommand.Undo;
begin
  if Assigned(FOnExecute) then
    FOnExecute(FSection, FKey, FOldValue);
end;

{ TSetJSONCommand }

constructor TSetJSONCommand.Create(const APath: string; AOldJSON, ANewJSON: TJSONObject;
  AOnExecute: TProc<string, TJSONObject>);
begin
  inherited Create(Format('修改 JSON: %s', [APath]));
  FPath := APath;
  // 克隆 JSON 对象以保持独立性
  if AOldJSON <> nil then
    FOldJSON := TJSONObject(AOldJSON.Clone)
  else
    FOldJSON := nil;
  if ANewJSON <> nil then
    FNewJSON := TJSONObject(ANewJSON.Clone)
  else
    FNewJSON := nil;
  FOnExecute := AOnExecute;
end;

destructor TSetJSONCommand.Destroy;
begin
  FOldJSON.Free;
  FNewJSON.Free;
  inherited;
end;

procedure TSetJSONCommand.Execute;
begin
  if Assigned(FOnExecute) and Assigned(FNewJSON) then
    FOnExecute(FPath, TJSONObject(FNewJSON.Clone));
end;

procedure TSetJSONCommand.Undo;
begin
  if Assigned(FOnExecute) and Assigned(FOldJSON) then
    FOnExecute(FPath, TJSONObject(FOldJSON.Clone));
end;

{ TCompositeCommand }

constructor TCompositeCommand.Create(const ADescription: string);
begin
  inherited Create(ADescription);
  FCommands := TObjectList<TConfigCommand>.Create(True);
end;

destructor TCompositeCommand.Destroy;
begin
  FCommands.Free;
  inherited;
end;

procedure TCompositeCommand.AddCommand(ACommand: TConfigCommand);
begin
  FCommands.Add(ACommand);
end;

procedure TCompositeCommand.Execute;
var
  I: Integer;
begin
  for I := 0 to FCommands.Count - 1 do
    FCommands[I].Execute;
end;

procedure TCompositeCommand.Undo;
var
  I: Integer;
begin
  // 逆序撤销
  for I := FCommands.Count - 1 downto 0 do
    FCommands[I].Undo;
end;

{ TUndoRedoManager }

constructor TUndoRedoManager.Create(AMaxUndoLevels: Integer);
begin
  inherited Create;
  FUndoStack := TObjectList<TConfigCommand>.Create(True);
  FRedoStack := TObjectList<TConfigCommand>.Create(True);
  FMaxUndoLevels := AMaxUndoLevels;
end;

destructor TUndoRedoManager.Destroy;
begin
  FUndoStack.Free;
  FRedoStack.Free;
  inherited;
end;

procedure TUndoRedoManager.DoStateChanged;
begin
  if Assigned(FOnStateChanged) then
    FOnStateChanged(Self);
end;

procedure TUndoRedoManager.TrimUndoStack;
begin
  while FUndoStack.Count > FMaxUndoLevels do
    FUndoStack.Delete(0);  // 删除最旧的命令
end;

procedure TUndoRedoManager.ExecuteCommand(ACommand: TConfigCommand);
begin
  // 执行命令
  ACommand.Execute;
  
  // 添加到撤销栈
  FUndoStack.Add(ACommand);
  TrimUndoStack;
  
  // 清空重做栈（新操作后不能重做之前撤销的操作）
  FRedoStack.Clear;
  
  DoStateChanged;
end;

procedure TUndoRedoManager.Undo;
var
  Command: TConfigCommand;
begin
  if not CanUndo then
    Exit;
    
  // 从撤销栈取出命令
  Command := FUndoStack.Extract(FUndoStack.Last);
  
  // 执行撤销
  Command.Undo;
  
  // 添加到重做栈
  FRedoStack.Add(Command);
  
  DoStateChanged;
end;

procedure TUndoRedoManager.Redo;
var
  Command: TConfigCommand;
begin
  if not CanRedo then
    Exit;
    
  // 从重做栈取出命令
  Command := FRedoStack.Extract(FRedoStack.Last);
  
  // 执行重做
  Command.Execute;
  
  // 添加回撤销栈
  FUndoStack.Add(Command);
  
  DoStateChanged;
end;

function TUndoRedoManager.CanUndo: Boolean;
begin
  Result := FUndoStack.Count > 0;
end;

function TUndoRedoManager.CanRedo: Boolean;
begin
  Result := FRedoStack.Count > 0;
end;

function TUndoRedoManager.GetUndoDescription: string;
begin
  if CanUndo then
    Result := '撤销: ' + FUndoStack.Last.GetDescription
  else
    Result := '';
end;

function TUndoRedoManager.GetRedoDescription: string;
begin
  if CanRedo then
    Result := '重做: ' + FRedoStack.Last.GetDescription
  else
    Result := '';
end;

procedure TUndoRedoManager.Clear;
begin
  FUndoStack.Clear;
  FRedoStack.Clear;
  DoStateChanged;
end;

function TUndoRedoManager.GetUndoCount: Integer;
begin
  Result := FUndoStack.Count;
end;

function TUndoRedoManager.GetRedoCount: Integer;
begin
  Result := FRedoStack.Count;
end;

end.
