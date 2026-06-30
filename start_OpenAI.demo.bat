@echo off
setlocal

cd /d "%~dp0" || exit /b 1

if /I "%~1"=="--dry-run" (
  call "%~dp0start_demo.bat" --dry-run
  exit /b %errorlevel%
)

call "%~dp0start_demo.bat" --openai
exit /b %errorlevel%
