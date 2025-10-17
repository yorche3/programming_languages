#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

echo "Building the project using ninja..."
ninja -C build
if [ $? -ne 0 ]; then
    echo "Build failed."
    exit 1
fi

echo "Running tests..."
./build/test/run_tests
if [ $? -ne 0 ]; then
    echo "Tests failed."
    exit 1
fi

echo "Cleaning up build artifacts..."
rm -rf build

echo "Done."