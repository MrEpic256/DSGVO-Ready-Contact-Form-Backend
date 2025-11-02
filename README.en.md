# 🔒 GDPR-Compliant Contact Form Backend

[![TypeScript](https://img.shields.io/badge/TypeScript-5.3-blue.svg)](https://www.typescriptlang.org/)
[![Node.js](https://img.shields.io/badge/Node.js-20-green.svg)](https://nodejs.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-blue.svg)](https://www.postgresql.org/)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED.svg)](https://www.docker.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

> **[Deutsche Version](README.de.md) | English Version**

A production-ready, legally secure backend service for handling contact form submissions with **strict GDPR/DSGVO compliance**. Designed specifically for German clients who prioritize data protection and legal security (*rechtssicher*).

## 📑 Table of Contents

- [Features](#-features)
- [GDPR Compliance](#-gdpr-compliance)
- [Tech Stack](#-tech-stack)
- [Quick Start](#-quick-start)
- [API Documentation](#-api-documentation)
- [Docker Deployment](#-docker-deployment)
- [Security](#-security)
- [License](#-license)

## ✨ Features

- ✅ **Full GDPR/DSGVO compliance** with explicit user consent validation
- ✅ **IP address anonymization** (last octet removal before storage)
- ✅ **Right to be Forgotten** (Art. 17 GDPR) implementation
- ✅ **Automated data retention** with configurable cleanup (default: 6 months)
- ✅ **Data minimization** principle - only essential data stored
- ✅ **SQL injection protection** via parameterized queries
- ✅ **Input validation & sanitization** using express-validator
- ✅ **Admin-protected endpoints** with API key authentication
- ✅ **Docker containerization** for easy deployment
- ✅ **Comprehensive audit logging** of all operations
- ✅ **Health check endpoints** for monitoring

## 🇪🇺 GDPR Compliance

This service implements the following GDPR principles:

### Key Compliance Features

| GDPR Article | Implementation |
|--------------|----------------|
| **Art. 6 (Consent)** | Explicit consent required via `consent_checkbox` field |
| **Art. 17 (Right to Erasure)** | Admin endpoint for complete data deletion |
| **Art. 5 (Data Minimization)** | Only name, email, message, timestamp stored |
| **Art. 5 (Storage Limitation)** | Automatic deletion after 6 months (configurable) |
| **Art. 32 (Security)** | IP anonymization, parameterized queries, HTTPS support |

### IP Anonymization

All IP addresses are anonymized before storage:
- `192.168.1.123` → `192.168.1.0`
- `2001:0db8:85a3::8a2e:0370:7334` → `2001:0db8:85a3::8a2e:0370:0`

### Data Retention

- **Default retention period**: 6 months
- **Automatic cleanup**: Scheduled job deletes old records
- **Manual cleanup**: Admin endpoint available
- **Right to be Forgotten**: Immediate deletion on request

## 🛠 Tech Stack

- **Backend Framework**: Express.js with TypeScript
- **Database**: PostgreSQL 15
- **Runtime**: Node.js 20 LTS
- **Validation**: express-validator
- **Security**: Helmet.js, CORS
- **Containerization**: Docker & Docker Compose
- **Development**: ts-node-dev with hot reload

## 🚀 Quick Start

### Prerequisites

- Node.js 20+ OR Docker & Docker Compose
- PostgreSQL 15+ (if not using Docker)

### Option 1: Docker (Recommended)

```bash
# Clone repository
git clone https://github.com/YOUR_USERNAME/dsgvo-contact-backend.git
cd dsgvo-contact-backend

# Configure environment
cp .env.example .env
# Edit .env with secure passwords

# Start all services
docker-compose up -d

# Check status
docker-compose logs -f backend
```

### Option 2: Local Development

```bash
# Install dependencies
npm install

# Set up PostgreSQL database
createdb dsgvo_contacts
psql -d dsgvo_contacts -f database/init.sql

# Configure environment
cp .env.example .env
# Edit .env with your database credentials

# Start development server
npm run dev
```

### Test the API

```bash
# Health check
curl http://localhost:3000/health

# Submit contact form
curl -X POST http://localhost:3000/api/v1/contact/submit \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "message": "Test message",
    "consent_checkbox": true
  }'
```

## 📡 API Documentation

### Public Endpoints

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

**Response 400 (No Consent):**
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

### Admin Endpoints

Require `x-admin-key` header with valid admin API key.

#### Delete User Data (Right to be Forgotten)
```http
DELETE /api/v1/contact/delete/:email
x-admin-key: your_admin_key
```

#### Trigger Manual Cleanup
```http
POST /api/v1/contact/cleanup
x-admin-key: your_admin_key
```

### Utility Endpoints

#### Health Check
```http
GET /health
```

## 🐳 Docker Deployment

### Using Docker Compose (Production)

```bash
# Start services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Rebuild after changes
docker-compose up -d --build
```

The stack includes:
- **PostgreSQL 15** with automatic initialization
- **Backend API** with health checks
- **Persistent volume** for database storage
- **Network isolation** for security

### Environment Variables

```env
# Database Configuration
DB_HOST=postgres
DB_PORT=5432
DB_NAME=dsgvo_contacts
DB_USER=postgres
DB_PASSWORD=your_secure_password

# Server Configuration
PORT=3000
NODE_ENV=production

# Admin Access
ADMIN_API_KEY=your_secure_admin_key

# Data Retention
DATA_RETENTION_MONTHS=6
```

## 🔐 Security

### Implemented Security Measures

1. **Input Validation**: All fields validated and sanitized
2. **SQL Injection Protection**: Parameterized queries only
3. **IP Anonymization**: Last octet removed before storage
4. **Security Headers**: Helmet.js middleware active
5. **Admin Authentication**: API key required for sensitive operations
6. **HTTPS Support**: Configure via reverse proxy (nginx/Apache)

### Production Deployment Checklist

- [ ] Set strong `ADMIN_API_KEY` (min 32 characters)
- [ ] Set strong `DB_PASSWORD`
- [ ] Configure HTTPS via reverse proxy
- [ ] Set `NODE_ENV=production`
- [ ] Set up automated PostgreSQL backups
- [ ] Configure automated cleanup cron job
- [ ] Implement rate limiting
- [ ] Set proper CORS origins (not `*`)
- [ ] Review data retention period

### HTTPS Configuration (nginx)

```nginx
server {
    listen 443 ssl http2;
    server_name api.yourdomain.com;

    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## 📊 Project Structure

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
│   ├── jobs/            # Scheduled jobs (cleanup)
│   └── index.ts         # Application entry point
├── database/
│   └── init.sql         # Database schema
├── examples/
│   ├── api-requests.http    # API examples
│   └── cron-setup.sh        # Automated cleanup setup
├── Dockerfile
├── docker-compose.yml
├── package.json
├── tsconfig.json
└── README.md
```

## 🧪 Testing

```bash
# Run automated tests (PowerShell)
.\test-api-simple.ps1

# Manual testing with curl
curl http://localhost:3000/health
```

## 🔄 Data Retention & Cleanup

### Automated Cleanup

```bash
# Run cleanup job manually
npm run cleanup

# Set up cron job (Linux/macOS)
crontab -e
# Add: 0 2 * * * cd /path/to/project && npm run cleanup
```

### Windows Task Scheduler

1. Open Task Scheduler
2. Create Basic Task: "DSGVO Cleanup"
3. Trigger: Daily at 2:00 AM
4. Action: Start program `npm`
5. Arguments: `run cleanup`
6. Start in: Project directory

## 📄 License

MIT License - See [LICENSE](LICENSE) file for details.

## ⚖️ Legal Disclaimer

This software demonstrates GDPR-compliant practices but should be reviewed by legal counsel for your specific use case. Ensure you:

1. Consult with a legal expert for GDPR compliance
2. Implement additional security measures as needed
3. Maintain proper data processing agreements (DPA)
4. Keep records of processing activities (Art. 30 GDPR)
5. Conduct Data Protection Impact Assessment if required

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📧 Contact

For inquiries about this project or freelance work, please contact via GitHub.

---

**Built with ❤️ for GDPR compliance and data protection**

*Demonstrating professional backend development with legal security for German market*
