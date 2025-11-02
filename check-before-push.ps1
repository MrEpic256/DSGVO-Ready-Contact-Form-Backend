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

# Check 3: Verify .env.example exists (but not .env)
Write-Host "`nCheck 3: Checking environment files..." -ForegroundColor Yellow
if (Test-Path ".env.example") {
    Write-Host "[PASS] .env.example exists" -ForegroundColor Green
} else {
    Write-Host "[WARN] .env.example is missing" -ForegroundColor Yellow
    $warnings++
}

if (Test-Path ".env") {
    Write-Host "[WARN] .env file exists (make sure it's gitignored)" -ForegroundColor Yellow
} else {
    Write-Host "[INFO] .env file not found (will be created by users)" -ForegroundColor Gray
}

# Check 4: Verify node_modules is gitignored
Write-Host "`nCheck 4: Checking if node_modules is gitignored..." -ForegroundColor Yellow
if (Get-Content ".gitignore" | Select-String -Pattern "node_modules") {
    Write-Host "[PASS] node_modules is in .gitignore" -ForegroundColor Green
} else {
    Write-Host "[FAIL] node_modules is NOT in .gitignore!" -ForegroundColor Red
    $errors++
}

# Check 5: Search for potential secrets in .env.example
Write-Host "`nCheck 5: Scanning .env.example for real passwords..." -ForegroundColor Yellow
$envExample = Get-Content ".env.example" -Raw
if ($envExample -match "(?i)(password|key)=(?!your_|change_|example_|secure_|postgres$)[a-zA-Z0-9]{8,}") {
    Write-Host "[WARN] Potential real password/key found in .env.example!" -ForegroundColor Yellow
    Write-Host "       Make sure all values are placeholders" -ForegroundColor Yellow
    $warnings++
} else {
    Write-Host "[PASS] No real passwords detected in .env.example" -ForegroundColor Green
}

# Check 6: Verify README files exist
Write-Host "`nCheck 6: Checking README files..." -ForegroundColor Yellow
$readmeCount = 0
if (Test-Path "README.md") { $readmeCount++; Write-Host "[OK] README.md found" -ForegroundColor Gray }
if (Test-Path "README.en.md") { $readmeCount++; Write-Host "[OK] README.en.md found" -ForegroundColor Gray }
if (Test-Path "README.de.md") { $readmeCount++; Write-Host "[OK] README.de.md found" -ForegroundColor Gray }

if ($readmeCount -ge 2) {
    Write-Host "[PASS] Multiple README files available" -ForegroundColor Green
} else {
    Write-Host "[WARN] Only $readmeCount README file(s) found" -ForegroundColor Yellow
    $warnings++
}

# Check 7: Verify LICENSE exists
Write-Host "`nCheck 7: Checking LICENSE file..." -ForegroundColor Yellow
if (Test-Path "LICENSE") {
    Write-Host "[PASS] LICENSE file exists" -ForegroundColor Green
} else {
    Write-Host "[WARN] LICENSE file is missing" -ForegroundColor Yellow
    $warnings++
}

# Check 8: Verify package.json exists
Write-Host "`nCheck 8: Checking package.json..." -ForegroundColor Yellow
if (Test-Path "package.json") {
    Write-Host "[PASS] package.json exists" -ForegroundColor Green
} else {
    Write-Host "[FAIL] package.json is missing!" -ForegroundColor Red
    $errors++
}

# Check 9: Check for common sensitive files
Write-Host "`nCheck 9: Scanning for sensitive files..." -ForegroundColor Yellow
$sensitiveFiles = @("id_rsa", "id_rsa.pub", "*.pem", "*.key", ".env.production", ".env.local")
$foundSensitive = $false
foreach ($pattern in $sensitiveFiles) {
    if (Get-ChildItem -Path . -Filter $pattern -Recurse -ErrorAction SilentlyContinue) {
        Write-Host "[WARN] Found sensitive file: $pattern" -ForegroundColor Yellow
        $foundSensitive = $true
        $warnings++
    }
}
if (-not $foundSensitive) {
    Write-Host "[PASS] No sensitive files detected" -ForegroundColor Green
}

# Summary
Write-Host "`n======================================" -ForegroundColor Cyan
Write-Host "Security Check Summary" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "Errors:   $errors" -ForegroundColor $(if ($errors -eq 0) {"Green"} else {"Red"})
Write-Host "Warnings: $warnings" -ForegroundColor $(if ($warnings -eq 0) {"Green"} else {"Yellow"})
Write-Host ""

if ($errors -eq 0) {
    Write-Host "✓ Project is safe to push to GitHub!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "  1. git init" -ForegroundColor Gray
    Write-Host "  2. git add ." -ForegroundColor Gray
    Write-Host "  3. git commit -m `"Initial commit: DSGVO-compliant contact form backend`"" -ForegroundColor Gray
    Write-Host "  4. git remote add origin https://github.com/YOUR_USERNAME/dsgvo-contact-backend.git" -ForegroundColor Gray
    Write-Host "  5. git branch -M main" -ForegroundColor Gray
    Write-Host "  6. git push -u origin main" -ForegroundColor Gray
    Write-Host ""
} else {
    Write-Host "✗ CRITICAL: Fix errors before pushing!" -ForegroundColor Red
    Write-Host ""
    exit 1
}

if ($warnings -gt 0) {
    Write-Host "Note: Please review warnings above" -ForegroundColor Yellow
}

Write-Host ""
