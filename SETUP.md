# 🚀 Quick Setup Guide

## Option 1: Docker Deployment (Recommended)

### Prerequisites
- Docker
- Docker Compose

### Steps

1. **Clone and navigate to project**
```bash
cd "DSGVO-Ready Contact Form Backend"
```

2. **Create environment file**
```bash
cp .env.example .env
```

3. **Edit `.env` and set secure values**
```env
DB_PASSWORD=your_secure_database_password
ADMIN_API_KEY=your_secure_admin_key_change_this
```

4. **Start services**
```bash
docker-compose up -d
```

5. **Check logs**
```bash
docker-compose logs -f backend
```

6. **Test the API**
```bash
curl http://localhost:3000/health
```

✅ **Done!** Your DSGVO-compliant backend is running.

---

## Option 2: Local Development

### Prerequisites
- Node.js 20+
- PostgreSQL 15+

### Steps

1. **Install dependencies**
```bash
npm install
```

2. **Set up PostgreSQL**
```bash
# Create database
createdb dsgvo_contacts

# Or using psql
psql -U postgres -c "CREATE DATABASE dsgvo_contacts;"

# Initialize schema
psql -U postgres -d dsgvo_contacts -f database/init.sql
```

3. **Configure environment**
```bash
cp .env.example .env
# Edit .env with your database credentials
```

4. **Start development server**
```bash
npm run dev
```

5. **Test the API**
```bash
curl http://localhost:3000/health
```

---

## Testing the API

### Using provided examples

Open `examples/api-requests.http` in VS Code with REST Client extension, or use curl:

```bash
# Submit a contact form
curl -X POST http://localhost:3000/api/v1/contact/submit \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Max Mustermann",
    "email": "max@example.de",
    "message": "Test Nachricht",
    "consent_checkbox": true
  }'
```

---

## Setting Up Automated Cleanup

### Option A: Using cron (Linux/macOS)

```bash
# Edit the script with your project path
nano examples/cron-setup.sh

# Make it executable
chmod +x examples/cron-setup.sh

# Run the setup script
./examples/cron-setup.sh
```

### Option B: Manual cron setup

```bash
crontab -e
```

Add this line (adjust path):
```
0 2 * * * cd /path/to/project && npm run cleanup >> /var/log/dsgvo-cleanup.log 2>&1
```

### Option C: Windows Task Scheduler

1. Open Task Scheduler
2. Create Basic Task
3. Trigger: Daily at 2:00 AM
4. Action: Start a program
5. Program: `npm`
6. Arguments: `run cleanup`
7. Start in: `C:\path\to\DSGVO-Ready Contact Form Backend`

---

## Production Deployment Checklist

- [ ] Change `ADMIN_API_KEY` to a strong, unique value
- [ ] Set strong `DB_PASSWORD`
- [ ] Configure HTTPS via reverse proxy (nginx/Apache)
- [ ] Set `NODE_ENV=production`
- [ ] Set up automated backups for PostgreSQL
- [ ] Configure automated cleanup cron job
- [ ] Set up monitoring and logging
- [ ] Review data retention period (`DATA_RETENTION_MONTHS`)
- [ ] Implement rate limiting (e.g., express-rate-limit)
- [ ] Set up proper CORS origins (not `*`)
- [ ] Create privacy policy and update contact form UI

---

## Troubleshooting

### Database connection errors
```bash
# Check if PostgreSQL is running
pg_isready

# Check connection with psql
psql -U postgres -d dsgvo_contacts
```

### TypeScript errors
```bash
# Reinstall dependencies
rm -rf node_modules package-lock.json
npm install
```

### Port already in use
```bash
# Change PORT in .env file
PORT=3001
```

### Docker issues
```bash
# Rebuild containers
docker-compose down
docker-compose up --build

# View container logs
docker-compose logs backend
docker-compose logs postgres
```

---

## Need Help?

Check the full [README.md](README.md) for detailed documentation.
