$modules = @("numerical", "words")

foreach ($module in $modules) {
    Write-Output "Adding module '$module'"
    bal add "$module"
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to add '$module' module."
        exit 1
    }
}

Write-Output "Setup completed successfully!"