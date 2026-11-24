COBC ?= cobc
COBFLAGS ?= -x -free -Isrc/copybooks -Itest

SRC_DIR := src/lib
TEST_DIR := test
TARGET := run_tests
SRC_FILES := $(wildcard $(SRC_DIR)/*.cbl) $(wildcard src/*.cbl)
TEST_RUNNER := $(TEST_DIR)/RUN-TESTS.cbl
TEST_FILES := $(wildcard $(TEST_RUNNER)) $(filter-out $(TEST_RUNNER),$(wildcard $(TEST_DIR)/*.cbl))

.PHONY: all build test clean check-runner

all: test

build: $(TARGET)

check-runner:
	@test -f "$(TEST_RUNNER)" || { echo "Test runner is missing: expected $(TEST_RUNNER)."; exit 1; }

$(TARGET): $(TEST_FILES) $(SRC_FILES) | check-runner
	$(COBC) $(COBFLAGS) -o $@ $(TEST_FILES) $(SRC_FILES)

test: build
	./$(TARGET)

clean:
	rm -f $(TARGET) *.so *.dll *.o
	rm -rf target/ build/ dist/
