#!/bin/bash

# Create a temporary build directory
BUILD_DIR=$(mktemp -d -t build_XXXX)
echo "Building in $BUILD_DIR"

# Assembly commands
ASM="nasm"
ASM_FLAGS="-f elf64"

# Define directories
SRC_DIR="src"
TEST_DIR="test"

# List of source files to assemble
SOURCE_FILES=(
  "$SRC_DIR/numerical.asm"
  "$SRC_DIR/words.asm"
)

# List of test files to assemble
TEST_FILES=(
  "$TEST_DIR/test.asm"
  "$TEST_DIR/numerical_test.asm"
  "$TEST_DIR/words_test.asm"
  "$TEST_DIR/run_tests.asm"
)

# Assemble source files
for src in "${SOURCE_FILES[@]}"; do
  basename=$(basename "$src" .asm)
  $ASM $ASM_FLAGS "$src" -o "$BUILD_DIR/${basename}.o"
done

# Assemble test files
for testfile in "${TEST_FILES[@]}"; do
  basename=$(basename "$testfile" .asm)
  $ASM $ASM_FLAGS "$testfile" -o "$BUILD_DIR/${basename}.o"
done

# Link all object files into one executable
# Adjust linker flags as needed, e.g., -nostartfiles, -no-pie, -e_start
gcc "$BUILD_DIR/test.o" "$BUILD_DIR/numerical.o" "$BUILD_DIR/words.o" "$BUILD_DIR/numerical_test.o" "$BUILD_DIR/words_test.o"  \
 "$BUILD_DIR/run_tests.o" -nostartfiles -no-pie -e_start -o "$BUILD_DIR/run_tests"

# Run the program
echo "Running tests..."
"$BUILD_DIR/run_tests"

# Cleanup
rm -rf "$BUILD_DIR"