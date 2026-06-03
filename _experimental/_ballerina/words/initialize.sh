#!/bin/bash

set -e  # Exit on any error

# List of module names
modules=("numerical" "words")

# Loop through each module name and run bal add
for module in "${modules[@]}"
do
  echo "Adding module '$module'"
  bal add "$module"
  if [ $? -ne 0 ]; then
    echo "Failed to add '$module' module."
    exit 1
  fi
done

echo "Setup completed successfully!"