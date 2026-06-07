#!/bin/bash

set -e  # Exit on any error

# Define arrays for projects
LIB_PROJECTS=("NumbersRecursive" "NumbersIterative")
TEST_PROJECTS=("NumbersRecursiveTest" "NumbersIterativeTest")

echo "Creating solution 'NumbersSolution'..."
dotnet new sln -n NumbersSolution
if [ $? -ne 0 ]; then
  echo "Failed to create solution."
  exit 1
fi

echo "Creating 'src' directory..."
mkdir -p src
cd src

# Loop through library projects to create class libs
for project in "${LIB_PROJECTS[@]}"; do
  echo "Creating class library '$project'..."
  dotnet new classlib -n $project
  if [ $? -ne 0 ]; then
    echo "Failed to create '$project' class library."
    exit 1
  fi
done

# Return to project directory
cd ..

# Create 'test' directory
echo "Creating 'test' directory..."
mkdir -p test
cd test

# Loop through test projects to create MSTest projects
for test_project in "${TEST_PROJECTS[@]}"; do
  echo "Creating XUnit project '$test_project'..."
  dotnet new xunit -n $test_project
  if [ $? -ne 0 ]; then
    echo "Failed to create '$test_project'."
    exit 1
  fi
done

# Add project references to test projects
for i in "${!TEST_PROJECTS[@]}"; do
  test_proj="${TEST_PROJECTS[$i]}"
  lib_proj="${LIB_PROJECTS[$i]}"
  echo "Adding reference from '$test_proj' to '$lib_proj'..."
  dotnet add ../src/$lib_proj/$lib_proj.csproj reference ../src/$lib_proj/$lib_proj.csproj
  if [ $? -ne 0 ]; then
    echo "Failed to add reference from '$test_proj' to '$lib_proj'."
    exit 1
  fi
done

# Return to project directory
cd ..

# Add all projects to the solution
for project in "${LIB_PROJECTS[@]}"; do
  echo "Adding '$project' to solution..."
  dotnet sln ../NumbersSolution.sln add src/$project/$project.csproj
  if [ $? -ne 0 ]; then
    echo "Failed to add '$project' to solution."
    exit 1
  fi
done

for test_project in "${TEST_PROJECTS[@]}"; do
  echo "Adding '$test_project' to solution..."
  dotnet sln ../NumbersSolution.sln add test/$test_project/$test_project.csproj
  if [ $? -ne 0 ]; then
    echo "Failed to add '$test_project' to solution."
    exit 1
  fi
done

echo "Setup completed successfully!"