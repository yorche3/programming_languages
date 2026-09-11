#!/bin/bash

# List of module names
modules=("numbers_recursive" "numbers_iterative")

# Loop through each module name and run bal add
for module in "${modules[@]}"
do
  bal add "$module"
done