@echo off
setlocal

set "ROOT=%~dp0.."
set "BACKEND=%ROOT%\services\backend"
set "DASHBOARD=%ROOT%\apps\dashboard"
set "NPM_CMD="

if not exist "%BACKEND%\.venv\Scripts\python.exe" (
  echo Backend virtual environment is missing. Run scripts\setup-all.cmd first.
  exit /b 1
)

for /f "delims=" %%I in ('where npm.cmd 2^>nul') do if not defined NPM_CMD set "NPM_CMD=%%I"
if not defined NPM_CMD if exist "C:\Program Files\nodejs\npm.cmd" set "NPM_CMD=C:\Program Files\nodejs\npm.cmd"
if not defined NPM_CMD (
  echo npm was not found on PATH. Install Node.js 20+ or add npm to PATH.
  exit /b 1
)
for %%I in ("%NPM_CMD%") do set "NODE_DIR=%%~dpI"

pushd "%BACKEND%" || exit /b 1
call ".venv\Scripts\python.exe" -m pytest || exit /b %errorlevel%
popd

set "PATH=%NODE_DIR%;%PATH%"
pushd "%DASHBOARD%" || exit /b 1
call "%NPM_CMD%" run lint || exit /b %errorlevel%
call "%NPM_CMD%" run test || exit /b %errorlevel%
call "%NPM_CMD%" run build || exit /b %errorlevel%
popd

echo NEXUS-RESOLVE checks passed.
