#!/bin/bash
echo "Cleaning SimplePlatformer build artifacts..."

# Remove build output directories
if [[ -d "bin" ]]; then
    echo "Removing bin directory..."
    rm -rf bin
fi

if [[ -d "obj" ]]; then
    echo "Removing obj directory..."
    rm -rf obj
fi

if [[ -d "dist" ]]; then
    echo "Removing dist directory..."
    rm -rf dist
fi

if [[ -d "dist-framework" ]]; then
    echo "Removing dist-framework directory..."
    rm -rf dist-framework
fi

echo "Clean complete! Next build will be completely fresh."
