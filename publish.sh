#!/bin/bash
echo "Publishing SimplePlatformer for current platform..."

# Call build script first
./build.sh
if [ $? -ne 0 ]; then
    echo "Build failed!"
    exit 1
fi

echo "Creating self-contained release..."
dotnet publish --configuration Release --self-contained true --output ./dist
echo "Publish complete! Check the dist folder."