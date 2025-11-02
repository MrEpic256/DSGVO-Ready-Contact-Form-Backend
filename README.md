# 🔒 DSGVO-Ready Contact Form Backend

A production-ready backend service for handling contact form submissions with **strict GDPR/DSGVO compliance**. Built for German clients who prioritize data protection and legal security (*rechtssicher*).

## 📋 Table of Contents

- [Features](#-features)
- [DSGVO Compliance](#-dsgvo-compliance)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Installation](#-installation)
- [API Endpoints](#-api-endpoints)
- [Environment Variables](#-environment-variables)
- [Docker Deployment](#-docker-deployment)
- [Data Retention Policy](#-data-retention-policy)
- [Security Measures](#-security-measures)

## ✨ Features

- ✅ **DSGVO-compliant data processing** with explicit consent validation
- ✅ **IP anonymization** (last octet removal)
- ✅ **Right to be Forgotten** (Recht auf Vergessenwerden) implementation
- ✅ **Automatic data cleanup** based on retention policy
- ✅ **Data minimization** principle
- ✅ **SQL injection protection** via parameterized queries
- ✅ **Admin-protected endpoints** for data deletion
- ✅ **Comprehensive audit logging**
- ✅ **Docker containerization** for easy deployment
- ✅ **Health check endpoints** for monitoring

## 🇪🇺 DSGVO Compliance

This service implements the following GDPR/DSGVO principles:

### 1. **Lawfulness, Fairness and Transparency (Art. 5 Abs. 1 lit. a DSGVO)**
- Explicit consent required via `consent_checkbox` field
- Requests without consent are rejected with HTTP 400
- Clear documentation of data processing

### 2. **Purpose Limitation (Art. 5 Abs. 1 lit. b DSGVO)**
- Data collected only for contact form purposes
- No secondary use of collected data

### 3. **Data Minimization (Art. 5 Abs. 1 lit. c DSGVO)**
- Only essential fields stored: name, email, message, timestamp
- IP addresses anonymized before storage
- User agent limited to 500 characters

### 4. **Accuracy (Art. 5 Abs. 1 lit. d DSGVO)**
- Input validation ensures data quality
- Email format validation
- Sanitization of input data

### 5. **Storage Limitation (Art. 5 Abs. 1 lit. e DSGVO)**
- Automatic deletion of records older than 6 months (configurable)
- Manual cleanup job available

### 6. **Integrity and Confidentiality (Art. 5 Abs. 1 lit. f DSGVO)**
- HTTPS required in production (configured via reverse proxy)
- Helmet.js security headers
- SQL injection protection
- Admin endpoints protected with API key

### 7. **Right to Erasure (Art. 17 DSGVO)**
- Admin endpoint to delete all data for a specific email
- Complete removal from database
- Audit logging of deletions

## 🛠 Tech Stack

- **Backend:** TypeScript, Node.js, Express
- **Database:** PostgreSQL 15
- **Validation:** express-validator
- **Security:** Helmet.js, CORS
- **Containerization:** Docker, Docker Compose
- **Runtime:** Node.js 20 LTS

## 📁 Project Structure

```
DSGVO-Ready Contact Form Backend/
├── src/
│   ├── config/
│   │   └── database.ts          # PostgreSQL connection pool
│   ├── controllers/
│   │   └── contact.controller.ts # Request handlers
│   ├── middleware/
│   │   └── validation.middleware.ts # Input validation & auth
│   ├── models/
│   │   └── contact.model.ts     # TypeScript interfaces
│   ├── routes/
│   │   └── contact.routes.ts    # API route definitions
│   ├── services/
│   │   └── contact.service.ts   # Business logic
│   ├── utils/
│   │   └── anonymization.utils.ts # IP anonymization
│   ├── jobs/
│   │   └── cleanup.job.ts       # Data retention job
│   └── index.ts                 # Application entry point
├── database/
│   └── init.sql                 # Database schema
├── Dockerfile                   # Production container
├── docker-compose.yml           # Multi-container setup
├── package.json
├── tsconfig.json
└── .env.example
```

## 📦 Installation

### Prerequisites

- Node.js 20+
- PostgreSQL 15+
- Docker & Docker Compose (optional)

### Local Development

1. **Clone the repository**
```bash
git clone <repository-url>
cd "DSGVO-Ready Contact Form Backend"
```

2. **Install dependencies**
```bash
npm install
```

3. **Configure environment**
```bash
cp .env.example .env
# Edit .env with your configuration
```

4. **Set up PostgreSQL database**
```bash
# Create database
psql -U postgres -c "CREATE DATABASE dsgvo_contacts;"

# Run initialization script
psql -U postgres -d dsgvo_contacts -f database/init.sql
```

5. **Start development server**
```bash
npm run dev
```

The server will start at `http://localhost:3000`

## 🌐 API Endpoints

### Public Endpoint

#### **POST** `/api/v1/contact/submit`
Submit a contact form with consent.

**Request Body:**
```json
{
  "name": "Max Mustermann",
  "email": "max@example.de",
  "message": "Ich möchte mehr Informationen über Ihre Dienstleistungen.",
  "consent_checkbox": true
}
```

**Success Response (201):**
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

**Error Response (400) - Missing Consent:**
```json
{
  "success": false,
  "error": "Validation failed",
  "details": [
    {
      "field": "consent_checkbox",
      "message": "Consent must be explicitly granted for DSGVO compliance"
    }
  ]
}
```

### Admin Endpoints (Require `x-admin-key` header)

#### **DELETE** `/api/v1/contact/delete/:email`
Delete all submissions for a specific email (Right to be Forgotten).

**Headers:**
```
x-admin-key: your_secure_admin_key
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "All submissions deleted successfully (DSGVO compliance)",
  "email": "max@example.de",
  "deleted_count": 3
}
```

#### **POST** `/api/v1/contact/cleanup`
Manually trigger cleanup of records older than retention period.

**Headers:**
```
x-admin-key: your_secure_admin_key
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Cleanup completed: 15 old record(s) deleted",
  "retention_policy": "6 months",
  "deleted_count": 15
}
```

### Utility Endpoint

#### **GET** `/health`
Health check endpoint for monitoring.

**Response (200):**
```json
{
  "status": "healthy",
  "timestamp": "2024-01-15T10:30:00.000Z",
  "service": "DSGVO Contact Form Backend"
}
```

## ⚙️ Environment Variables

Create a `.env` file based on `.env.example`:

```env
# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=dsgvo_contacts
DB_USER=postgres
DB_PASSWORD=your_secure_password

# Server Configuration
PORT=3000
NODE_ENV=development

# Admin Access Key (CHANGE THIS!)
ADMIN_API_KEY=your_secure_admin_key_here

# Data Retention (in months)
DATA_RETENTION_MONTHS=6
```

⚠️ **Security Note:** Always use strong, unique values for `DB_PASSWORD` and `ADMIN_API_KEY` in production!

## 🐳 Docker Deployment

### Quick Start with Docker Compose

```bash
# Build and start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

This will start:
- PostgreSQL database on port 5432
- Backend API on port 3000

### Production Build

```bash
# Build production image
docker build -t dsgvo-contact-backend .

# Run container
docker run -d \
  --name dsgvo-backend \
  -p 3000:3000 \
  --env-file .env \
  dsgvo-contact-backend
```

## 📅 Data Retention Policy

**Default Retention Period:** 6 months (configurable via `DATA_RETENTION_MONTHS`)

### Automatic Cleanup

Schedule the cleanup job using cron:

```bash
# Run cleanup job manually
npm run cleanup

# Example cron job (runs daily at 2 AM)
0 2 * * * cd /path/to/project && npm run cleanup >> /var/log/dsgvo-cleanup.log 2>&1
```

### Manual Deletion (Right to be Forgotten)

Users can request deletion of their data. Use the admin endpoint:

```bash
curl -X DELETE http://localhost:3000/api/v1/contact/delete/user@example.de \
  -H "x-admin-key: your_admin_key"
```

## 🔐 Security Measures

### Implemented Security Features

1. **Input Validation**
   - All fields validated and sanitized
   - Email format verification
   - Length restrictions enforced

2. **SQL Injection Protection**
   - Parameterized queries only
   - No dynamic SQL construction

3. **IP Anonymization**
   - Last octet removed before storage
   - Example: `192.168.1.123` → `192.168.1.0`
   - Compliant with DSGVO requirements

4. **Security Headers**
   - Helmet.js middleware active
   - XSS protection
   - Content Security Policy

5. **Admin Authentication**
   - API key required for sensitive operations
   - No public access to deletion endpoints

6. **HTTPS in Production**
   - Configure via reverse proxy (nginx, Apache)
   - Example nginx configuration:

```nginx
server {
    listen 443 ssl http2;
    server_name api.yourdomain.de;

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

## 📝 Testing the API

### Using cURL

```bash
# Submit contact form
curl -X POST http://localhost:3000/api/v1/contact/submit \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Max Mustermann",
    "email": "max@example.de",
    "message": "Test message",
    "consent_checkbox": true
  }'

# Health check
curl http://localhost:3000/health

# Delete user data (admin)
curl -X DELETE http://localhost:3000/api/v1/contact/delete/max@example.de \
  -H "x-admin-key: your_admin_key"
```

### Using Postman

Import the following collection:

**POST Submit Contact:**
- URL: `http://localhost:3000/api/v1/contact/submit`
- Method: POST
- Headers: `Content-Type: application/json`
- Body (raw JSON):
```json
{
  "name": "Test User",
  "email": "test@example.com",
  "message": "This is a test message",
  "consent_checkbox": true
}
```

## 📊 Monitoring & Logging

The service logs all important events:

- Contact form submissions
- DSGVO deletion requests
- Automatic cleanup operations
- Database errors
- Authentication failures

Example log output:
```
2024-01-15T10:30:00.123Z - POST /api/v1/contact/submit
DSGVO deletion: Removed 3 record(s) for email: user@example.de
Auto-cleanup: Removed 15 record(s) older than 6 months
```

## 🤝 Contributing

This is a demonstration project showcasing DSGVO compliance. Contributions are welcome!

## 📄 License

MIT License - See LICENSE file for details

## ⚖️ Legal Disclaimer

This software is provided as-is for demonstration purposes. While it implements DSGVO-compliant practices, you should:

1. Consult with a legal expert for DSGVO compliance in your specific use case
2. Implement additional security measures as needed for your environment
3. Maintain proper data processing agreements (AVV/DPA)
4. Keep comprehensive records of processing activities (Art. 30 DSGVO)
5. Conduct a Data Protection Impact Assessment (DSFA) if required

---

**Built with ❤️ for DSGVO compliance and data protection**
