@echo off
echo Instalando o Debian por favor aguarde ...
wsl --set-default-version 2
powershell Add-AppxPackage C:\debian.appx

if "%PROCESSOR_ARCHITECTURE%" == "x86" (
    if exist "%windir%\SysWOW64\cmd.exe" (
        %windir%\SysWOW64\cmd.exe /c "%~dp0%~n0.bat" %*
    ) else (
        %windir%\system32\cmd.exe /c "%~dp0%~n0.bat" %*
    )
    exit /b
)

net session >nul 2>&1
if %errorLevel% == 0 (
    echo Executando como admin.
) else (
    echo Pedindo permissao para de admin...
    powershell -Command "Start-Process cmd -Verb runAs -ArgumentList '/c %~dp0%~n0.bat'"
    exit /b
)

msiexec /i C:\wsl_update_x64.msi /quiet
echo Apagando arquivos baixados
del C:\debian.appx
del C:\wsl_update_x64.msi
timeout /t 5