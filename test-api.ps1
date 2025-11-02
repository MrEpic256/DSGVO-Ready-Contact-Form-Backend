# DSGVO Contact Form API Test Script
# Usage: .\test-api.ps1

$baseUrl = "http://localhost:3000"

Write-Host "`n=== DSGVO Contact Form API Test ===" -ForegroundColor Cyan
Write-Host ""

# Test 1: Health Check
Write-Host "Test 1: Server health check..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/health" -Method GET -UseBasicParsing
    Write-Host "✓ Сервер працює!" -ForegroundColor Green
    Write-Host "Відповідь: $($response.Content)" -ForegroundColor Gray
} catch {
    Write-Host "✗ Помилка підключення до сервера" -ForegroundColor Red
    Write-Host "Переконайтесь, що сервер запущено (npm run dev або docker-compose up)" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Тест 2: Відправка форми (з згодою)
Write-Host "Тест 2: Відправка контактної форми (зі згодою)..." -ForegroundColor Yellow
$validBody = @{
    name = "Максим Петренко"
    email = "maksym@example.ua"
    message = "Тестове повідомлення для перевірки DSGVO-сумісності"
    consent_checkbox = $true
} | ConvertTo-Json

try {
    $response = Invoke-WebRequest -Uri "$baseUrl/api/v1/contact/submit" `
        -Method POST `
        -ContentType "application/json" `
        -Body $validBody `
        -UseBasicParsing
    
    Write-Host "✓ Форма успішно відправлена!" -ForegroundColor Green
    Write-Host "Відповідь: $($response.Content)" -ForegroundColor Gray
} catch {
    Write-Host "✗ Помилка: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Тест 3: Відправка форми (БЕЗ згоди - повинно бути відхилено)
Write-Host "Тест 3: Спроба відправити без згоди (очікується помилка)..." -ForegroundColor Yellow
$invalidBody = @{
    name = "Іван Іванов"
    email = "ivan@example.ua"
    message = "Тест без згоди"
    consent_checkbox = $false
} | ConvertTo-Json

try {
    $response = Invoke-WebRequest -Uri "$baseUrl/api/v1/contact/submit" `
        -Method POST `
        -ContentType "application/json" `
        -Body $invalidBody `
        -UseBasicParsing
    
    Write-Host "✗ УВАГА: Форма прийнята без згоди (помилка валідації!)" -ForegroundColor Red
} catch {
    if ($_.Exception.Response.StatusCode -eq 400) {
        Write-Host "✓ Правильно відхилено (HTTP 400)" -ForegroundColor Green
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $errorBody = $reader.ReadToEnd()
        Write-Host "Деталі: $errorBody" -ForegroundColor Gray
    } else {
        Write-Host "✗ Неочікувана помилка: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""

# Тест 4: Неправильний email
Write-Host "Тест 4: Неправильний формат email (очікується помилка)..." -ForegroundColor Yellow
$badEmailBody = @{
    name = "Тест Користувач"
    email = "не-email"
    message = "Тестове повідомлення"
    consent_checkbox = $true
} | ConvertTo-Json

try {
    $response = Invoke-WebRequest -Uri "$baseUrl/api/v1/contact/submit" `
        -Method POST `
        -ContentType "application/json" `
        -Body $badEmailBody `
        -UseBasicParsing
    
    Write-Host "✗ УВАГА: Прийнято неправильний email!" -ForegroundColor Red
} catch {
    if ($_.Exception.Response.StatusCode -eq 400) {
        Write-Host "✓ Правильно відхилено неправильний email" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "=== Тестування завершено ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Адмін ендпоінти (потребують x-admin-key в заголовку):" -ForegroundColor Yellow
Write-Host "  DELETE $baseUrl/api/v1/contact/delete/{email}" -ForegroundColor Gray
Write-Host "  POST   $baseUrl/api/v1/contact/cleanup" -ForegroundColor Gray
Write-Host ""
