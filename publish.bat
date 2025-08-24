@echo off
echo Publishing SimplePlatformer for current platform...

REM Call build script first
call build.bat
if %ERRORLEVEL% neq 0 (
    echo Build failed!
    exit /b %ERRORLEVEL%
)

echo Creating self-contained release...
dotnet publish --configuration Release --self-contained true --output ./dist
echo Publish complete! Check the dist folder.