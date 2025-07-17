# 🗄️ Local Database Connection Setup

## Quick Start Guide - Connect Form to Local Database

### 📋 Step 1: Install Backend Dependencies
```bash
cd portfolio-website/backend
npm install
```

### 🚀 Step 2: Start Backend Server
```bash
# In the backend directory
npm start
```

You should see:
```
✅ Server running on port 3001
📁 Using SQLite database (PostgreSQL not configured)
✅ SQLite database tables created successfully
🌍 Environment: development
📡 API Health: http://localhost:3001/api/health
```

### 🌐 Step 3: Start Frontend
Open a **new terminal** and run:
```bash
cd portfolio-website/frontend
npm run dev
```

### ✅ Step 4: Test the Connection
1. Open your browser to `http://localhost:3000`
2. Go to the Contact section
3. Fill out the form and submit
4. You should see "Thank you for your message! I'll get back to you soon."

### 🔍 Step 5: Verify Database Storage
To check if your form submissions are being saved:

**Option A: Visit the API endpoint**
Go to: `http://localhost:3001/api/contacts`

**Option B: Check the database file**
The SQLite database is created at: `backend/portfolio.db`

## 🛠️ Database Configuration

### Current Setup:
- **Database Type**: SQLite (file-based, no installation required)
- **Database Location**: `backend/portfolio.db`
- **Tables**: `contacts` table with columns:
  - `id` (auto-increment)
  - `name` (text)
  - `email` (text)
  - `message` (text)
  - `created_at` (timestamp)

### 🔧 Environment Variables:
- **Frontend**: `NEXT_PUBLIC_BACKEND_URL=http://localhost:3001`
- **Backend**: `FRONTEND_URL=http://localhost:3000`
- **Database**: `USE_POSTGRESQL=false` (using SQLite)

## 🐛 Troubleshooting

### Form submission errors:
1. Make sure backend server is running on port 3001
2. Check that frontend is running on port 3000
3. Verify no other services are using these ports

### CORS errors:
- The backend is configured to accept requests from `http://localhost:3000`
- Make sure you're accessing the frontend via localhost, not 127.0.0.1

### Database errors:
- SQLite database file is created automatically
- No external database installation required
- Check console logs for any error messages

## 📊 Viewing Stored Data

### API Endpoints:
- **Submit form**: `POST http://localhost:3001/api/contact`
- **View all submissions**: `GET http://localhost:3001/api/contacts`
- **Health check**: `GET http://localhost:3001/api/health`

### Example Response from `/api/contacts`:
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "John Doe",
      "email": "john@example.com",
      "message": "Hello, I'm interested in your work!",
      "created_at": "2024-01-15 10:30:00"
    }
  ],
  "count": 1
}
```

## 🚀 Quick Commands:

**Start everything in one go:**
```bash
# Terminal 1: Backend
cd backend && npm start

# Terminal 2: Frontend  
cd frontend && npm run dev
```

**Check if it's working:**
- Frontend: http://localhost:3000
- Backend API: http://localhost:3001/api/health
- View submissions: http://localhost:3001/api/contacts

Your contact form is now connected to a local SQLite database! 🎉