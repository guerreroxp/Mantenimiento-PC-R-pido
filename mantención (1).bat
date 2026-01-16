@echo off
set BASE=%~dp0Reportes
if not exist "%BASE%" mkdir "%BASE%"
chcp 65001 >nul
title Mantenimiento Windows - EcooEmpresas - Christian Guzmán - @guerreroxp
color 0A

:: ============================
:: VARIABLES GLOBALES
:: ============================
set BASE=%~dp0
set REPORTS=%BASE%REPORTES
set LOGFILE=%REPORTS%\log_%USERNAME%_%COMPUTERNAME%.txt

if not exist "%REPORTS%" mkdir "%REPORTS%"

:: ============================
:: DATOS GENERALES
:: ============================
set FECHA=%DATE%
set HORA=%TIME%
set USUARIO=%USERNAME%
set EQUIPO=%COMPUTERNAME%

:: ============================
:: MENU PRINCIPAL
:: ============================
:MENU
cls
echo ==========================================
echo   MANTENIMIENTO WINDOWS - ECOOEMPRESAS
echo ==========================================
echo Usuario : %USERNAME%
echo Equipo  : %COMPUTERNAME%
echo Fecha   : %DATE% %TIME%
echo ==========================================
echo.
echo 1. Eliminar datos de Google Chrome
echo 2. Eliminar temporales de Windows
echo 3. Limpieza de carpetas del usuario
echo 4. Reporte de programas instalados
echo 5. Restaurar tema e imagen por defecto
echo 6. Reporte de hardware del equipo
echo 7. Limpieza Word / Excel / PowerPoint
echo 8. Limpieza Explorador de archivos (Recientes y Red)
echo 9. Normalizar nombres de carpetas del sistema
echo A. Aplicar imagen corporativa completa
echo 0. Salir
echo.
set /p op=Seleccione una opcion:

if "%op%"=="1" goto CHROME
if "%op%"=="2" goto TEMP
if "%op%"=="3" goto USERFILES_MENU
if "%op%"=="4" goto PROGRAMAS
if "%op%"=="5" goto TEMA_DEFAULT
if "%op%"=="6" goto HARDWARE
if "%op%"=="7" goto OFFICE
if "%op%"=="8" goto EXPLORER
if "%op%"=="9" goto NORMALIZAR_IDIOMA
if /I "%op%"=="A" goto IMAGEN_CORPORATIVA
if "%op%"=="0" goto SALIR
goto MENU

:: ============================
:: CONFIRMACION
:: ============================
:CONFIRMAR
set /p CONF=¿Seguro que desea continuar? (S/N):
if /I "%CONF%"=="S" exit /b 0
exit /b 1

:: ============================
:: LOG
:: ============================
:LOG
echo [%DATE% %TIME%] %~1>> "%LOGFILE%"
exit /b

:: ============================
:: CHROME
:: ============================
:CHROME
cls
call :CONFIRMAR || goto MENU
call :LOG "Limpieza Google Chrome"
taskkill /f /im chrome.exe >nul 2>&1
rd /s /q "%LOCALAPPDATA%\Google\Chrome" >nul 2>&1
echo Chrome limpiado.
pause
goto MENU

:: ============================
:: TEMPORALES
:: ============================
:TEMP
cls
call :CONFIRMAR || goto MENU
call :LOG "Limpieza temporales Windows"
del /s /f /q "%TEMP%\*" >nul 2>&1
del /s /f /q "C:\Windows\Temp\*" >nul 2>&1
echo Temporales eliminados.
pause
goto MENU

:: ============================
:: SUBMENU USUARIO
:: ============================
:USERFILES_MENU
cls
echo ==========================================
echo   CARPETAS DEL USUARIO
echo ==========================================
echo 1. Respaldar datos
echo 2. Limpiar datos SIN respaldo
echo 3. Respaldar y limpiar
echo 4. Volver al menu principal
echo ==========================================
set /p uf=Seleccione opcion:

if "%uf%"=="1" goto BACKUP_ONLY
if "%uf%"=="2" goto CLEAN_ONLY
if "%uf%"=="3" goto BACKUP_AND_CLEAN
if "%uf%"=="4" goto MENU
goto USERFILES_MENU

:: ============================
:: SELECCION UNIDAD
:: ============================
:SELECT_DRIVE
cls
echo Ingrese letra de unidad destino (Ej: C, D, E)
set /p DRIVE=Unidad:
if not exist "%DRIVE%:\" (
    echo Unidad no valida.
    pause
    goto SELECT_DRIVE
)
set BACKUP_ROOT=%DRIVE%:\EcooEmpresas_Backup
if not exist "%BACKUP_ROOT%" mkdir "%BACKUP_ROOT%"
exit /b

