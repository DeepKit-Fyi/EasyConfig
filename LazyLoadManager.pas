unit LazyLoadManager;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.Threading,
  Vcl.ComCtrls, System.JSON, JSONHelpers, ErrorLogger;

type
  TLoadNodeCallback = reference to procedure(Node: TTreeNode; Data: TJSONObject);
  TLoadCompleteCallback = reference to procedure;

  TLazyLoadRequest = class
  private
    FNode: TTreeNode;
    FData: TJSONObject;
    FLoadCallback: TLoadNodeCallback;
    FCompleteCallback: TLoadCompleteCallback;
  public
    constructor Create(Node: TTreeNode; Data: TJSONObject; 
                      LoadCallback: TLoadNodeCallback;
                      CompleteCallback: TLoadCompleteCallback);
    property Node: TTreeNode read FNode;
    property Data: TJSONObject read FData;
    property LoadCallback: TLoadNodeCallback read FLoadCallback;
    property CompleteCallback: TLoadCompleteCallback read FCompleteCallback;
  end;

  TLazyLoadManager = class
  private
    class var FInstance: TLazyLoadManager;
    
    FRequestQueue: TQueue<TLazyLoadRequest>;
    FIsProcessing: Boolean;
    FMaxBatchSize: Integer;
    FBatchDelay: Integer;
    
    constructor Create;
    destructor Destroy; override;
    
    procedure ProcessQueue;
    procedure ProcessBatch;
  public
    class function GetInstance: TLazyLoadManager;
    class procedure ReleaseInstance;
    
    procedure QueueNodeLoad(Node: TTreeNode; Data: TJSONObject; 
                           LoadCallback: TLoadNodeCallback;
                           CompleteCallback: TLoadCompleteCallback = nil);
    procedure ClearQueue;
    
    property MaxBatchSize: Integer read FMaxBatchSize write FMaxBatchSize;
    property BatchDelay: Integer read FBatchDelay write FBatchDelay;
  end;

// 全局访问函数
function LazyLoader: TLazyLoadManager;

implementation

uses
  Vcl.Forms;

function LazyLoader: TLazyLoadManager;
begin
  Result := TLazyLoadManager.GetInstance;
end;

{ TLazyLoadRequest }

constructor TLazyLoadRequest.Create(Node: TTreeNode; Data: TJSONObject;
  LoadCallback: TLoadNodeCallback; CompleteCallback: TLoadCompleteCallback);
begin
  FNode := Node;
  FData := Data;
  FLoadCallback := LoadCallback;
  FCompleteCallback := CompleteCallback;
end;

{ TLazyLoadManager }

constructor TLazyLoadManager.Create;
begin
  FRequestQueue := TQueue<TLazyLoadRequest>.Create;
  FIsProcessing := False;
  FMaxBatchSize := 10; // 默认每批处理10个节点
  FBatchDelay := 50;   // 默认批次间隔50毫秒
end;

destructor TLazyLoadManager.Destroy;
begin
  ClearQueue;
  FRequestQueue.Free;
  inherited;
end;

procedure TLazyLoadManager.ClearQueue;
var
  Request: TLazyLoadRequest;
begin
  while FRequestQueue.Count > 0 do
  begin
    Request := FRequestQueue.Dequeue;
    Request.Free;
  end;
end;

class function TLazyLoadManager.GetInstance: TLazyLoadManager;
begin
  if not Assigned(FInstance) then
    FInstance := TLazyLoadManager.Create;
    
  Result := FInstance;
end;

procedure TLazyLoadManager.ProcessBatch;
var
  i, Count: Integer;
  Request: TLazyLoadRequest;
begin
  try
    // 确定本批次要处理的数量
    Count := FRequestQueue.Count;
    if Count > FMaxBatchSize then
      Count := FMaxBatchSize;
      
    // 处理批次
    for i := 1 to Count do
    begin
      if FRequestQueue.Count = 0 then
        Break;
        
      Request := FRequestQueue.Dequeue;
      try
        // 检查节点是否仍然有效
        if Assigned(Request.Node) and not Request.Node.Deleting and
           Assigned(Request.Node.TreeView) and
           Assigned(Request.LoadCallback) then
        begin
          try
            // 调用加载回调
            Request.LoadCallback(Request.Node, Request.Data);
          except
            on E: Exception do
              Logger.Log('处理延迟加载节点时发生错误', E, llError);
          end;
        end;
        
        // 调用完成回调
        if Assigned(Request.CompleteCallback) then
        begin
          try
            Request.CompleteCallback;
          except
            on E: Exception do
              Logger.Log('调用延迟加载完成回调时发生错误', E, llError);
          end;
        end;
      finally
        Request.Free;
      end;
    end;
    
    // 如果队列中还有请求，安排下一批处理
    if FRequestQueue.Count > 0 then
    begin
      TThread.CreateAnonymousThread(
        procedure
        begin
          Sleep(FBatchDelay);
          TThread.Synchronize(nil,
            procedure
            begin
              ProcessBatch;
            end);
        end).Start;
    end
    else
      FIsProcessing := False;
  except
    on E: Exception do
    begin
      Logger.Log('处理延迟加载批次时发生错误', E, llError);
      FIsProcessing := False;
    end;
  end;
end;

procedure TLazyLoadManager.ProcessQueue;
begin
  if FIsProcessing then
    Exit;
    
  FIsProcessing := True;
  ProcessBatch;
end;

procedure TLazyLoadManager.QueueNodeLoad(Node: TTreeNode; Data: TJSONObject;
  LoadCallback: TLoadNodeCallback; CompleteCallback: TLoadCompleteCallback);
var
  Request: TLazyLoadRequest;
begin
  if not Assigned(Node) or not Assigned(LoadCallback) then
    Exit;
    
  Request := TLazyLoadRequest.Create(Node, Data, LoadCallback, CompleteCallback);
  FRequestQueue.Enqueue(Request);
  
  // 如果队列未在处理中，开始处理
  if not FIsProcessing then
    ProcessQueue;
end;

class procedure TLazyLoadManager.ReleaseInstance;
begin
  if Assigned(FInstance) then
  begin
    FInstance.Free;
    FInstance := nil;
  end;
end;

initialization
  // 不在这里创建实例，而是在需要时通过GetInstance创建

finalization
  TLazyLoadManager.ReleaseInstance;

end.
