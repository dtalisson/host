@echo off
openfiles >nul 2>&1 || (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0""", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B
)

echo.
echo [+] Executando Clear-Tpm e desativando AutoProvisioning...
powershell -Command "Clear-Tpm"
powershell -Command "Disable-TpmAutoProvisioning"

sc stop ac >nul 2>&1
sc delete ac >nul 2>&1
sc create ac type= kernel start= auto binPath= "%~dp0ac.sys"
sc start ac

echo.
echo [+] Processo de TPM finalizado com sucesso.
