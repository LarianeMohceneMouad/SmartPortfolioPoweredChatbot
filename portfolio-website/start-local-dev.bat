@echo off
title Portfolio - Starting Local Development
echo.
echo ============================================
echo  Portfolio Website - Local Development
echo ============================================
echo.
echo Starting backend server and frontend...
echo.

REM Start backend in a new window
echo Starting backend server (localhost:3001)...
start "Backend Server" cmd /k "cd /d "%~dp0backend" && npm start"

REM Wait a moment for backend to start
timeout /t 3 /nobreak >nul

REM Start frontend in a new window  
echo Starting frontend server (localhost:3000)...
start "Frontend Server" cmd /k "cd /d "%~dp0frontend" && npm run dev"

echo.
echo ============================================
echo  Servers Starting...
echo ============================================
echo  Frontend: http://localhost:3000
echo  Backend:  http://localhost:3001
echo  API:      http://localhost:3001/api/health
echo  Database: SQLite (backend/portfolio.db)
echo ============================================
echo.
echo Both servers are starting in separate windows.
echo Press any key to close this message...
pause >nul