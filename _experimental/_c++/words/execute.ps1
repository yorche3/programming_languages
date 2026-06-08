Write-Output "Starting Tests..."
bazel test //:all
if ($LASTEXITCODE -ne 0) {
    Write-Output "Tests failed!"
    exit 1
}

Write-Output "Cleaning project..."
Remove-Item -Recurse -Force bazel*
Remove-Item -Force MODULE.bazel.lock

Write-Output "Cleanup completed."