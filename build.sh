#!/bin/bash

# Check if build already exists - if so, SDK must be installed
if [[ -f "bin/Release/net6.0/SimplePlatformer.dll" ]]; then
    echo "Build exists, skipping SDK check..."
    goto_build_project=true
else
    goto_build_project=false
fi

if [[ "$goto_build_project" == "false" ]]; then
    echo "Checking for .NET SDK..."

# Make sure dotnet is in PATH if it exists in ~/.dotnet (common on macOS)
if [[ "$OSTYPE" == "darwin"* ]] && [[ -d "$HOME/.dotnet" ]] && ! command -v dotnet &> /dev/null; then
    export PATH="$HOME/.dotnet:$PATH"
fi

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
            # Use Homebrew if available (supports both Intel and Apple Silicon)
            brew install --cask dotnet-sdk
        else
            # Use Microsoft's official installer script
            echo "Downloading and running Microsoft's .NET installer script..."
            curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --channel 8.0
            
            # Add dotnet to PATH for current session
            export PATH="$HOME/.dotnet:$PATH"
            
            echo "Note: You may need to add ~/.dotnet to your PATH permanently:"
            echo "echo 'export PATH=\"\$HOME/.dotnet:\$PATH\"' >> ~/.bashrc"
            echo "echo 'export PATH=\"\$HOME/.dotnet:\$PATH\"' >> ~/.zshrc"
        fi
    else
        echo "Unsupported OS. Please install .NET SDK manually:"
        echo "https://dotnet.microsoft.com/download/dotnet"
        exit 1
    fi
    
    # Verify installation
    # Make sure dotnet is in PATH (for cases where it was installed to ~/.dotnet)
    if [[ "$OSTYPE" == "darwin"* ]] && [[ -d "$HOME/.dotnet" ]] && ! command -v dotnet &> /dev/null; then
        export PATH="$HOME/.dotnet:$PATH"
    fi
    
    if ! command -v dotnet &> /dev/null || ! dotnet --list-sdks | grep -E "^[6-9]\." &> /dev/null; then
        echo "Failed to install compatible .NET SDK. Please install manually:"
        echo "https://dotnet.microsoft.com/download/dotnet"
        exit 1
    fi
    
    echo ".NET SDK installed successfully!"
else
    echo "Compatible .NET SDK found!"
fi
fi

echo "Building SimplePlatformer..."
dotnet restore
dotnet build --configuration Release
echo "Build complete!"