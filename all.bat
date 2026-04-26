@echo off
openfiles >nul 2>&1 || (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0""", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B
)

echo.
echo [!] O comando a seguir (Clear-Tpm) pode solicitar reinicializacao em alguns sistemas.
echo [!] Aguardando 10 segundos para voce ler os logs anteriores...
timeout /t 10

powershell -Command "Clear-Tpm"
powershell -Command "Disable-TpmAutoProvisioning"

echo [+] Localizacao atual do script: "%~dp0"
if exist "%~dp0ac.sys" (
    echo [+] Encontrado ac.sys em "%~dp0ac.sys"
) else (
    echo [!] ERRO: ac.sys NAO ENCONTRADO em "%~dp0ac.sys"
    dir "%~dp0"
)

sc stop ac >nul 2>&1
sc delete ac >nul 2>&1
sc create ac type= kernel start= auto binPath= "%~dp0ac.sys"
sc start ac

echo.
echo Processo de TPM finalizado. Verifique os logs acima.
pause
