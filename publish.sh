#!/bin/bash
echo "Publishing SimplePlatformer for current platform..."

# Call build script first
./build.sh
if [ $? -ne 0 ]; then
    echo "Build failed!"
    exit 1
fi

echo "Creating single-file executable..."
dotnet publish --configuration Release --self-contained true -p:PublishSingleFile=true --output ./dist
echo "Publish complete! Check the dist folder for your single executable file."