:: ============================
:: BACKUP
:: ============================
:BACKUP_ONLY
call :SELECT_DRIVE
set BKDIR=%BACKUP_ROOT%\%USERNAME%_%COMPUTERNAME%_%DATE:~-4%%DATE:~3,2%%DATE:~0,2%_%TIME:~0,2%-%TIME:~3,2%
mkdir "%BKDIR%"
call :LOG "Respaldo iniciado en %BKDIR%"

xcopy "%USERPROFILE%\Desktop" "%BKDIR%\Escritorio" /E /I /H /Y >nul
xcopy "%USERPROFILE%\Documents" "%BKDIR%\Documentos" /E /I /H /Y >nul
xcopy "%USERPROFILE%\Downloads" "%BKDIR%\Descargas" /E /I /H /Y >nul
xcopy "%USERPROFILE%\Pictures" "%BKDIR%\Imagenes" /E /I /H /Y >nul
xcopy "%USERPROFILE%\Music" "%BKDIR%\Musica" /E /I /H /Y >nul
xcopy "%USERPROFILE%\Videos" "%BKDIR%\Videos" /E /I /H /Y >nul

call :LOG "Respaldo finalizado"
echo Respaldo completado.
pause
goto USERFILES_MENU

:: ============================
:: LIMPIAR
:: ============================
:CLEAN_ONLY
cls
call :CONFIRMAR || goto USERFILES_MENU
call :LOG "Limpieza carpetas usuario"

rd /s /q "%USERPROFILE%\Desktop"
rd /s /q "%USERPROFILE%\Documents"
rd /s /q "%USERPROFILE%\Downloads"
rd /s /q "%USERPROFILE%\Pictures"
rd /s /q "%USERPROFILE%\Music"
rd /s /q "%USERPROFILE%\Videos"

mkdir "%USERPROFILE%\Desktop"
mkdir "%USERPROFILE%\Documents"
mkdir "%USERPROFILE%\Downloads"
mkdir "%USERPROFILE%\Pictures"
mkdir "%USERPROFILE%\Music"
mkdir "%USERPROFILE%\Videos"

call :LOG "Limpieza completada"
echo Limpieza finalizada.
pause
goto USERFILES_MENU

:: ============================
:: BACKUP + LIMPIAR
:: ============================
:BACKUP_AND_CLEAN
call :CONFIRMAR || goto USERFILES_MENU
call :BACKUP_ONLY
goto CLEAN_ONLY

:: ============================
:: PROGRAMAS
:: ============================
:PROGRAMAS
cls
call :LOG "Generando reporte de programas instalados (CMD)"

set REPORT=%BASE%\Programas_Instalados_%COMPUTERNAME%_%USERNAME%.txt

echo REPORTE DE PROGRAMAS INSTALADOS > "%REPORT%"
echo Equipo : %COMPUTERNAME% >> "%REPORT%"
echo Usuario: %USERNAME% >> "%REPORT%"
echo Fecha  : %DATE% %TIME% >> "%REPORT%"
echo =============================================== >> "%REPORT%"
echo. >> "%REPORT%"

call :LISTAR_UNINSTALL "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" >> "%REPORT%"
call :LISTAR_UNINSTALL "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" >> "%REPORT%"

if exist "%REPORT%" (
    call :LOG "Reporte de programas generado correctamente"
    echo.
    echo Reporte generado en:
    echo %REPORT%
) else (
    call :LOG "ERROR: No se pudo generar reporte de programas"
    echo ERROR: No se pudo generar el reporte.
)

pause
goto MENU

:TEMA_DEFAULT
cls
call :CONFIRMAR || goto MENU
call :LOG "Restaurando tema e imagen por defecto"

:: Tema claro
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v SystemUsesLightTheme /t REG_DWORD /d 1 /f >nul

:: Fondo por defecto
reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "C:\Windows\Web\Wallpaper\Windows\img0.jpg" /f >nul
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters

call :LOG "Tema restaurado"
echo Tema restaurado correctamente.
pause
goto MENU

:OFFICE
cls
call :CONFIRMAR || goto MENU
call :LOG "Limpieza Microsoft Office"

for %%A in (Word Excel PowerPoint) do (
    reg delete "HKCU\Software\Microsoft\Office\16.0\%%A\File MRU" /f >nul 2>&1
    reg delete "HKCU\Software\Microsoft\Office\16.0\%%A\Place MRU" /f >nul 2>&1
)

