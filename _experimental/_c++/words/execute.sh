#!/bin/bash

echo "Starting Tests..."
bazel test //:all
if [ $? -ne 0 ]; then
    echo "Tests failed!"
    exit 1
fi

echo "Cleaning project..."
rm -rf bazel*
rm -f MODULE.bazel.lock

echo "Cleanup completed."