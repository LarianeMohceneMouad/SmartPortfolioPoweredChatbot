@echo off
echo Creating ngrok tunnel for backend (port 3001)...
echo.
echo IMPORTANT: Copy the HTTPS URL that appears below
echo You'll need to update frontend/.env.local with this URL
echo.
ngrok http 3001
pause