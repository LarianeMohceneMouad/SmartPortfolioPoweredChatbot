# 🚀 Ngrok Deployment Setup Guide

Your frontend is already hosted on: `https://3fbb7f9377ca.ngrok-free.app`

## Steps to Fix the Backend Form Issue:

### 1. Start the Backend Server
```bash
# Navigate to backend directory
cd portfolio-website/backend

# Install dependencies (if not already done)
npm install

# Start the backend server
npm start
```

### 2. Create a New Ngrok Tunnel for Backend
Open a **new terminal/command prompt** and run:
```bash
# Create ngrok tunnel for backend (port 3001)
ngrok http 3001
```

You'll get a URL like: `https://abc123.ngrok-free.app`

### 3. Update Frontend Environment Variable
Edit `frontend/.env.local` and update the backend URL:
```env
NEXT_PUBLIC_BACKEND_URL=https://your-backend-ngrok-url.ngrok-free.app
```

### 4. Update Backend CORS Settings
Edit `backend/.env` and add your backend ngrok URL to CORS:
```env
# Update this line with your backend ngrok URL
FRONTEND_URL=https://3fbb7f9377ca.ngrok-free.app
```

### 5. Restart Both Servers
```bash
# Stop and restart frontend (Ctrl+C then restart)
cd frontend
npm run dev

# Stop and restart backend (Ctrl+C then restart)
cd backend  
npm start
```

## Alternative Solution (Simpler):
If you want to avoid running two ngrok tunnels, you can serve both frontend and backend through a single tunnel:

### Option A: Use Backend to Serve Frontend (Recommended)
1. Build the frontend:
```bash
cd frontend
npm run build
```

2. Copy the built files to backend's public folder:
```bash
# Create public folder in backend
mkdir ../backend/public
cp -r .next/static ../backend/public/
cp -r out/* ../backend/public/ # if using static export
```

3. Update backend to serve static files (I can help you with this)

### Option B: Simple Frontend-Only Solution
Remove the backend dependency and use a service like EmailJS or Formspree for contact form submissions.

## Current Status:
✅ Frontend CORS configured for your ngrok URL
✅ Environment variables set up
⏳ Need to start backend and create ngrok tunnel for it

Let me know which approach you'd prefer, and I'll help you implement it!