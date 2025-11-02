# 🔒 GDPR/DSGVO Contact Form Backend

[![TypeScript](https://img.shields.io/badge/TypeScript-5.3-blue.svg)](https://www.typescriptlang.org/)
[![Node.js](https://img.shields.io/badge/Node.js-20-green.svg)](https://nodejs.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-blue.svg)](https://www.postgresql.org/)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED.svg)](https://www.docker.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

> **[🇬🇧 English](#english) | [🇩🇪 Deutsch](#deutsch)**

---

## 🇬🇧 English

### Production-Ready GDPR-Compliant Contact Form Backend

A legally secure backend service for processing contact form submissions with **strict GDPR/DSGVO compliance**. Designed specifically for German market requirements.

### ✨ Key Features

- ✅ **Full GDPR/DSGVO compliance** with explicit user consent validation
- ✅ **IP address anonymization** (last octet removal before storage)
- ✅ **Right to be Forgotten** (Art. 17 GDPR) implementation
- ✅ **Automated data retention** with configurable cleanup (6 months default)
- ✅ **Data minimization** - only essential data stored
- ✅ **SQL injection protection** via parameterized queries
- ✅ **Docker-ready** deployment with PostgreSQL
- ✅ **Comprehensive API** documentation

### 🛠 Tech Stack

- **Backend:** TypeScript, Node.js, Express.js
- **Database:** PostgreSQL 15
- **Security:** Helmet.js, express-validator, CORS
- **Deployment:** Docker & Docker Compose
- **Development:** ts-node-dev with hot reload

### 🚀 Quick Start

#### Using Docker (Recommended)

```bash
# Clone repository
git clone https://github.com/MrEpic256/DSGVO-Ready-Contact-Form-Backend.git
cd DSGVO-Ready-Contact-Form-Backend

# Configure environment
cp .env.example .env
# Edit .env with your settings

# Start all services
docker-compose up -d

# Check logs
docker-compose logs -f backend
```

#### Local Development

```bash
# Install dependencies
npm install

# Set up PostgreSQL database
createdb dsgvo_contacts
psql -d dsgvo_contacts -f database/init.sql

# Configure environment
cp .env.example .env

# Start development server
npm run dev
```

### 📡 API Endpoints

#### Submit Contact Form
```http
POST /api/v1/contact/submit
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "message": "Your message here",
  "consent_checkbox": true
}
```

**Response 201 (Success):**
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

#### Admin Endpoints (require `x-admin-key` header)

- **DELETE** `/api/v1/contact/delete/:email` - Delete user data (Right to be Forgotten)
- **POST** `/api/v1/contact/cleanup` - Trigger manual cleanup of old records

### 🔐 GDPR Compliance

| GDPR Article | Implementation |
|--------------|----------------|
| Art. 6 (Consent) | Explicit consent required via `consent_checkbox` |
| Art. 17 (Right to Erasure) | Admin endpoint for complete data deletion |
| Art. 5 (Data Minimization) | Only name, email, message, timestamp stored |
| Art. 5 (Storage Limitation) | Automatic deletion after 6 months |
| Art. 32 (Security) | IP anonymization, parameterized queries, HTTPS support |

**IP Anonymization:**
- `192.168.1.123` → `192.168.1.0`
- `2001:0db8:85a3::8a2e:0370:7334` → `2001:0db8:85a3::8a2e:0370:0`

### 📊 Project Structure

```
dsgvo-contact-backend/
├── src/
│   ├── config/          # Database configuration
│   ├── controllers/     # Request handlers
│   ├── middleware/      # Validation & authentication
│   ├── models/          # TypeScript interfaces
│   ├── routes/          # API route definitions
│   ├── services/        # Business logic layer
│   ├── utils/           # Helper functions (IP anonymization)
│   └── jobs/            # Scheduled jobs (cleanup)
├── database/
│   └── init.sql         # Database schema
├── docker-compose.yml
├── Dockerfile
└── package.json
```

### 🐳 Docker Deployment

```bash
# Start services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### 🧪 Testing

```bash
# Run automated tests
.\test-api-simple.ps1

# Manual test
curl http://localhost:3000/health
```

### 📄 License

MIT License - See [LICENSE](LICENSE) file for details.

---

## 🇩🇪 Deutsch

### Produktionsreifes DSGVO-konformes Kontaktformular-Backend

Ein rechtssicherer Backend-Service zur Verarbeitung von Kontaktformular-Daten mit **strenger DSGVO-Konformität**. Speziell für die Anforderungen des deutschen Marktes entwickelt.

### ✨ Hauptfunktionen

- ✅ **Vollständige DSGVO-Konformität** mit expliziter Einwilligungsvalidierung
- ✅ **IP-Adressen-Anonymisierung** (Entfernung des letzten Oktetts vor Speicherung)
- ✅ **Recht auf Vergessenwerden** (Art. 17 DSGVO) implementiert
- ✅ **Automatisierte Datenlöschung** mit konfigurierbarer Bereinigung (Standard: 6 Monate)
- ✅ **Datenminimierung** - nur essenzielle Daten werden gespeichert
- ✅ **SQL-Injection-Schutz** durch parametrisierte Abfragen
- ✅ **Docker-ready** Deployment mit PostgreSQL
- ✅ **Umfassende API**-Dokumentation

### 🛠 Technologie-Stack

- **Backend:** TypeScript, Node.js, Express.js
- **Datenbank:** PostgreSQL 15
- **Sicherheit:** Helmet.js, express-validator, CORS
- **Deployment:** Docker & Docker Compose
- **Entwicklung:** ts-node-dev mit Hot Reload

### 🚀 Schnellstart

#### Mit Docker (Empfohlen)

```bash
# Repository klonen
git clone https://github.com/MrEpic256/DSGVO-Ready-Contact-Form-Backend.git
cd DSGVO-Ready-Contact-Form-Backend

# Umgebung konfigurieren
cp .env.example .env
# .env mit Ihren Einstellungen bearbeiten

# Alle Services starten
docker-compose up -d

# Logs prüfen
docker-compose logs -f backend
```

#### Lokale Entwicklung

```bash
# Abhängigkeiten installieren
npm install

# PostgreSQL-Datenbank einrichten
createdb dsgvo_contacts
psql -d dsgvo_contacts -f database/init.sql

# Umgebung konfigurieren
cp .env.example .env

# Entwicklungsserver starten
npm run dev
```

### 📡 API-Endpunkte

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

#### Admin-Endpunkte (erfordern `x-admin-key` Header)

- **DELETE** `/api/v1/contact/delete/:email` - Benutzerdaten löschen (Recht auf Vergessenwerden)
- **POST** `/api/v1/contact/cleanup` - Manuelle Bereinigung alter Datensätze auslösen

### 🔐 DSGVO-Konformität

| DSGVO-Artikel | Implementierung |
|---------------|-----------------|
| Art. 6 (Einwilligung) | Explizite Einwilligung über `consent_checkbox` erforderlich |
| Art. 17 (Recht auf Löschung) | Admin-Endpunkt für vollständige Datenlöschung |
| Art. 5 (Datenminimierung) | Nur Name, E-Mail, Nachricht, Zeitstempel gespeichert |
| Art. 5 (Speicherbegrenzung) | Automatische Löschung nach 6 Monaten |
| Art. 32 (Sicherheit) | IP-Anonymisierung, parametrisierte Abfragen, HTTPS-Unterstützung |

**IP-Anonymisierung:**
- `192.168.1.123` → `192.168.1.0`
- `2001:0db8:85a3::8a2e:0370:7334` → `2001:0db8:85a3::8a2e:0370:0`

### 📊 Projektstruktur

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
│   └── jobs/            # Geplante Jobs (Bereinigung)
├── database/
│   └── init.sql         # Datenbank-Schema
├── docker-compose.yml
├── Dockerfile
└── package.json
```

### 🐳 Docker-Deployment

```bash
# Services starten
docker-compose up -d

# Logs anzeigen
docker-compose logs -f

# Services stoppen
docker-compose down
```

### 🧪 Testen

```bash
# Automatisierte Tests ausführen
.\test-api-simple.ps1

# Manueller Test
curl http://localhost:3000/health
```

### 📄 Lizenz

MIT-Lizenz - Siehe [LICENSE](LICENSE)-Datei für Details.

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📧 Contact

For questions about this project or freelance inquiries, please reach out via GitHub.

---

**Built with ❤️ for GDPR/DSGVO compliance and data protection**
