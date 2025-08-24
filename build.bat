@echo off

REM Check if build already exists - if so, SDK must be installed
if exist "bin\Release\net6.0\SimplePlatformer.dll" (
    echo Build exists, skipping SDK check...
    goto build_project
)

echo Checking for .NET SDK...

REM Check if dotnet is installed
dotnet --version >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo .NET SDK not found. Attempting to install .NET 8...
    goto install_dotnet
)

REM Check for .NET 6+ SDK
for /f "delims=" %%i in ('dotnet --list-sdks') do (
    echo %%i | findstr /R "^[6-9]\." >nul 2>&1
    if %ERRORLEVEL% equ 0 (
        goto sdk_found
    )
)

echo Compatible .NET SDK not found (need 6.0+). Attempting to install .NET 8...

:install_dotnet
REM Download and install .NET 8 SDK (latest LTS)
echo Downloading .NET 8 SDK installer...
powershell -Command "& {Invoke-WebRequest -Uri 'https://download.visualstudio.microsoft.com/download/pr/6f043b39-b3d2-4f0a-92bd-99408739c98d/fa16213ea5d6464fa9138142ea1a3446/dotnet-sdk-8.0.407-win-x64.exe' -OutFile '%TEMP%\dotnet-sdk-installer.exe'}"

if exist "%TEMP%\dotnet-sdk-installer.exe" (
    echo Installing .NET SDK...
    "%TEMP%\dotnet-sdk-installer.exe" /quiet /norestart
    if %ERRORLEVEL% neq 0 (
        echo Failed to install .NET SDK automatically.
        echo Please download and install .NET SDK from: https://dotnet.microsoft.com/download/dotnet
        pause
        exit /b 1
    )
    echo .NET SDK installed successfully!
    del "%TEMP%\dotnet-sdk-installer.exe"
) else (
    echo Failed to download .NET SDK installer.
    echo Please download and install .NET SDK from: https://dotnet.microsoft.com/download/dotnet
    pause
    exit /b 1
)

:sdk_found
echo Compatible .NET SDK found!

:build_project
echo Building SimplePlatformer...
dotnet restore
dotnet build --configuration Release
echo Build complete!