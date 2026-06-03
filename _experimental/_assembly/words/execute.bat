@echo off
REM Create temporary build directory
setlocal enabledelayedexpansion
set "BUILD_DIR=%TEMP%\build_%RANDOM%"
echo Building in %BUILD_DIR%
mkdir "%BUILD_DIR%"

REM Assembly commands
set ASM=nasm
set ASM_FLAGS=-f elf64

REM Source directories
set SRC_DIR=src
set TEST_DIR=test

REM List of source files
set SOURCES=%SRC_DIR%\numerical.asm %SRC_DIR%\words.asm

REM List of test files
set TESTS=%TEST_DIR%\test.asm %TEST_DIR%\numerical_test.asm %TEST_DIR%\words_test.asm %TEST_DIR%\run_tests.asm

REM Assemble source files
for %%f in (%SOURCES%) do (
    set BASENAME=%%~nf
    %ASM% %ASM_FLAGS% %%f -o "%BUILD_DIR%\!BASENAME!.o"
)

REM Assemble test files
for %%f in (%TESTS%) do (
    set BASENAME=%%~nf
    %ASM% %ASM_FLAGS% %%f -o "%BUILD_DIR%\!BASENAME!.o"
)

REM Link all object files into one executable
gcc "%BUILD_DIR%\test.o" "%BUILD_DIR%\numerical.o" "%BUILD_DIR%\words.o" "%BUILD_DIR%\numerical_test.o" "%BUILD_DIR%\words_test.o" "%BUILD_DIR%\run_tests.o" -nostartfiles -no-pie -e_start -o "%BUILD_DIR%\run_tests.exe"

REM Run the program
echo Running tests...
"%BUILD_DIR%\run_tests.exe"

REM Cleanup
rd /s /q "%BUILD_DIR%"