@echo off
echo Publishing SimplePlatformer for current platform...

REM Call build script first
call build.bat
if %ERRORLEVEL% neq 0 (
    echo Build failed!
    exit /b %ERRORLEVEL%
)

echo Creating single-file executable...
dotnet publish --configuration Release --self-contained true -p:PublishSingleFile=true --output ./dist
echo Publish complete! Check the dist folder for your single executable file.