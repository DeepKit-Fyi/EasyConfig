unit MemoryOptimizer;

interface

uses
  System.SysUtils, System.Classes, System.JSON, JSONHelpers, System.Generics.Collections,
  Winapi.Windows, ErrorLogger;

type
  TMemoryUsageInfo = record
    TotalPhysical: UInt64;
    AvailablePhysical: UInt64;
    MemoryLoad: UInt64;
    ProcessUsage: UInt64;
  end;
  
  TMemoryOptimizer = class
  private
    class var FInstance: TMemoryOptimizer;
    
    FEnabled: Boolean;
    FAutoOptimizeThreshold: UInt64;
    FLastOptimizeTime: TDateTime;
    FOptimizeInterval: Integer;
    FJSONCache: TObjectDictionary<string, TJSONValue>;
    FMaxCacheSize: Integer;
    FLRUList: TList<string>;
    
    constructor Create;
    destructor Destroy; override;
    
    procedure OptimizeMemory;
    procedure TrimJSONCache;
    function GetMemoryInfo: TMemoryUsageInfo;
  public
    class function GetInstance: TMemoryOptimizer;
    class procedure ReleaseInstance;
    
    procedure Initialize;
    procedure CheckAndOptimize;
    procedure ForceOptimize;
    
    function CacheJSON(const Key: string; JSONValue: TJSONValue): TJSONValue;
    function GetCachedJSON(const Key: string): TJSONValue;
    procedure RemoveFromCache(const Key: string);
    procedure ClearCache;
    
    property Enabled: Boolean read FEnabled write FEnabled;
    property AutoOptimizeThreshold: UInt64 read FAutoOptimizeThreshold write FAutoOptimizeThreshold;
    property OptimizeInterval: Integer read FOptimizeInterval write FOptimizeInterval;
    property MaxCacheSize: Integer read FMaxCacheSize write FMaxCacheSize;
  end;

// 全局访问函数
function MemOptimizer: TMemoryOptimizer;

implementation

function MemOptimizer: TMemoryOptimizer;
begin
  Result := TMemoryOptimizer.GetInstance;
end;

{ TMemoryOptimizer }

function TMemoryOptimizer.CacheJSON(const Key: string; JSONValue: TJSONValue): TJSONValue;
var
  ClonedJSON: TJSONValue;
begin
  if not FEnabled then
  begin
    Result := JSONValue;
    Exit;
  end;
  
  // 如果缓存已满，清理一些项
  if FJSONCache.Count >= FMaxCacheSize then
    TrimJSONCache;
    
  // 如果键已存在，先移除
  RemoveFromCache(Key);
  
  // 克隆JSON值以避免外部修改
  ClonedJSON := TJSONObject.ParseJSONValue(JSONValue.ToJSON);
  
  // 添加到缓存
  FJSONCache.Add(Key, ClonedJSON);
  
  // 更新LRU列表
  FLRUList.Add(Key);
  
  Result := ClonedJSON;
end;

procedure TMemoryOptimizer.CheckAndOptimize;
var
  MemInfo: TMemoryUsageInfo;
  CurrentTime: TDateTime;
begin
  if not FEnabled then
    Exit;
    
  // 检查是否达到优化间隔
  CurrentTime := Now;
  if SecondsBetween(CurrentTime, FLastOptimizeTime) < FOptimizeInterval then
    Exit;
    
  // 获取内存使用情况
  MemInfo := GetMemoryInfo;
  
  // 如果内存使用超过阈值，执行优化
  if MemInfo.ProcessUsage > FAutoOptimizeThreshold then
  begin
    OptimizeMemory;
    FLastOptimizeTime := CurrentTime;
  end;
end;

procedure TMemoryOptimizer.ClearCache;
begin
  FJSONCache.Clear;
  FLRUList.Clear;
end;

constructor TMemoryOptimizer.Create;
begin
  FEnabled := True;
  FAutoOptimizeThreshold := 100 * 1024 * 1024; // 默认100MB
  FLastOptimizeTime := 0;
  FOptimizeInterval := 60; // 默认60秒
  FMaxCacheSize := 100;    // 默认最多缓存100个JSON对象
  
  FJSONCache := TObjectDictionary<string, TJSONValue>.Create([doOwnsValues]);
  FLRUList := TList<string>.Create;
end;

destructor TMemoryOptimizer.Destroy;
begin
  FLRUList.Free;
  FJSONCache.Free;
  inherited;
end;

procedure TMemoryOptimizer.ForceOptimize;
begin
  OptimizeMemory;
  FLastOptimizeTime := Now;
