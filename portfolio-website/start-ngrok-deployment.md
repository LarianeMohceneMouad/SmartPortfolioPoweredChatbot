# 🚀 Complete Ngrok Deployment Setup

## Step-by-Step Instructions to Get Your Database-Backed Contact Form Working

### 📋 Prerequisites
Make sure you have ngrok installed. If not:
```bash
# Install ngrok (choose one method)
# Method 1: Download from https://ngrok.com/download
# Method 2: Using chocolatey (Windows)
choco install ngrok

# Method 3: Using npm
npm install -g ngrok
```

### 🗄️ Step 1: Start the Backend Server
Open **Terminal/Command Prompt #1**:
```bash
# Navigate to backend directory
cd portfolio-website/backend

# Install dependencies (if not done)
npm install

# Start the backend server
npm start
```

You should see:
```
✅ Server running on port 3001
🌍 Environment: development
📡 API Health: http://localhost:3001/api/health
```

### 🌐 Step 2: Create Backend Ngrok Tunnel
Open **Terminal/Command Prompt #2**:
```bash
# Create ngrok tunnel for backend (port 3001)
ngrok http 3001
```

You'll get output like:
```
Forwarding    https://abc123def.ngrok-free.app -> http://localhost:3001
```

**COPY THE HTTPS URL** (e.g., `https://abc123def.ngrok-free.app`)

### ⚙️ Step 3: Update Frontend Configuration
Edit `frontend/.env.local` and replace the placeholder with your actual backend ngrok URL:

```env
# Replace this line:
NEXT_PUBLIC_BACKEND_URL=https://placeholder-backend-ngrok-url.ngrok-free.app

# With your actual backend ngrok URL:
NEXT_PUBLIC_BACKEND_URL=https://abc123def.ngrok-free.app
```

### 🔄 Step 4: Restart Frontend
Open **Terminal/Command Prompt #3**:
```bash
# Navigate to frontend directory
cd portfolio-website/frontend

# Stop the current frontend server (Ctrl+C)
# Then restart it
npm run dev
```

### ✅ Step 5: Test the Contact Form
1. Go to your frontend: `https://3fbb7f9377ca.ngrok-free.app`
2. Navigate to the Contact section
3. Fill out and submit the form
4. The message should be stored in your database!

### 🔍 Step 6: Verify Database Storage
You can check if messages are being stored by visiting your backend health endpoint:
```
https://your-backend-ngrok-url.ngrok-free.app/api/contacts
```

## 🛠️ Troubleshooting

### CORS Errors:
- Make sure your frontend ngrok URL (`https://3fbb7f9377ca.ngrok-free.app`) is listed in the backend CORS settings
- Check that the backend ngrok URL is correctly set in frontend `.env.local`

### Database Errors:
- The backend is configured to use SQLite by default (no PostgreSQL setup needed)
- Database tables are created automatically when the server starts

### Ngrok Issues:
- Free ngrok URLs change each time you restart ngrok
- You'll need to update the `.env.local` file each time you get a new backend URL
- Consider upgrading to ngrok paid plan for persistent URLs

## 🎯 Current Setup:
- ✅ Frontend: `https://3fbb7f9377ca.ngrok-free.app`
- ⏳ Backend: `https://YOUR-BACKEND-URL.ngrok-free.app` (you need to create this)
- ✅ Database: SQLite (automatic setup)
- ✅ CORS: Configured for your frontend URL

## 📝 Summary of Required Terminals:
1. **Terminal 1**: Backend server (`npm start`)
2. **Terminal 2**: Backend ngrok (`ngrok http 3001`)
3. **Terminal 3**: Frontend server (`npm run dev`)

Keep all three terminals running for the full setup to work!