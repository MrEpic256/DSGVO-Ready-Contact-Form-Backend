# Pre-Push Security Check Script
# Run this before pushing to GitHub to ensure no sensitive data is exposed

Write-Host "`n==== GitHub Pre-Push Security Check ====" -ForegroundColor Cyan
Write-Host ""

$errors = 0
$warnings = 0

# Check 1: Verify .gitignore exists
Write-Host "Check 1: Verifying .gitignore..." -ForegroundColor Yellow
if (Test-Path ".gitignore") {
    Write-Host "[PASS] .gitignore exists" -ForegroundColor Green
} else {
    Write-Host "[FAIL] .gitignore is missing!" -ForegroundColor Red
    $errors++
}

# Check 2: Verify .env is in .gitignore
Write-Host "`nCheck 2: Checking if .env is gitignored..." -ForegroundColor Yellow
if (Get-Content ".gitignore" | Select-String -Pattern "^\.env$") {
    Write-Host "[PASS] .env is in .gitignore" -ForegroundColor Green
} else {
    Write-Host "[FAIL] .env is NOT in .gitignore - SECURITY RISK!" -ForegroundColor Red
    $errors++
}

# Check 3: Verify .env.example exists
Write-Host "`nCheck 3: Checking environment files..." -ForegroundColor Yellow
if (Test-Path ".env.example") {
    Write-Host "[PASS] .env.example exists" -ForegroundColor Green
} else {
    Write-Host "[WARN] .env.example is missing" -ForegroundColor Yellow
    $warnings++
}

# Check 4: Verify node_modules is gitignored
Write-Host "`nCheck 4: Checking if node_modules is gitignored..." -ForegroundColor Yellow
if (Get-Content ".gitignore" | Select-String -Pattern "node_modules") {
    Write-Host "[PASS] node_modules is in .gitignore" -ForegroundColor Green
} else {
    Write-Host "[FAIL] node_modules is NOT in .gitignore!" -ForegroundColor Red
    $errors++
}

# Check 5: Verify README files exist
Write-Host "`nCheck 5: Checking README files..." -ForegroundColor Yellow
$readmeCount = 0
if (Test-Path "README.md") { $readmeCount++ }
if (Test-Path "README.en.md") { $readmeCount++ }
if (Test-Path "README.de.md") { $readmeCount++ }

if ($readmeCount -ge 2) {
    Write-Host "[PASS] Multiple README files available ($readmeCount found)" -ForegroundColor Green
} else {
    Write-Host "[WARN] Only $readmeCount README file(s) found" -ForegroundColor Yellow
    $warnings++
}

# Check 6: Verify LICENSE exists
Write-Host "`nCheck 6: Checking LICENSE file..." -ForegroundColor Yellow
if (Test-Path "LICENSE") {
    Write-Host "[PASS] LICENSE file exists" -ForegroundColor Green
} else {
    Write-Host "[WARN] LICENSE file is missing" -ForegroundColor Yellow
    $warnings++
}

# Summary
Write-Host "`n======================================" -ForegroundColor Cyan
Write-Host "Security Check Summary" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "Errors:   $errors" -ForegroundColor $(if ($errors -eq 0) {"Green"} else {"Red"})
Write-Host "Warnings: $warnings" -ForegroundColor $(if ($warnings -eq 0) {"Green"} else {"Yellow"})
Write-Host ""

if ($errors -eq 0) {
    Write-Host "SUCCESS: Project is safe to push to GitHub!" -ForegroundColor Green
} else {
    Write-Host "CRITICAL: Fix errors before pushing!" -ForegroundColor Red
    exit 1
}

Write-Host ""
