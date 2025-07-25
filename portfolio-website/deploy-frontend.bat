@echo off
setlocal enabledelayedexpansion

rem Frontend Deployment Script for AWS S3 + CloudFront (Windows)
rem Usage: deploy-frontend.bat [bucket-name] [distribution-id]

echo ========================================
echo   Frontend Deployment to AWS
echo ========================================
echo.

set BUCKET_NAME=%1
set DISTRIBUTION_ID=%2
set BUILD_DIR=frontend\out

if "%BUCKET_NAME%"=="" set BUCKET_NAME=yourname.com

rem Check if AWS CLI is installed
aws --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ AWS CLI is not installed
    echo Please install AWS CLI: https://aws.amazon.com/cli/
    pause
    exit /b 1
)

rem Check if AWS is configured
aws sts get-caller-identity >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ AWS CLI is not configured
    echo Please run: aws configure
    pause
    exit /b 1
)

echo ✅ AWS CLI configured
echo.

rem Check bucket name
if "%BUCKET_NAME%"=="yourname.com" (
    echo ⚠️  Using default bucket name: yourname.com
    echo Please provide your actual bucket name as first argument
    echo Usage: %0 your-bucket-name [distribution-id]
    set /p CONTINUE="Continue anyway? (y/N): "
    if /i not "!CONTINUE!"=="y" exit /b 1
)

rem Build the frontend
echo 🔨 Building frontend...
cd frontend

rem Install dependencies if needed
if not exist "node_modules" (
    echo 📦 Installing dependencies...
    npm install
    if %errorlevel% neq 0 (
        echo ❌ Dependency installation failed
        pause
        exit /b 1
    )
)

rem Build for production
echo 🏗️  Building for production...
npm run build
if %errorlevel% neq 0 (
    echo ❌ Build failed
    pause
    exit /b 1
)

cd ..

rem Check if build directory exists
if not exist "%BUILD_DIR%" (
    echo ❌ Build directory not found: %BUILD_DIR%
    pause
    exit /b 1
)

echo ✅ Build completed successfully
echo.

rem Check if S3 bucket exists
echo 🔍 Checking S3 bucket...
aws s3 ls "s3://%BUCKET_NAME%" >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  Bucket %BUCKET_NAME% does not exist
    set /p CREATE_BUCKET="Create bucket? (y/N): "
    if /i "!CREATE_BUCKET!"=="y" (
        echo 🪣 Creating S3 bucket...
        aws s3 mb "s3://%BUCKET_NAME%"
        if %errorlevel% neq 0 (
            echo ❌ Failed to create bucket
            pause
            exit /b 1
        )
        
        rem Configure bucket for website hosting
        aws s3 website "s3://%BUCKET_NAME%" --index-document index.html --error-document 404.html
        echo ✅ Bucket created and configured
    ) else (
        echo ❌ Deployment cancelled
        pause
        exit /b 1
    )
)

rem Sync files to S3
echo 📤 Uploading files to S3...

rem Upload static assets with long cache
aws s3 sync "%BUILD_DIR%" "s3://%BUCKET_NAME%" --delete --cache-control "public,max-age=31536000,immutable" --exclude "*.html" --exclude "*.xml" --exclude "*.txt"

rem Upload HTML files with short cache
aws s3 sync "%BUILD_DIR%" "s3://%BUCKET_NAME%" --delete --cache-control "public,max-age=0,must-revalidate" --include "*.html" --include "*.xml" --include "*.txt"

if %errorlevel% neq 0 (
    echo ❌ Upload failed
    pause
    exit /b 1
)

echo ✅ Files uploaded successfully
echo.

rem CloudFront invalidation
if not "%DISTRIBUTION_ID%"=="" (
    echo 🔄 Creating CloudFront invalidation...
    aws cloudfront create-invalidation --distribution-id "%DISTRIBUTION_ID%" --paths "/*" >nul 2>&1
    if %errorlevel% equ 0 (
        echo ✅ CloudFront invalidation created
        echo ⏳ Note: CloudFront changes may take 15-30 minutes to propagate
    ) else (
        echo ⚠️  CloudFront invalidation failed
    )
) else (
    echo ⚠️  No CloudFront distribution ID provided
    echo To invalidate CloudFront cache, run:
    echo aws cloudfront create-invalidation --distribution-id YOUR_DISTRIBUTION_ID --paths "/*"
)

echo.
echo 🎉 Deployment completed successfully!
echo ========================================
echo Website URL: http://%BUCKET_NAME%.s3-website-us-east-1.amazonaws.com
if not "%DISTRIBUTION_ID%"=="" (
    echo CloudFront URL: https://your-cloudfront-domain.cloudfront.net
)
echo Custom Domain: https://%BUCKET_NAME% (if configured)
echo.
echo 📋 Next Steps:
echo 1. Configure your custom domain in Route 53
echo 2. Set up SSL certificate in ACM
echo 3. Configure CloudFront distribution
echo 4. Update DNS records
echo.
echo See AWS_DEPLOYMENT_GUIDE.md for detailed instructions
echo.
pause