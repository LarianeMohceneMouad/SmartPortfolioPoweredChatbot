@echo off
echo ========================================
echo    Starting Portfolio Website
echo ========================================
echo.

:: Check if Node.js is installed
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js is not installed or not in PATH
    echo Please install Node.js from https://nodejs.org/
    pause
    exit /b 1
)

echo ✅ Node.js detected: 
node --version

:: Check if npm is installed
npm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ npm is not installed or not in PATH
    pause
    exit /b 1
)

echo ✅ npm detected: 
npm --version
echo.

:: Check if dependencies are installed
echo 🔍 Checking dependencies...

if not exist "frontend\node_modules" (
    echo 📦 Installing frontend dependencies...
    cd frontend
    npm install
    if %errorlevel% neq 0 (
        echo ❌ Failed to install frontend dependencies
        pause
        exit /b 1
    )
    cd ..
)

if not exist "backend\node_modules" (
    echo 📦 Installing backend dependencies...
    cd backend
    npm install
    if %errorlevel% neq 0 (
        echo ❌ Failed to install backend dependencies
        pause
        exit /b 1
    )
    cd ..
)

echo ✅ Dependencies ready
echo.

:: Check environment files
echo 🔧 Checking environment configuration...

if not exist "backend\.env" (
    echo ⚠️  Backend .env file not found!
    echo Creating from template...
    copy "backend\.env.example" "backend\.env"
    echo ❗ Please edit backend\.env with your database credentials
    echo Press any key to continue anyway...
    pause >nul
)

if not exist "frontend\.env.local" (
    echo ⚠️  Frontend .env.local file not found!
    echo You may need to configure environment variables
)

echo ✅ Environment files checked
echo.

:: Start the servers
echo 🚀 Starting servers...
echo.
echo 📱 Frontend will be available at: http://localhost:3000
echo 🔧 Backend will be available at: http://localhost:3001
echo.
echo Press Ctrl+C to stop both servers
echo.

:: Use npm run dev from root (should start both servers concurrently)
if exist "package.json" (
    echo 🎯 Starting with root package.json script...
    npm run dev
) else (
    echo 🎯 Starting servers manually...
    :: Start backend in background
    cd backend
    start "Backend Server" cmd /k "npm run dev"
    cd ..
    
    :: Start frontend in foreground
    cd frontend
    npm run dev
    cd ..
)

echo.
echo 👋 Servers stopped
pause