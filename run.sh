#!/bin/bash
echo "Running SimplePlatformer..."

# Call build script first
./build.sh
if [ $? -ne 0 ]; then
    echo "Build failed!"
    exit 1
fi

echo "Starting game..."
dotnet run --configuration Release --no-build