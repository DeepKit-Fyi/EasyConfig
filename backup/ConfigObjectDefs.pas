unit ConfigObjectDefs;

interface

uses
  System.SysUtils, System.Classes, System.IniFiles, SuperObject;

type
  { 閰嶇疆瀵硅薄鍩虹绫诲瀷 }
  TConfigFormat = (cfINI, cfJSON);

  { 鍩虹閰嶇疆瀵硅薄鎶借薄绫?}
  TConfigObject = class abstract
  public
    procedure LoadFromFile(const FileName: String); virtual; abstract;
    procedure SaveToFile(const FileName: String); virtual; abstract;
    function Validate(out Errors: TStringList): Boolean; virtual; abstract;
  end;

  { INI閰嶇疆瀵硅薄鍩虹被 }
  TINIConfigObject = class(TConfigObject)
  protected
    procedure InternalLoad(Ini: TMemIniFile); virtual; abstract;
    procedure InternalSave(Ini: TMemIniFile); virtual; abstract;
  end;

  { JSON閰嶇疆瀵硅薄鍩虹被 }
  TJSONConfigObject = class(TConfigObject)
  protected
    procedure InternalLoad(Json: ISuperObject); virtual; abstract;
    procedure InternalSave(Json: ISuperObject); virtual; abstract;
  end;

implementation

end.