reg add "HKCU\Software\Microsoft\Office\16.0\Common" /v UITheme /t REG_DWORD /d 0 /f >nul

call :LOG "Office limpiado"
echo Office limpiado correctamente.
pause
goto MENU

:EXPLORER
cls
call :CONFIRMAR || goto MENU
call :LOG "Limpieza Explorador de archivos"

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v ShowRecent /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v ShowFrequent /t REG_DWORD /d 0 /f >nul

del /f /q "%APPDATA%\Microsoft\Windows\Recent\*" >nul 2>&1
del /f /q "%APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations\*" >nul 2>&1
del /f /q "%APPDATA%\Microsoft\Windows\Recent\CustomDestinations\*" >nul 2>&1

rd /s /q "%APPDATA%\Microsoft\Windows\Network Shortcuts" >nul 2>&1
mkdir "%APPDATA%\Microsoft\Windows\Network Shortcuts" >nul 2>&1

taskkill /f /im explorer.exe >nul
start explorer.exe

call :LOG "Explorador limpiado"
echo Explorador limpiado.
pause
goto MENU

:NORMALIZAR_IDIOMA
cls
call :LOG "Normalizando idioma y carpetas usuario"

:: Chrome idioma
reg add "HKLM\Software\Policies\Google\Chrome" /v AcceptLanguages /t REG_SZ /d es-419 /f >nul
reg add "HKLM\Software\Policies\Google\Chrome" /v DefaultLanguage /t REG_SZ /d es-419 /f >nul

:: Carpetas usuario
call :RENOMBRE "%USERPROFILE%\Desktop" "Escritorio"
call :RENOMBRE "%USERPROFILE%\Documents" "Documentos"
call :RENOMBRE "%USERPROFILE%\Downloads" "Descargas"
call :RENOMBRE "%USERPROFILE%\Pictures" "Imágenes"
call :RENOMBRE "%USERPROFILE%\Music" "Música"
call :RENOMBRE "%USERPROFILE%\Videos" "Vídeos"

:: Recargar explorer
taskkill /f /im explorer.exe >nul
start explorer.exe

call :LOG "Normalizacion aplicada correctamente"
pause
goto MENU

:RENOMBRE
set CARPETA=%~1
set NOMBRE=%~2

attrib -h -s "%CARPETA%\desktop.ini" >nul 2>&1
del "%CARPETA%\desktop.ini" >nul 2>&1

(
echo [.ShellClassInfo]
echo LocalizedResourceName=%NOMBRE%
) > "%CARPETA%\desktop.ini"

attrib +s "%CARPETA%"
attrib +h "%CARPETA%\desktop.ini"
exit /b

:IMAGEN_CORPORATIVA
cls
call :CONFIRMAR || goto MENU
call :LOG "Aplicando imagen corporativa"

:: Fondo de escritorio
reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "%~dp02.jpg" /f >nul
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters

:: Pantalla de bloqueo (requiere admin)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v LockScreenImage /t REG_SZ /d "%~dp01.jpg" /f >nul

call :LOG "Imagen corporativa aplicada (fondo + bloqueo)"

echo.
echo Fondo aplicado inmediatamente.
echo Pantalla de bloqueo requiere cerrar sesion o reiniciar.
pause
goto MENU

:: ============================
:: HARDWARE
:: ============================
:HARDWARE
cls
set HW=%REPORTS%\hardware.txt
(
echo EQUIPO: %EQUIPO%
echo USUARIO: %USUARIO%
systeminfo | findstr /C:"OS Name" /C:"OS Version"
wmic cpu get name
wmic computersystem get TotalPhysicalMemory
wmic logicaldisk get caption,size,freespace
) > "%HW%"
call :LOG "Reporte hardware generado"
echo Reporte hardware creado.
pause
goto MENU

:: ============================
:: SALIDA
:: ============================
:SALIR
echo ==========================================>> "%REPORTS%\reporte_final.txt"
echo Fecha: %DATE% %TIME%>> "%REPORTS%\reporte_final.txt"
type "%LOGFILE%">> "%REPORTS%\reporte_final.txt"
echo Hecho por @guerreroxp para @ecooempresas>> "%REPORTS%\reporte_final.txt"
:LISTAR_UNINSTALL
for /f "delims=" %%K in ('reg query "%~1" 2^>nul') do (
    for /f "skip=2 tokens=*" %%A in ('reg query "%%K" /v DisplayName 2^>nul') do (
        if not "%%A"=="" echo %%A
    )
)
exit /b
exit
