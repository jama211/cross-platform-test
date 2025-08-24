@echo off
echo Running SimplePlatformer...

REM Call build script first
call build.bat
if %ERRORLEVEL% neq 0 (
    echo Build failed!
    exit /b %ERRORLEVEL%
)

echo Starting game...
dotnet run --configuration Release --no-build