@echo off
REM EasyConfig DUnitX 测试运行脚本
REM 请确保 Delphi 的 rsvars.bat 在 PATH 中，或者修改下面的路径

REM 尝试查找 rsvars.bat
if exist "%BDS%\bin\rsvars.bat" (
    call "%BDS%\bin\rsvars.bat"
) else if exist "C:\Program Files (x86)\Embarcadero\Studio\23.0\bin\rsvars.bat" (
    call "C:\Program Files (x86)\Embarcadero\Studio\23.0\bin\rsvars.bat"
) else if exist "C:\Program Files (x86)\Embarcadero\Studio\22.0\bin\rsvars.bat" (
    call "C:\Program Files (x86)\Embarcadero\Studio\22.0\bin\rsvars.bat"
) else if exist "C:\Program Files (x86)\Embarcadero\Studio\21.0\bin\rsvars.bat" (
    call "C:\Program Files (x86)\Embarcadero\Studio\21.0\bin\rsvars.bat"
) else (
    echo 错误: 找不到 Delphi rsvars.bat
    echo 请设置 BDS 环境变量或修改此脚本
    pause
    exit /b 1
)

echo.
echo ========================================
echo 编译 EasyConfig 测试项目
echo ========================================
echo.

cd /d "%~dp0"

REM 编译测试项目
msbuild EasyConfigTests.dproj /t:Build /p:Config=Debug /p:Platform=Win32 /v:minimal

if errorlevel 1 (
    echo.
    echo 编译失败！
    pause
    exit /b 1
)

echo.
echo ========================================
echo 运行测试
echo ========================================
echo.

REM 运行测试
Win32\Debug\EasyConfigTests.exe

echo.
echo 测试完成
pause
