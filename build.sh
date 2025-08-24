#!/bin/bash
echo "Checking for .NET SDK..."

# Check if dotnet is installed and supports .NET 6+
if ! command -v dotnet &> /dev/null; then
    echo ".NET SDK not found. Attempting to install..."
elif ! dotnet --list-sdks | grep -E "^[6-9]\." &> /dev/null; then
    echo "Compatible .NET SDK not found (need 6.0+). Attempting to install..."
    
    # Detect OS
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        echo "Detected Linux. Installing .NET 8 SDK..."
        
        # Try to detect package manager and install
        if command -v apt-get &> /dev/null; then
            # Ubuntu/Debian
            wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
            sudo dpkg -i packages-microsoft-prod.deb
            rm packages-microsoft-prod.deb
            sudo apt-get update
            sudo apt-get install -y dotnet-sdk-8.0
        elif command -v yum &> /dev/null; then
            # RHEL/CentOS/Fedora
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            sudo wget -O /etc/yum.repos.d/microsoft-prod.repo https://packages.microsoft.com/config/rhel/8/prod.repo
            sudo yum install -y dotnet-sdk-8.0
        elif command -v pacman &> /dev/null; then
            # Arch Linux
            sudo pacman -S dotnet-sdk-8.0
        else
            echo "Could not detect package manager. Please install .NET SDK manually:"
            echo "https://dotnet.microsoft.com/download/dotnet"
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        echo "Detected macOS. Installing .NET 8 SDK..."
        
        if command -v brew &> /dev/null; then
            # Use Homebrew if available
            brew install --cask dotnet-sdk
        else
            # Download and install manually
            echo "Downloading .NET 8 SDK for macOS..."
            curl -L https://download.microsoft.com/download/8/3/0/83066c35-4216-4ac6-a866-a46570de2c3c/dotnet-sdk-8.0.406-osx-x64.pkg -o /tmp/dotnet-sdk.pkg
            sudo installer -pkg /tmp/dotnet-sdk.pkg -target /
            rm /tmp/dotnet-sdk.pkg
        fi
    else
        echo "Unsupported OS. Please install .NET SDK manually:"
        echo "https://dotnet.microsoft.com/download/dotnet"
        exit 1
    fi
    
    # Verify installation
    if ! command -v dotnet &> /dev/null || ! dotnet --list-sdks | grep -E "^[6-9]\." &> /dev/null; then
        echo "Failed to install compatible .NET SDK. Please install manually:"
        echo "https://dotnet.microsoft.com/download/dotnet"
        exit 1
    fi
    
    echo ".NET SDK installed successfully!"
else
    echo "Compatible .NET SDK found!"
fi

echo "Building SimplePlatformer..."
dotnet restore
dotnet build --configuration Release
echo "Build complete!"