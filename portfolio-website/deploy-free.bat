@echo off
setlocal enabledelayedexpansion

rem Free Deployment Script for Portfolio Website (Windows)
rem Deploys frontend to Vercel and backend to Railway

echo =======================================
echo   FREE Portfolio Deployment Script
echo =======================================
echo This script will deploy your portfolio for FREE using:
echo • Frontend: Vercel
echo • Backend: Railway  
echo • Database: Railway PostgreSQL
echo.

rem Check Node.js
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js is not installed
    pause
    exit /b 1
)

echo ✅ Node.js: 
node --version

rem Check npm
npm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ npm is not installed
    pause
    exit /b 1
)

echo ✅ npm: 
npm --version

rem Check git
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ git is not installed
    pause
    exit /b 1
)

echo ✅ git installed
echo.

rem Check if this is a git repository
if not exist ".git" (
    echo ⚠️  This is not a git repository
    set /p INIT_GIT="Initialize git repository? (y/N): "
    if /i "!INIT_GIT!"=="y" (
        git init
        git add .
        git commit -m "Initial commit for deployment"
        echo ✅ Git repository initialized
    ) else (
        echo ❌ Git repository required for deployment
        pause
        exit /b 1
    )
)

rem Check for uncommitted changes
git diff-index --quiet HEAD -- >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  You have uncommitted changes
    set /p COMMIT_CHANGES="Commit changes before deployment? (y/N): "
    if /i "!COMMIT_CHANGES!"=="y" (
        git add .
        set /p COMMIT_MSG="Commit message: "
        git commit -m "!COMMIT_MSG!"
        echo ✅ Changes committed
    )
)

rem Check remote origin
git remote get-url origin >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  No remote origin found
    echo You need to push your code to GitHub first
    set /p REPO_URL="GitHub repository URL: "
    git remote add origin "!REPO_URL!"
    git push -u origin main
    echo ✅ Code pushed to GitHub
)

echo 🚀 Starting deployment process...
echo.

rem Install Vercel CLI if not present
vercel --version >nul 2>&1
if %errorlevel% neq 0 (
    echo 📦 Installing Vercel CLI...
    npm install -g vercel
    if %errorlevel% neq 0 (
        echo ❌ Failed to install Vercel CLI
        pause
        exit /b 1
    )
    echo ✅ Vercel CLI installed
)

rem Install Railway CLI if not present
railway --version >nul 2>&1
if %errorlevel% neq 0 (
    echo 📦 Installing Railway CLI...
    npm install -g @railway/cli
    if %errorlevel% neq 0 (
        echo ❌ Failed to install Railway CLI
        pause
        exit /b 1
    )
    echo ✅ Railway CLI installed
)

echo.

rem Deploy Backend to Railway
echo 🚂 Deploying backend to Railway...
echo.

rem Check if logged in to Railway
railway whoami >nul 2>&1
if %errorlevel% neq 0 (
    echo 🔐 Please login to Railway
    railway login
)

cd backend

rem Check if Railway project is linked
if not exist ".railway" (
    echo 🔗 Linking Railway project...
    railway init
)

rem Deploy backend
echo 📤 Deploying backend...
railway up

if %errorlevel% equ 0 (
    echo ✅ Backend deployed successfully to Railway
    rem Get Railway URL (simplified for batch)
    echo 🔗 Check your Railway dashboard for the backend URL
) else (
    echo ❌ Backend deployment failed
    pause
    exit /b 1
)

cd ..

rem Deploy Frontend to Vercel
echo.
echo ▲ Deploying frontend to Vercel...
echo.

rem Check if logged in to Vercel
vercel whoami >nul 2>&1
if %errorlevel% neq 0 (
    echo 🔐 Please login to Vercel
    vercel login
)

cd frontend

rem Deploy frontend
echo 📤 Deploying frontend...
vercel --prod

if %errorlevel% equ 0 (
    echo ✅ Frontend deployed successfully to Vercel
    echo 🔗 Check your Vercel dashboard for the frontend URL
) else (
    echo ❌ Frontend deployment failed
    pause
    exit /b 1
)

cd ..

echo.
echo 🎉 Deployment completed successfully!
echo ============================================
echo Frontend: Check Vercel dashboard
echo Backend: Check Railway dashboard
echo.
echo 📋 Next Steps:
echo 1. Add custom domain in Vercel dashboard
echo 2. Configure DNS settings at your domain registrar
echo 3. SSL certificate will be automatically provisioned
echo 4. Update environment variables with actual URLs
echo.
echo 💡 Pro Tips:
echo • Both services auto-deploy on git push
echo • Railway gives you $5/month credit
echo • Vercel provides 100GB bandwidth/month
echo • Your website is now globally distributed via CDN
echo.
echo 🔗 Useful Links:
echo • Vercel Dashboard: https://vercel.com/dashboard
echo • Railway Dashboard: https://railway.app/dashboard
echo • Add custom domain: https://vercel.com/docs/custom-domains
echo.
echo 🎊 Your portfolio is now live and FREE!
echo.
pause