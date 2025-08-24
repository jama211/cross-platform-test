@echo off
echo Cleaning SimplePlatformer build artifacts...

REM Remove build output directories
if exist "bin" (
    echo Removing bin directory...
    rmdir /s /q "bin"
)

if exist "obj" (
    echo Removing obj directory...
    rmdir /s /q "obj"
)

if exist "dist" (
    echo Removing dist directory...
    rmdir /s /q "dist"
)

if exist "dist-framework" (
    echo Removing dist-framework directory...
    rmdir /s /q "dist-framework"
)

echo Clean complete! Next build will be completely fresh.
