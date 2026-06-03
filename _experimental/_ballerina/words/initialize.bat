@echo off
setlocal enabledelayedexpansion

set modules=numerical words

for %%m in (%modules%) do (
    echo Adding module '%%m'
    bal add "%%m"
    if errorlevel 1 (
        echo Failed to add '%%m' module.
        exit /b 1
    )
)

echo Setup completed successfully!