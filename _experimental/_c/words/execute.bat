@echo off
echo Building the project using ninja...
ninja -C build
if %ERRORLEVEL% NEQ 0 (
    echo Build failed.
    exit /b 1
)

echo Running tests...
call .\build\test\run_tests.exe
if %ERRORLEVEL% NEQ 0 (
    echo Tests failed.
    exit /b 1
)

echo Cleaning up build artifacts...
rmdir /s /q build

echo Done.