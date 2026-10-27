CC ?= gcc
CFLAGS ?= -Wall -Wextra -std=c99 -Iinclude
CRITERION_CFLAGS ?= $(shell pkg-config --cflags criterion)
CRITERION_LIBS ?= $(shell pkg-config --libs criterion)

SRC_DIR := src
TEST_DIR := test
OBJ_DIR := obj
BIN_DIR := bin
TEST_BIN := $(BIN_DIR)/run_tests

SRC_FILES := $(wildcard $(SRC_DIR)/*.c)
TEST_FILES := $(wildcard $(TEST_DIR)/*.c)
SRC_OBJECTS := $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/src_%.o,$(SRC_FILES))
TEST_OBJECTS := $(patsubst $(TEST_DIR)/%.c,$(OBJ_DIR)/test_%.o,$(TEST_FILES))

.PHONY: all build test clean

all: test

build: $(TEST_BIN)

test: $(TEST_BIN)
	./$(TEST_BIN)

$(OBJ_DIR) $(BIN_DIR):
	mkdir -p $@

$(OBJ_DIR)/src_%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) $(CRITERION_CFLAGS) -c -o $@ $<

$(OBJ_DIR)/test_%.o: $(TEST_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) $(CRITERION_CFLAGS) -c -o $@ $<

$(TEST_BIN): $(SRC_OBJECTS) $(TEST_OBJECTS) | $(BIN_DIR)
	$(CC) $(CFLAGS) -o $@ $^ $(CRITERION_LIBS)

clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)
