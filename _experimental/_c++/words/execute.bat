@echo off
echo Starting Tests...
bazel test //:all
if %errorlevel% neq 0 (
    echo Tests failed!
    exit /b 1
)

echo Cleaning project...
rmdir /s /q bazel*
del /f /q MODULE.bazel.lock

echo Cleanup completed.