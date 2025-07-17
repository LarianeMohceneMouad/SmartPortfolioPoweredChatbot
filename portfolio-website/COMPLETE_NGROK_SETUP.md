# 🚀 Complete Ngrok Frontend-Backend-Database Setup

## 🎯 Your Current Ngrok URLs:
- **Frontend**: `https://0c34718a0e7a.ngrok-free.app` (port 3000)
- **Backend**: `https://758e5e477ef7.ngrok-free.app` (port 3001)

## 📋 Step-by-Step Complete Setup

### Step 1: Stop All Running Servers
Stop any running servers with `Ctrl+C`:
- Backend server
- Frontend server
- Both ngrok tunnels

### Step 2: Start Backend Server
```bash
cd backend
npm start
```
✅ Should see: "Server running on port 3001" and "SQLite database tables created successfully"

### Step 3: Start Backend Ngrok Tunnel
**New Terminal:**
```bash
ngrok http 3001
```
✅ Note the HTTPS URL (should be: `https://758e5e477ef7.ngrok-free.app`)

### Step 4: Test Backend Directly
**In browser, visit:**
`https://758e5e477ef7.ngrok-free.app/api/health`

**Expected response:**
```json
{
  "success": true,
  "message": "API is healthy",
  "timestamp": "2024-..."
}
```

### Step 5: Update Frontend Config
Edit `frontend/.env.local`:
```env
NEXT_PUBLIC_BACKEND_URL=https://758e5e477ef7.ngrok-free.app
```

### Step 6: Start Frontend Server
**New Terminal:**
```bash
cd frontend
npm run dev
```

### Step 7: Start Frontend Ngrok Tunnel
**New Terminal:**
```bash
ngrok http 3000
```
✅ Note the HTTPS URL (should be: `https://0c34718a0e7a.ngrok-free.app`)

### Step 8: Test Complete Flow
1. **Visit**: `https://0c34718a0e7a.ngrok-free.app`
2. **Go to Contact section**
3. **Fill form and submit**
4. **Check browser console (F12)** for logs

### Step 9: Verify Database Storage
**Visit**: `https://758e5e477ef7.ngrok-free.app/api/contacts`
Should show any submitted form data.

## 🛠️ Fixes Applied

### CORS Issues Fixed:
- ✅ Backend now accepts all origins (for ngrok testing)
- ✅ Added `ngrok-skip-browser-warning` header
- ✅ Extended timeout to 15 seconds

### Database Connection:
- ✅ SQLite database auto-created
- ✅ Contact table with proper validation
- ✅ API endpoints working

### Frontend Configuration:
- ✅ Environment variable properly set
- ✅ Axios configured with ngrok headers
- ✅ Better error logging

## 🎯 Quick Test Commands

**Test Backend Health:**
```bash
curl -H "ngrok-skip-browser-warning: true" https://758e5e477ef7.ngrok-free.app/api/health
```

**Test Form Submission:**
```bash
curl -X POST https://758e5e477ef7.ngrok-free.app/api/contact \
  -H "Content-Type: application/json" \
  -H "ngrok-skip-browser-warning: true" \
  -d '{"name":"Test User","email":"test@example.com","message":"This is a test message from curl"}'
```

**View All Contacts:**
```bash
curl -H "ngrok-skip-browser-warning: true" https://758e5e477ef7.ngrok-free.app/api/contacts
```

## 🐛 Troubleshooting

### If Backend Health Check Fails:
1. Make sure backend server is running (`npm start`)
2. Make sure ngrok tunnel is active
3. Check for firewall/antivirus blocking

### If Form Still Shows Error:
1. Open browser console (F12)
2. Look for detailed error messages
3. Check network tab for failed requests
4. Verify the backend URL in console logs

### If Database Not Working:
1. Check backend terminal for database errors
2. Verify `backend/portfolio.db` file exists
3. Test with curl commands above

## 🎉 Success Indicators

✅ **Backend Health**: `https://758e5e477ef7.ngrok-free.app/api/health` returns JSON
✅ **Form Submission**: Console shows "Response: {success: true, ...}"
✅ **Database Storage**: `/api/contacts` shows submitted data
✅ **No CORS Errors**: No CORS messages in browser console

## 🔄 If URLs Change

Ngrok free URLs change each restart. If you restart ngrok:

1. **Update frontend/.env.local** with new backend URL
2. **Restart frontend server**
3. **Test connection again**

Your complete stack should now work: Frontend → Ngrok → Backend → Database! 🎯