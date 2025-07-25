@echo off
setlocal enabledelayedexpansion

rem Docker Deployment Script for Portfolio Website (Windows)

echo =====================================
echo   Portfolio Website Docker Deployment
echo =====================================
echo.

rem Check if Docker is installed
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not installed
    echo Please install Docker Desktop: https://docs.docker.com/desktop/windows/
    pause
    exit /b 1
)

rem Check if Docker Compose is available
docker-compose --version >nul 2>&1
if %errorlevel% neq 0 (
    docker compose version >nul 2>&1
    if %errorlevel% neq 0 (
        echo ❌ Docker Compose is not available
        pause
        exit /b 1
    )
    set COMPOSE_CMD=docker compose
) else (
    set COMPOSE_CMD=docker-compose
)

echo ✅ Docker and Docker Compose are available
echo.

rem Show usage if no arguments
if "%1"=="" (
    goto :show_usage
)

rem Handle commands
if "%1"=="dev" goto :start_dev
if "%1"=="prod" goto :start_prod
if "%1"=="stop" goto :stop_containers
if "%1"=="logs" goto :show_logs
if "%1"=="clean" goto :clean_all
if "%1"=="build" goto :build_images
if "%1"=="health" goto :health_check

goto :show_usage

:show_usage
echo Usage: %0 [dev^|prod^|stop^|logs^|clean^|build^|health]
echo.
echo Commands:
echo   dev     - Start development environment
echo   prod    - Start production environment with nginx
echo   stop    - Stop all containers
echo   logs    - Show logs from all containers
echo   clean   - Stop containers and remove volumes
echo   build   - Rebuild all images
echo   health  - Check container health
echo.
pause
exit /b 0

:start_dev
echo 🚀 Starting development environment...
echo.

rem Build and start containers
%COMPOSE_CMD% up --build -d

if %errorlevel% equ 0 (
    echo.
    echo ✅ Development environment started
    echo.
    echo Services available at:
    echo • Frontend: http://localhost:3000
    echo • Backend: http://localhost:3001
    echo • Database: localhost:5432
    echo.
    echo To view logs: %0 logs
    echo To stop: %0 stop
) else (
    echo ❌ Failed to start development environment
)
echo.
pause
exit /b 0

:start_prod
echo 🚀 Starting production environment...
echo.

rem Check if SSL certificates exist
if not exist "nginx\ssl\larianemohcenemouad.site.crt" (
    echo ⚠️  SSL certificates not found
    echo Creating self-signed certificates for testing...
    mkdir nginx\ssl 2>nul
    
    rem Create self-signed certificate using OpenSSL (if available)
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout nginx\ssl\larianemohcenemouad.site.key -out nginx\ssl\larianemohcenemouad.site.crt -subj "/C=US/ST=State/L=City/O=Organization/CN=larianemohcenemouad.site" 2>nul
    
    if %errorlevel% neq 0 (
        echo ⚠️  OpenSSL not found. Please install SSL certificates manually.
        echo Continuing without SSL...
    )
)

rem Build and start containers
%COMPOSE_CMD% -f docker-compose.prod.yml up --build -d

if %errorlevel% equ 0 (
    echo.
    echo ✅ Production environment started
    echo.
    echo Services available at:
    echo • Website: https://larianemohcenemouad.site (or https://localhost)
    echo • HTTP redirects to HTTPS
    echo.
    echo To view logs: %0 logs
    echo To stop: %0 stop
) else (
    echo ❌ Failed to start production environment
)
echo.
pause
exit /b 0

:stop_containers
echo 🛑 Stopping containers...
echo.

%COMPOSE_CMD% down 2>nul
%COMPOSE_CMD% -f docker-compose.prod.yml down 2>nul

echo ✅ Containers stopped
echo.
pause
exit /b 0

:show_logs
echo 📋 Container logs:
echo.

rem Check which compose file is running
%COMPOSE_CMD% ps -q >nul 2>&1
if %errorlevel% equ 0 (
    %COMPOSE_CMD% logs --tail=50
) else (
    %COMPOSE_CMD% -f docker-compose.prod.yml ps -q >nul 2>&1
    if %errorlevel% equ 0 (
        %COMPOSE_CMD% -f docker-compose.prod.yml logs --tail=50
    ) else (
        echo No containers are running
    )
)
echo.
pause
exit /b 0

:clean_all
echo 🧹 Cleaning up containers and volumes...
echo.

rem Stop and remove containers with volumes
%COMPOSE_CMD% down -v --remove-orphans 2>nul
%COMPOSE_CMD% -f docker-compose.prod.yml down -v --remove-orphans 2>nul

rem Remove images
%COMPOSE_CMD% down --rmi all 2>nul

rem Prune system
docker system prune -f

echo ✅ Cleanup completed
echo.
pause
exit /b 0

:build_images
echo 🔨 Building Docker images...
echo.

%COMPOSE_CMD% build --no-cache

if %errorlevel% equ 0 (
    echo ✅ Images built successfully
) else (
    echo ❌ Failed to build images
)
echo.
pause
exit /b 0

:health_check
echo 🏥 Checking container health...
echo.

rem Show container status
%COMPOSE_CMD% ps 2>nul

echo.
echo Health status:
rem Check backend health
%COMPOSE_CMD% exec -T backend curl -f http://localhost:3001/api/health 2>nul || echo Backend health check failed

rem Check frontend health  
%COMPOSE_CMD% exec -T frontend wget -q --spider http://localhost:3000/ 2>nul || echo Frontend health check failed

echo.
pause
exit /b 0