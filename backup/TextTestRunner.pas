unit TextTestRunner;

interface

uses
  TestFramework;

function RunRegisteredTests: Integer;

implementation

function RunRegisteredTests: Integer;
begin
  Result := TestFramework.RunRegisteredTests;
end;

end. 