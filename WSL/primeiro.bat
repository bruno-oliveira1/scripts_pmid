@echo off
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

echo Habilitando recursos do Windows
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
echo Baixando arquivos necessarios por favor aguarde ...
powershell Invoke-WebRequest -Uri https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi -OutFile C:\wsl_update_x64.msi
powershell Invoke-WebRequest -Uri https://aka.ms/wsl-debian-gnulinux -OutFile C:\debian.appx
msiexec /i C:\wsl_update_x64.msi /quiet

set /p resp="Eh necessario reiniciar, deseja fazer isso agora ? (sim = s / nao = n ) "
if %resp% == s (
    echo Reiniciando em 5 segundos
    timeout /t 5
    shutdown -r -t 0 
) else if %resp% == n (
    echo Lembre de reiniciar assim que possivel, saindo ....
    timeout /t 5
    exit
) else (
  echo Resposta invalida, Lembre de reiniciar assim que possivel, saindo ...
  timeout /t 5
  exit
)