end;

function TMemoryOptimizer.GetCachedJSON(const Key: string): TJSONValue;
begin
  Result := nil;
  
  if not FEnabled then
    Exit;
    
  if FJSONCache.TryGetValue(Key, Result) then
  begin
    // 更新LRU列表
    FLRUList.Remove(Key);
    FLRUList.Add(Key);
  end;
end;

class function TMemoryOptimizer.GetInstance: TMemoryOptimizer;
begin
  if not Assigned(FInstance) then
    FInstance := TMemoryOptimizer.Create;
    
  Result := FInstance;
end;

function TMemoryOptimizer.GetMemoryInfo: TMemoryUsageInfo;
var
  MemStatus: TMemoryStatusEx;
  ProcessHandle: THandle;
  ProcessMemCounters: TProcessMemoryCounters;
begin
  // 初始化结果
  FillChar(Result, SizeOf(Result), 0);
  
  // 获取系统内存信息
  MemStatus.dwLength := SizeOf(MemStatus);
  if GlobalMemoryStatusEx(MemStatus) then
  begin
    Result.TotalPhysical := MemStatus.ullTotalPhys;
    Result.AvailablePhysical := MemStatus.ullAvailPhys;
    Result.MemoryLoad := MemStatus.dwMemoryLoad;
  end;
  
  // 获取进程内存信息
  ProcessHandle := GetCurrentProcess;
  ProcessMemCounters.cb := SizeOf(ProcessMemCounters);
  
  if GetProcessMemoryInfo(ProcessHandle, @ProcessMemCounters, SizeOf(ProcessMemCounters)) then
    Result.ProcessUsage := ProcessMemCounters.WorkingSetSize;
end;

procedure TMemoryOptimizer.Initialize;
begin
  // 初始化内存优化器
  FLastOptimizeTime := Now;
  
  // 记录初始内存使用情况
  var MemInfo := GetMemoryInfo;
  Logger.Log(Format('内存优化器初始化: 总物理内存: %d MB, 可用: %d MB, 内存负载: %d%%, 进程使用: %d MB',
    [MemInfo.TotalPhysical div (1024*1024),
     MemInfo.AvailablePhysical div (1024*1024),
     MemInfo.MemoryLoad,
     MemInfo.ProcessUsage div (1024*1024)]), llInfo);
end;

procedure TMemoryOptimizer.OptimizeMemory;
begin
  // 清理JSON缓存
  TrimJSONCache;
  
  // 调用GC
  ReportMemoryLeaksOnShutdown := False;
  
  // 强制垃圾回收
  SetProcessWorkingSetSize(GetCurrentProcess, $FFFFFFFF, $FFFFFFFF);
  
  // 记录优化后的内存使用情况
  var MemInfo := GetMemoryInfo;
  Logger.Log(Format('内存优化完成: 总物理内存: %d MB, 可用: %d MB, 内存负载: %d%%, 进程使用: %d MB',
    [MemInfo.TotalPhysical div (1024*1024),
     MemInfo.AvailablePhysical div (1024*1024),
     MemInfo.MemoryLoad,
     MemInfo.ProcessUsage div (1024*1024)]), llInfo);
end;

class procedure TMemoryOptimizer.ReleaseInstance;
begin
  if Assigned(FInstance) then
  begin
    FInstance.Free;
    FInstance := nil;
  end;
end;

procedure TMemoryOptimizer.RemoveFromCache(const Key: string);
begin
  if not FEnabled then
    Exit;
    
  if FJSONCache.ContainsKey(Key) then
  begin
    FJSONCache.Remove(Key);
    FLRUList.Remove(Key);
  end;
end;

procedure TMemoryOptimizer.TrimJSONCache;
var
  i, RemoveCount: Integer;
  Key: string;
begin
  // 如果缓存未满，不需要清理
  if FJSONCache.Count < FMaxCacheSize then
    Exit;
    
  // 计算要移除的项数
  RemoveCount := FJSONCache.Count div 4; // 每次清理1/4的缓存
  if RemoveCount < 1 then
    RemoveCount := 1;
    
  // 从LRU列表中移除最早使用的项
  for i := 1 to RemoveCount do
  begin
    if FLRUList.Count = 0 then
      Break;
      
    Key := FLRUList[0];
    FLRUList.Delete(0);
    FJSONCache.Remove(Key);
  end;
end;

initialization
  // 不在这里创建实例，而是在需要时通过GetInstance创建

finalization
  TMemoryOptimizer.ReleaseInstance;

end.
