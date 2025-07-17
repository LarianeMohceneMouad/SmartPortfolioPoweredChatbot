@echo off
echo ========================================
echo  Setting up Backend for Ngrok
echo ========================================
echo.
echo STEP 1: First, make sure your backend is running
echo   Run this in another terminal: cd backend && npm start
echo.
echo STEP 2: Starting ngrok tunnel for backend (port 3001)
echo   This will give you a URL like: https://abc123.ngrok-free.app
echo.
echo IMPORTANT: Copy the HTTPS URL that appears below!
echo You'll need to update frontend/.env.local with this URL
echo.
echo Press any key to start ngrok tunnel...
pause >nul
echo.
ngrok http 3001