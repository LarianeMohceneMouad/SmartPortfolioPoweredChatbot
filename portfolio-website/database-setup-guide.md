# 💾 PostgreSQL Installation & Setup Guide

## Option 1: Manual Installation (Recommended)

### 1. Download PostgreSQL
- Go to: https://www.postgresql.org/download/windows/
- Click "Download the installer" 
- Download PostgreSQL 16 or 17 for Windows x86-64

### 2. Run the Installer
- Run the downloaded .exe file as Administrator
- Accept defaults for installation directory
- **IMPORTANT**: Set password for postgres user to: `postgres123`
- Keep default port: `5432`
- Accept default locale settings
- Complete installation

### 3. Verify Installation
Open Command Prompt and run:
```cmd
psql --version
```

### 4. Add to PATH (if needed)
If psql command not found, add to PATH:
- Add `C:\Program Files\PostgreSQL\16\bin` to your system PATH
- Restart command prompt

## Option 2: Quick Database Setup (Alternative)

If you prefer a simpler setup, I can modify the backend to use SQLite instead of PostgreSQL for local development.

## Next Steps (After PostgreSQL is installed)

### 1. Create Database
```cmd
psql -U postgres
CREATE DATABASE portfolio_db;
\q
```

### 2. Run Schema
```cmd
cd portfolio-website
psql -U postgres -d portfolio_db -f database/schema.sql
```

### 3. Update Backend Config
Update `backend/.env`:
```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=portfolio_db
DB_USER=postgres
DB_PASSWORD=postgres123
```

### 4. Test Application
```cmd
# Terminal 1
cd backend && npm run dev

# Terminal 2  
cd frontend && npm run dev
```

Would you like me to:
1. Wait for you to install PostgreSQL manually, OR
2. Modify the app to use SQLite for easier setup?