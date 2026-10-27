COBC ?= cobc
COBFLAGS ?= -x -free -Isrc/copybooks -Itest

SRC_DIR := src/lib
TEST_DIR := test
TARGET := run_tests
SRC_FILES := $(wildcard $(SRC_DIR)/*.cbl) $(wildcard src/*.cbl)
TEST_FILES := $(wildcard $(TEST_DIR)/*.cbl)

.PHONY: all build test clean

all: test

build: $(TARGET)

$(TARGET): $(TEST_FILES) $(SRC_FILES)
	@test -n "$(TEST_FILES)" || { echo "Test runner is missing: expected $(TEST_DIR)/*.cbl."; exit 1; }
	$(COBC) $(COBFLAGS) -o $@ $(TEST_FILES) $(SRC_FILES)

test: build
	./$(TARGET)

clean:
	rm -f $(TARGET) *.so *.dll *.o
	rm -rf target/ build/ dist/
