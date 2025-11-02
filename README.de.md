# 🔒 DSGVO-Konformes Kontaktformular Backend

[![TypeScript](https://img.shields.io/badge/TypeScript-5.3-blue.svg)](https://www.typescriptlang.org/)
[![Node.js](https://img.shields.io/badge/Node.js-20-green.svg)](https://nodejs.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-blue.svg)](https://www.postgresql.org/)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED.svg)](https://www.docker.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

> **Deutsche Version | [English Version](README.en.md)**

Ein produktionsreifer, rechtssicherer Backend-Service zur Verarbeitung von Kontaktformular-Daten mit **strenger DSGVO-Konformität**. Speziell entwickelt für deutsche Kunden, die Wert auf Datenschutz und rechtliche Sicherheit legen.

## 📑 Inhaltsverzeichnis

- [Funktionen](#-funktionen)
- [DSGVO-Konformität](#-dsgvo-konformität)
- [Technologie-Stack](#-technologie-stack)
- [Schnellstart](#-schnellstart)
- [API-Dokumentation](#-api-dokumentation)
- [Docker-Deployment](#-docker-deployment)
- [Sicherheit](#-sicherheit)
- [Lizenz](#-lizenz)

## ✨ Funktionen

- ✅ **Vollständige DSGVO-Konformität** mit expliziter Einwilligungsvalidierung
- ✅ **IP-Adressen-Anonymisierung** (Entfernung des letzten Oktetts vor Speicherung)
- ✅ **Recht auf Vergessenwerden** (Art. 17 DSGVO) implementiert
- ✅ **Automatisierte Datenlöschung** mit konfigurierbarer Aufbewahrungsfrist (Standard: 6 Monate)
- ✅ **Datenminimierung** - nur essenzielle Daten werden gespeichert
- ✅ **SQL-Injection-Schutz** durch parametrisierte Abfragen
- ✅ **Eingabevalidierung & Sanitization** mit express-validator
- ✅ **Admin-geschützte Endpunkte** mit API-Schlüssel-Authentifizierung
- ✅ **Docker-Containerisierung** für einfache Bereitstellung
- ✅ **Umfassendes Audit-Logging** aller Operationen
- ✅ **Health-Check-Endpunkte** für Monitoring

## 🇪🇺 DSGVO-Konformität

Dieser Service implementiert folgende DSGVO-Grundsätze:

### Wichtigste Compliance-Features

| DSGVO-Artikel | Implementierung |
|---------------|-----------------|
| **Art. 6 (Einwilligung)** | Explizite Einwilligung über `consent_checkbox` erforderlich |
| **Art. 17 (Recht auf Löschung)** | Admin-Endpunkt für vollständige Datenlöschung |
| **Art. 5 (Datenminimierung)** | Nur Name, E-Mail, Nachricht, Zeitstempel gespeichert |
| **Art. 5 (Speicherbegrenzung)** | Automatische Löschung nach 6 Monaten (konfigurierbar) |
| **Art. 32 (Sicherheit)** | IP-Anonymisierung, parametrisierte Abfragen, HTTPS-Unterstützung |

### IP-Anonymisierung

Alle IP-Adressen werden vor der Speicherung anonymisiert:
- `192.168.1.123` → `192.168.1.0`
- `2001:0db8:85a3::8a2e:0370:7334` → `2001:0db8:85a3::8a2e:0370:0`

### Datenspeicherung

- **Standard-Aufbewahrungsfrist**: 6 Monate
- **Automatische Bereinigung**: Geplanter Job löscht alte Datensätze
- **Manuelle Bereinigung**: Admin-Endpunkt verfügbar
- **Recht auf Vergessenwerden**: Sofortige Löschung auf Anfrage

## 🛠 Technologie-Stack

- **Backend-Framework**: Express.js mit TypeScript
- **Datenbank**: PostgreSQL 15
- **Laufzeitumgebung**: Node.js 20 LTS
- **Validierung**: express-validator
- **Sicherheit**: Helmet.js, CORS
- **Containerisierung**: Docker & Docker Compose
- **Entwicklung**: ts-node-dev mit Hot Reload

## 🚀 Schnellstart

### Voraussetzungen

- Node.js 20+ ODER Docker & Docker Compose
- PostgreSQL 15+ (falls Docker nicht verwendet wird)

### Option 1: Docker (Empfohlen)

```bash
# Repository klonen
git clone https://github.com/IHR_USERNAME/dsgvo-contact-backend.git
cd dsgvo-contact-backend

# Umgebung konfigurieren
cp .env.example .env
# .env mit sicheren Passwörtern bearbeiten

# Alle Services starten
docker-compose up -d

# Status prüfen
docker-compose logs -f backend
```

### Option 2: Lokale Entwicklung

```bash
# Abhängigkeiten installieren
npm install

# PostgreSQL-Datenbank einrichten
createdb dsgvo_contacts
psql -d dsgvo_contacts -f database/init.sql

# Umgebung konfigurieren
cp .env.example .env
# .env mit Ihren Datenbankzugangsdaten bearbeiten

# Entwicklungsserver starten
npm run dev
```

### API testen

```bash
# Health-Check
curl http://localhost:3000/health

# Kontaktformular absenden
curl -X POST http://localhost:3000/api/v1/contact/submit \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Max Mustermann",
    "email": "max@beispiel.de",
    "message": "Test-Nachricht",
    "consent_checkbox": true
  }'
```

## 📡 API-Dokumentation

### Öffentliche Endpunkte

#### Kontaktformular absenden

```http
POST /api/v1/contact/submit
Content-Type: application/json

{
  "name": "Max Mustermann",
  "email": "max@beispiel.de",
  "message": "Ihre Nachricht hier",
  "consent_checkbox": true
}
```

**Antwort 201 (Erfolg):**
```json
{
  "success": true,
  "message": "Contact form submitted successfully",
  "data": {
    "id": 1,
    "submitted_at": "2024-01-15T10:30:00.000Z"
  }
}
```

**Antwort 400 (Keine Einwilligung):**
```json
{
  "success": false,
  "error": "Validation failed",
  "details": [
    {
      "field": "consent_checkbox",
      "message": "Consent must be explicitly granted for GDPR compliance"
    }
  ]
}
```

### Admin-Endpunkte

Erfordern `x-admin-key` Header mit gültigem Admin-API-Schlüssel.

#### Benutzerdaten löschen (Recht auf Vergessenwerden)

```http
DELETE /api/v1/contact/delete/:email
x-admin-key: ihr_admin_schluessel
```

#### Manuelle Bereinigung auslösen

```http
POST /api/v1/contact/cleanup
x-admin-key: ihr_admin_schluessel
```

### Utility-Endpunkte

#### Health-Check

```http
GET /health
```

## 🐳 Docker-Deployment

### Mit Docker Compose (Produktion)

```bash
# Services starten
docker-compose up -d

# Logs anzeigen
docker-compose logs -f

# Services stoppen
docker-compose down

# Nach Änderungen neu bauen
docker-compose up -d --build
```

Der Stack beinhaltet:
- **PostgreSQL 15** mit automatischer Initialisierung
- **Backend-API** mit Health-Checks
- **Persistentes Volume** für Datenbankspeicherung
- **Netzwerkisolation** für Sicherheit

### Umgebungsvariablen

```env
# Datenbank-Konfiguration
DB_HOST=postgres
DB_PORT=5432
DB_NAME=dsgvo_contacts
DB_USER=postgres
DB_PASSWORD=ihr_sicheres_passwort

# Server-Konfiguration
PORT=3000
NODE_ENV=production

# Admin-Zugang
ADMIN_API_KEY=ihr_sicherer_admin_schluessel

# Datenspeicherung
DATA_RETENTION_MONTHS=6
```

## 🔐 Sicherheit

### Implementierte Sicherheitsmaßnahmen

1. **Eingabevalidierung**: Alle Felder werden validiert und sanitisiert
2. **SQL-Injection-Schutz**: Nur parametrisierte Abfragen
3. **IP-Anonymisierung**: Letztes Oktett wird vor Speicherung entfernt
4. **Sicherheitsheader**: Helmet.js-Middleware aktiv
5. **Admin-Authentifizierung**: API-Schlüssel für sensible Operationen erforderlich
6. **HTTPS-Unterstützung**: Konfigurierbar über Reverse Proxy (nginx/Apache)

### Checkliste für Produktions-Deployment

- [ ] Starken `ADMIN_API_KEY` setzen (min. 32 Zeichen)
- [ ] Starkes `DB_PASSWORD` setzen
- [ ] HTTPS über Reverse Proxy konfigurieren
- [ ] `NODE_ENV=production` setzen
- [ ] Automatische PostgreSQL-Backups einrichten
- [ ] Automatisierten Cleanup-Cronjob konfigurieren
- [ ] Rate-Limiting implementieren
- [ ] Korrekte CORS-Origins setzen (nicht `*`)
- [ ] Aufbewahrungsfrist überprüfen

### HTTPS-Konfiguration (nginx)

```nginx
server {
    listen 443 ssl http2;
    server_name api.ihredomain.de;

    ssl_certificate /pfad/zu/cert.pem;
    ssl_certificate_key /pfad/zu/key.pem;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## 📊 Projektstruktur

```
dsgvo-contact-backend/
├── src/
│   ├── config/          # Datenbank-Konfiguration
│   ├── controllers/     # Request-Handler
│   ├── middleware/      # Validierung & Authentifizierung
│   ├── models/          # TypeScript-Interfaces
│   ├── routes/          # API-Routen-Definitionen
│   ├── services/        # Business-Logik-Schicht
│   ├── utils/           # Hilfsfunktionen (IP-Anonymisierung)
│   ├── jobs/            # Geplante Jobs (Bereinigung)
│   └── index.ts         # Anwendungseinstiegspunkt
├── database/
│   └── init.sql         # Datenbank-Schema
├── examples/
│   ├── api-requests.http    # API-Beispiele
│   └── cron-setup.sh        # Automatisierte Bereinigung
├── Dockerfile
├── docker-compose.yml
├── package.json
├── tsconfig.json
└── README.md
```

## 🧪 Testen

```bash
# Automatisierte Tests ausführen (PowerShell)
.\test-api-simple.ps1

# Manuelle Tests mit curl
curl http://localhost:3000/health
```

## 🔄 Datenspeicherung & Bereinigung

### Automatisierte Bereinigung

```bash
# Bereinigungsjob manuell ausführen
npm run cleanup

# Cronjob einrichten (Linux/macOS)
crontab -e
# Hinzufügen: 0 2 * * * cd /pfad/zum/projekt && npm run cleanup
```

### Windows-Aufgabenplanung

1. Aufgabenplanung öffnen
2. Einfache Aufgabe erstellen: "DSGVO-Bereinigung"
3. Trigger: Täglich um 2:00 Uhr
4. Aktion: Programm starten `npm`
5. Argumente: `run cleanup`
6. Starten in: Projektverzeichnis

## 📄 Lizenz

MIT-Lizenz - Siehe [LICENSE](LICENSE)-Datei für Details.

## ⚖️ Rechtlicher Hinweis

Diese Software demonstriert DSGVO-konforme Praktiken, sollte jedoch von einem Rechtsberater für Ihren spezifischen Anwendungsfall geprüft werden. Stellen Sie sicher, dass Sie:

1. Einen Rechtsberater für DSGVO-Konformität konsultieren
2. Zusätzliche Sicherheitsmaßnahmen nach Bedarf implementieren
3. Ordnungsgemäße Auftragsverarbeitungsverträge (AVV) führen
4. Verzeichnis von Verarbeitungstätigkeiten führen (Art. 30 DSGVO)
5. Datenschutz-Folgenabschätzung durchführen, falls erforderlich

## 🤝 Mitwirken

Beiträge sind willkommen! Bitte zögern Sie nicht, einen Pull Request einzureichen.

## 📧 Kontakt

Für Anfragen zu diesem Projekt oder Freelance-Arbeit kontaktieren Sie mich bitte über GitHub.

---

**Mit ❤️ für DSGVO-Konformität und Datenschutz entwickelt**

*Demonstration professioneller Backend-Entwicklung mit rechtlicher Sicherheit für den deutschen Markt*
