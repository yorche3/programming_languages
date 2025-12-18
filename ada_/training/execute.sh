#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

PROJECT_FILE="test.gpr"
BUILD_DIR="obj"
TEST_EXEC="test_runner"

echo "Building project..."
gprbuild -p -P "$PROJECT_FILE"

if [ -f "./$TEST_EXEC" ]; then
    echo "Running tests..."
    "./$TEST_EXEC"
else
    echo "Error: $TEST_EXEC not found."
    exit 1
fi

echo "Cleaning build artifacts..."
find obj -type f -delete
rm -f "$TEST_EXEC"

echo "Done."