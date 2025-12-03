@echo off
setlocal

set BDS=d:\Program Files (x86)\Embarcadero\Studio\23.0
set DUNITX=D:\ProgramData\delphi\DUnitX\Source

echo Compiling EasyConfigTests...
echo.

"%BDS%\bin\dcc32.exe" -Q -B ^
  -NSSystem;Xml;Data;Datasnap;Web;Soap;Winapi;System.Win;Data.Win;Datasnap.Win;Web.Win;Soap.Win;Xml.Win;FMX ^
  -U"%DUNITX%" ^
  -U".." ^
  -R".." ^
  -E"Win32\Debug" ^
  -N"Win32\Debug" ^
  EasyConfigTests.dpr

if errorlevel 1 (
    echo.
    echo Compilation FAILED!
    exit /b 1
) else (
    echo.
    echo Compilation SUCCESSFUL!
)

endlocal
