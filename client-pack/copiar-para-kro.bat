@echo off
setlocal EnableExtensions
chcp 65001 >nul

REM ============================================================
REM  Copia o pacote MeuRO para a pasta do kRO.
REM  Edite KRO_DIR se o seu jogo NAO estiver em C:\RO\kRO
REM ============================================================
set "KRO_DIR=C:\RO\kRO"

if not exist "%KRO_DIR%\data.grf" (
    echo.
    echo Pasta do kRO nao encontrada ou incompleta:
    echo   %KRO_DIR%
    echo.
    echo Extraia o kRO Full Client nessa pasta ate existir data.grf
    echo Depois edite KRO_DIR neste arquivo se o caminho for outro.
    echo.
    pause
    exit /b 1
)

set "SRC=%~dp0"
echo Copiando arquivos de:
echo   %SRC%
echo para:
echo   %KRO_DIR%
echo.

xcopy /E /Y /I "%SRC%data" "%KRO_DIR%\data" >nul
if errorlevel 1 (
    echo Falha ao copiar a pasta data.
    pause
    exit /b 1
)

xcopy /E /Y /I "%SRC%System" "%KRO_DIR%\System" >nul
copy /Y "%SRC%DATA.ini" "%KRO_DIR%\DATA.ini" >nul

echo OK. Arquivos do MeuRO copiados.
echo.
echo Proximos passos:
echo  1. Patcheie o Ragexe 2021-11-03 com o WARP ^(veja WARP-patches.txt^)
echo  2. Salve o exe como %KRO_DIR%\MeuRO.exe
echo  3. Ligar login/char/web/map no rAthena
echo  4. Abrir MeuRO.exe e entrar com paulo / vitor
echo.
pause
