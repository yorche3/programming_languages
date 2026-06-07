#!/bin/bash

set -e  # Exit on any error

# Define arrays for projects
LIB_PROJECTS=("Numerical" "Words")
TEST_PROJECTS=("NumericalTest" "WordsTest")

echo "Running test..."
dotnet test

echo "Cleanning project..."
# Add all projects to the solution
for project in "${LIB_PROJECTS[@]}"; do
  echo "Removing '$project' files..."
  rm -rf src/$project/bin
  if [ $? -ne 0 ]; then
    echo "Failed removing '$project'/bin"
    exit 1
  fi
  rm -rf src/$project/obj/Debug
  if [ $? -ne 0 ]; then
    echo "Failed removing '$project'/obj/Debug"
    exit 1
  fi
done

for test_project in "${TEST_PROJECTS[@]}"; do
  echo "Removing '$test_project' files..."
  rm -rf test/$test_project/bin
  if [ $? -ne 0 ]; then
    echo "Failed removing '$test_project'/bin"
    exit 1
  fi
  rm -rf test/$test_project/obj/Debug
  if [ $? -ne 0 ]; then
    echo "Failed removing '$test_project'/obj/Debug"
    exit 1
  fi
done

echo "Cleanning completed successfully!"