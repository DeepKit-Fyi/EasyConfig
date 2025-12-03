unit GUITestRunner;

interface

uses
  TestFramework;

procedure RunRegisteredTests;

implementation

uses
  SysUtils, Dialogs, Forms;

procedure RunRegisteredTests;
var
  FailureCount: Integer;
begin
  try
    ShowMessage('娴嬭瘯寮€濮嬭繍琛?..');
    FailureCount := TestFramework.RunRegisteredTests;
    
    ShowMessage(Format('娴嬭瘯瀹屾垚銆傚け璐? %d', [FailureCount]));
  except
    on E: Exception do
      ShowMessage('娴嬭瘯杩愯閿欒: ' + E.Message);
  end;
end;

end. 