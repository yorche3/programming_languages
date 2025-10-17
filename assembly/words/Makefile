# Compiler and assembler
ASM=nasm
ASM_FLAGS=-f elf64
CC=gcc

# Directories
SRC_DIR=src
TEST_DIR=test
BUILD_DIR=build

# Files
SOURCE_FILES=$(SRC_DIR)/numerical.asm $(SRC_DIR)/words.asm
TEST_FILES=$(TEST_DIR)/test.asm $(TEST_DIR)/numerical_test.asm $(TEST_DIR)/words_test.asm $(TEST_DIR)/run_tests.asm

# Object files
OBJECTS=$(patsubst %.asm,$(BUILD_DIR)/%.o,$(notdir $(SOURCE_FILES) $(TEST_FILES)))

# Default target
all: build run

# Build directory
$(BUILD_DIR):
    mkdir -p $(BUILD_DIR)

# Assemble source files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.asm | $(BUILD_DIR)
    $(ASM) $(ASM_FLAGS) $< -o $@

# Assemble test files
$(BUILD_DIR)/%.o: $(TEST_DIR)/%.asm | $(BUILD_DIR)
    $(ASM) $(ASM_FLAGS) $< -o $@

# Link all object files
build: $(OBJECTS)
    $(CC) $^ -nostartfiles -no-pie -e_start -o $(BUILD_DIR)/run_tests

# Run tests
run: build
    @echo "Running tests..."
    $(BUILD_DIR)/run_tests

# Clean
clean:
    rm -rf $(BUILD_DIR)

.PHONY: all run clean