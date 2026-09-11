.PHONY: all clean

all: build test clean

build:
    @echo Building the project using ninja...
    @ninja -C build
    @if [ $$? -ne 0 ]; then \
        echo "Build failed."; \
        exit 1; \
    fi

test:
    @echo Running tests...
    @./build/test/run_tests
    @if [ $$? -ne 0 ]; then \
        echo "Tests failed."; \
        exit 1; \
    fi

clean:
    @echo Cleaning up build artifacts...
    @rm -rf build