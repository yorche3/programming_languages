Write-Output "Building the project using ninja..."
ninja -C build
if ($LASTEXITCODE -ne 0) {
    Write-Output "Build failed."
    exit 1
}

Write-Output "Running tests..."
& .\build\test\run_tests.exe
if ($LASTEXITCODE -ne 0) {
    Write-Output "Tests failed."
    exit 1
}

Write-Output "Cleaning up build artifacts..."
Remove-Item -Recurse -Force build

Write-Output "Done."