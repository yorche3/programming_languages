# Create a temporary build directory
$BUILD_DIR = Join-Path $env:TEMP ("build_{0}" -f ([guid]::NewGuid()))
Write-Host "Building in $BUILD_DIR"
New-Item -ItemType Directory -Path $BUILD_DIR | Out-Null

# Assembly commands
$ASM = "nasm"
$ASM_FLAGS = "-f elf64"

# Directories
$SRC_DIR = "src"
$TEST_DIR = "test"

# Source and test files
$SOURCE_FILES = @(
    "$SRC_DIR/numerical.asm",
    "$SRC_DIR/words.asm"
)

$TEST_FILES = @(
    "$TEST_DIR/test.asm",
    "$TEST_DIR/numerical_test.asm",
    "$TEST_DIR/words_test.asm",
    "$TEST_DIR/run_tests.asm"
)

# Assemble source files
foreach ($src in $SOURCE_FILES) {
    $basename = [IO.Path]::GetFileNameWithoutExtension($src)
    & $ASM $ASM_FLAGS $src -o "$BUILD_DIR\$basename.o"
}

# Assemble test files
foreach ($testfile in $TEST_FILES) {
    $basename = [IO.Path]::GetFileNameWithoutExtension($testfile)
    & $ASM $ASM_FLAGS $testfile -o "$BUILD_DIR\$basename.o"
}

# Link all object files
$objs = @(
    "$BUILD_DIR\test.o",
    "$BUILD_DIR\numerical.o",
    "$BUILD_DIR\words.o",
    "$BUILD_DIR\numerical_test.o",
    "$BUILD_DIR\words_test.o",
    "$BUILD_DIR\run_tests.o"
)
& gcc @($objs) -nostartfiles -no-pie -e_start -o "$BUILD_DIR\run_tests.exe"

# Run the executable
Write-Host "Running tests..."
& "$BUILD_DIR\run_tests.exe"

# Cleanup
Remove-Item -Recurse -Force "$BUILD_DIR"