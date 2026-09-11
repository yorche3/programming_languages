.PHONY: all clean

all: test clean

test:
    @echo "Starting Tests..."
    bazel test //:all
    @if [ $$? -ne 0 ]; then \
        echo "Tests failed!"; exit 1; \
    fi

clean:
    @echo "Cleaning project..."
    rm -rf bazel*
    rm -f MODULE.bazel.lock
    @echo "Cleanup completed."