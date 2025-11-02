# DSGVO Contact Form API Test Script
# Usage: .\test-api-simple.ps1

$baseUrl = "http://localhost:3000"

Write-Host "`n=== DSGVO Contact Form API Test ===" -ForegroundColor Cyan
Write-Host ""

# Test 1: Health Check
Write-Host "Test 1: Server health check..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/health" -Method GET -UseBasicParsing
    Write-Host "[PASS] Server is running!" -ForegroundColor Green
    Write-Host "Response: $($response.Content)" -ForegroundColor Gray
} catch {
    Write-Host "[FAIL] Cannot connect to server" -ForegroundColor Red
    Write-Host "Make sure server is running: npm run dev OR docker-compose up" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Test 2: Submit form WITH consent (should succeed)
Write-Host "Test 2: Submit contact form with consent..." -ForegroundColor Yellow
$validBody = @{
    name = "Maksym Petrenko"
    email = "maksym@example.ua"
    message = "Test message for DSGVO compliance check"
    consent_checkbox = $true
} | ConvertTo-Json

try {
    $response = Invoke-WebRequest -Uri "$baseUrl/api/v1/contact/submit" `
        -Method POST `
        -ContentType "application/json" `
        -Body $validBody `
        -UseBasicParsing
    
    Write-Host "[PASS] Form submitted successfully!" -ForegroundColor Green
    Write-Host "Response: $($response.Content)" -ForegroundColor Gray
} catch {
    Write-Host "[FAIL] Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Test 3: Submit form WITHOUT consent (should be rejected)
Write-Host "Test 3: Submit without consent (should be rejected)..." -ForegroundColor Yellow
$invalidBody = @{
    name = "Ivan Ivanov"
    email = "ivan@example.ua"
    message = "Test without consent"
    consent_checkbox = $false
} | ConvertTo-Json

try {
    $response = Invoke-WebRequest -Uri "$baseUrl/api/v1/contact/submit" `
        -Method POST `
        -ContentType "application/json" `
        -Body $invalidBody `
        -UseBasicParsing
    
    Write-Host "[FAIL] Form accepted without consent - validation error!" -ForegroundColor Red
} catch {
    if ($_.Exception.Response.StatusCode -eq 400) {
        Write-Host "[PASS] Correctly rejected (HTTP 400)" -ForegroundColor Green
    } else {
        Write-Host "[FAIL] Unexpected error: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""

# Test 4: Invalid email format
Write-Host "Test 4: Invalid email format (should be rejected)..." -ForegroundColor Yellow
$badEmailBody = @{
    name = "Test User"
    email = "not-an-email"
    message = "Test message"
    consent_checkbox = $true
} | ConvertTo-Json

try {
    $response = Invoke-WebRequest -Uri "$baseUrl/api/v1/contact/submit" `
        -Method POST `
        -ContentType "application/json" `
        -Body $badEmailBody `
        -UseBasicParsing
    
    Write-Host "[FAIL] Invalid email was accepted!" -ForegroundColor Red
} catch {
    if ($_.Exception.Response.StatusCode -eq 400) {
        Write-Host "[PASS] Invalid email correctly rejected" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "=== Test Complete ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Admin endpoints (require x-admin-key header):" -ForegroundColor Yellow
Write-Host "  DELETE $baseUrl/api/v1/contact/delete/{email}" -ForegroundColor Gray
Write-Host "  POST   $baseUrl/api/v1/contact/cleanup" -ForegroundColor Gray
Write-Host ""
