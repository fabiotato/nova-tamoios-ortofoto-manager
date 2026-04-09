@echo off
REM ============================================================
REM OrtoFoto Manager — Executavel de correcao automatica
REM ============================================================

echo ============================================================
echo   OrtoFoto Manager - Correcao Automatica de Ortofotos
echo ============================================================
echo.

set ACAD_PATH=
for %%V in (2027 2026 2025 2024 2023 2022) do (
    if exist "D:\AutoCAD %%V\acad.exe" (
        if not defined ACAD_PATH set ACAD_PATH=D:\AutoCAD %%V\acad.exe
    )
)

if not defined ACAD_PATH (
    echo ERRO: Nenhuma versao do AutoCAD encontrada.
    pause
    exit /b 1
)

echo AutoCAD encontrado: %ACAD_PATH%
echo.

set BASE=%~dp0
set BASE=%BASE:~0,-1%

set DWG_FILE=%BASE%\Mapa de Pendencias - Panorama da Obra - Kyioshi FINAL.dwg
set LSP_FILE=%BASE%\fix_ortofotos.lsp
set SCRIPT=%BASE%\fix_ortofotos_runtime.scr

if not exist "%DWG_FILE%" (
    echo ERRO: DWG nao encontrado: %DWG_FILE%
    pause
    exit /b 1
)

if not exist "%LSP_FILE%" (
    echo ERRO: LSP nao encontrado: %LSP_FILE%
    pause
    exit /b 1
)

set LSP_ESCAPED=%LSP_FILE:\=\\%
(
    echo (load "%LSP_ESCAPED%")
    echo FIX_ORTOFOTOS
    echo.
) > "%SCRIPT%" 2>nul

REM Inicia PowerShell em background para fechar o popup de trial automaticamente
start /b powershell -WindowStyle Hidden -Command ^
  "$deadline = (Get-Date).AddSeconds(30); ^
   while ((Get-Date) -lt $deadline) { ^
     $w = Get-Process acad -ErrorAction SilentlyContinue | Where-Object {$_.MainWindowTitle -ne ''}; ^
     if ($w) { ^
       Add-Type -AssemblyName UIAutomationClient; ^
       [System.Windows.Automation.AutomationElement]::RootElement.FindAll( ^
         [System.Windows.Automation.TreeScope]::Children, ^
         [System.Windows.Automation.PropertyCondition]::new( ^
           [System.Windows.Automation.AutomationElement]::NameProperty,'AutoCAD' ^
         ) ^
       ) | ForEach-Object { ^
         $btn = $_.FindFirst([System.Windows.Automation.TreeScope]::Descendants, ^
           [System.Windows.Automation.PropertyCondition]::new( ^
             [System.Windows.Automation.AutomationElement]::ControlTypeProperty, ^
             [System.Windows.Automation.ControlType]::Button ^
           )); ^
         if ($btn) { ^
           $btn.GetCurrentPattern([System.Windows.Automation.InvokePattern]::Pattern).Invoke() ^
         } ^
       }; ^
       break ^
     }; ^
     Start-Sleep -Milliseconds 500 ^
   }"

echo Abrindo AutoCAD e executando correcao...
start /wait "" "%ACAD_PATH%" "%DWG_FILE%" /nologo /b "%SCRIPT%"

echo.
echo Concluido! Verifique o arquivo DWG atualizado.
pause