@echo off
setlocal EnableDelayedExpansion

REM ╭──────────────────────────────╮
REM │  Настройки                   │
REM ╰──────────────────────────────╯
set "MOD_MANAGER=%USERPROFILE%\TTSModManager\TTSModManager.exe"
set "CONFIG_FILE=config.json"
set "OUTPUT_DIR=saves"

REM ╭──────────────────────────────╮
REM │  Перевірка jq                │
REM ╰──────────────────────────────╯
where jq >nul 2>nul
if errorlevel 1 (
    echo ❌ jq не знайдено. Встанови з: https://jqlang.github.io/jq/download/
    exit /b 1
)

REM ╭──────────────────────────────╮
REM │  Перевірка файлів            │
REM ╰──────────────────────────────╯
if not exist "%MOD_MANAGER%" (
    echo ❌ TTSModManager не знайдено за шляхом: %MOD_MANAGER%
    exit /b 1
)

if not exist "%CONFIG_FILE%" (
    echo ❌ config.json не знайдено
    exit /b 1
)

REM ╭──────────────────────────────╮
REM │  Зчитування SaveName з jq    │
REM ╰──────────────────────────────╯
for /f %%i in ('jq -r ".SaveName" "%CONFIG_FILE%"') do set SAVENAME=%%i

if "%SAVENAME%"=="" (
    echo ❌ SaveName відсутній або порожній у config.json
    exit /b 1
)

set "OUTPUT_FILE=AH %SAVENAME%.json"
set "OUTPUT_PATH=%OUTPUT_DIR%\%OUTPUT_FILE%"

REM ╭──────────────────────────────╮
REM │  Створити папку якщо треба   │
REM ╰──────────────────────────────╯
if not exist "%OUTPUT_DIR%" (
    mkdir "%OUTPUT_DIR%"
)

REM ╭──────────────────────────────╮
REM │  Перевірка на існування      │
REM ╰──────────────────────────────╯
if exist "%OUTPUT_PATH%" (
    echo ❌ Файл уже існує: %OUTPUT_PATH%
    exit /b 1
)

REM ╭──────────────────────────────╮
REM │  Запуск генерації            │
REM ╰──────────────────────────────╯
echo ℹ️ Генерується мод з SaveName: %SAVENAME%
"%MOD_MANAGER%" --moddir="." --modfile="%OUTPUT_PATH%"

echo ✅ Save generated: %OUTPUT_PATH%
exit /b 0
