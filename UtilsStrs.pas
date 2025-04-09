unit UtilsStrs;

interface

uses
  System.SysUtils, System.Classes;

// 瀛楃涓叉媶鍒嗕负鏁扮粍
function SplitString(const Str: string; const Delimiter: string): TArray<string>;

// 瀛楃涓插幓闄ら灏剧┖鏍?
function TrimString(const Str: string): string;

// 瀹夊叏鍦板皢瀛楃涓茶浆鎹负鏁存暟
function StrToIntDef(const Str: string; const Default: Integer): Integer;

// 瀹夊叏鍦板皢瀛楃涓茶浆鎹负娴偣鏁?
function StrToFloatDef(const Str: string; const Default: Double): Double;

// 鏍煎紡鍖栭噾棰濆瓧绗︿覆
function FormatCurrency(const Value: Double): string;

// 妫€鏌ュ瓧绗︿覆鏄惁涓虹┖鎴栦粎鍖呭惈绌烘牸
function IsEmptyString(const Str: string): Boolean;

// 灏嗛┘宄板懡鍚嶈浆鎹负鐢ㄧ┖鏍煎垎闅旂殑鍗曡瘝
function CamelCaseToWords(const Str: string): string;

// 瀛楃涓茶ˉ榻愬埌鎸囧畾闀垮害
function PadString(const Str: string; const Length: Integer; const PadChar: Char = ' '; const PadLeft: Boolean = True): string;

implementation

function SplitString(const Str: string; const Delimiter: string): TArray<string>;
begin
  Result := Str.Split([Delimiter], TStringSplitOptions.None);
end;

function TrimString(const Str: string): string;
begin
  Result := Str.Trim;
end;

function StrToIntDef(const Str: string; const Default: Integer): Integer;
begin
  Result := System.SysUtils.StrToIntDef(Str, Default);
end;

function StrToFloatDef(const Str: string; const Default: Double): Double;
begin
  Result := System.SysUtils.StrToFloatDef(Str, Default);
end;

function FormatCurrency(const Value: Double): string;
begin
  Result := FormatFloat('#,##0.00', Value);
end;

function IsEmptyString(const Str: string): Boolean;
begin
  Result := Str.Trim = '';
end;

function CamelCaseToWords(const Str: string): string;
var
  i: Integer;
begin
  if Str = '' then
    Exit('');
    
  Result := Str[1];
  
  for i := 2 to Length(Str) do
  begin
    if System.SysUtils.CharInSet(Str[i], ['A'..'Z']) and not System.SysUtils.CharInSet(Str[i-1], ['A'..'Z']) then
      Result := Result + ' ' + Str[i]
    else
      Result := Result + Str[i];
  end;
end;

function PadString(const Str: string; const Length: Integer; const PadChar: Char; const PadLeft: Boolean): string;
begin
  if System.Length(Str) >= Length then
    Result := Str
  else
  begin
    if PadLeft then
      Result := StringOfChar(PadChar, Length - System.Length(Str)) + Str
    else
      Result := Str + StringOfChar(PadChar, Length - System.Length(Str));
  end;
end;

end. 