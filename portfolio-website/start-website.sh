#!/bin/bash

echo "========================================"
echo "    Starting Portfolio Website"
echo "========================================"
echo

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js is not installed or not in PATH${NC}"
    echo "Please install Node.js from https://nodejs.org/"
    exit 1
fi

echo -e "${GREEN}✅ Node.js detected:${NC} $(node --version)"

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ npm is not installed or not in PATH${NC}"
    exit 1
fi

echo -e "${GREEN}✅ npm detected:${NC} $(npm --version)"
echo

# Check if dependencies are installed
echo -e "${BLUE}🔍 Checking dependencies...${NC}"

if [ ! -d "frontend/node_modules" ]; then
    echo -e "${YELLOW}📦 Installing frontend dependencies...${NC}"
    cd frontend
    npm install
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Failed to install frontend dependencies${NC}"
        exit 1
    fi
    cd ..
fi

if [ ! -d "backend/node_modules" ]; then
    echo -e "${YELLOW}📦 Installing backend dependencies...${NC}"
    cd backend
    npm install
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Failed to install backend dependencies${NC}"
        exit 1
    fi
    cd ..
fi

echo -e "${GREEN}✅ Dependencies ready${NC}"
echo

# Check environment files
echo -e "${BLUE}🔧 Checking environment configuration...${NC}"

if [ ! -f "backend/.env" ]; then
    echo -e "${YELLOW}⚠️  Backend .env file not found!${NC}"
    echo "Creating from template..."
    cp "backend/.env.example" "backend/.env"
    echo -e "${YELLOW}❗ Please edit backend/.env with your database credentials${NC}"
    echo "Press Enter to continue anyway..."
    read
fi

if [ ! -f "frontend/.env.local" ]; then
    echo -e "${YELLOW}⚠️  Frontend .env.local file not found!${NC}"
    echo "You may need to configure environment variables"
fi

echo -e "${GREEN}✅ Environment files checked${NC}"
echo

# Function to cleanup background processes on exit
cleanup() {
    echo
    echo -e "${YELLOW}🛑 Stopping servers...${NC}"
    jobs -p | xargs -r kill
    exit 0
}

# Set trap to cleanup on script exit
trap cleanup SIGINT SIGTERM

# Start the servers
echo -e "${BLUE}🚀 Starting servers...${NC}"
echo
echo -e "${GREEN}📱 Frontend will be available at:${NC} http://localhost:3000"
echo -e "${GREEN}🔧 Backend will be available at:${NC} http://localhost:3001"
echo
echo -e "${YELLOW}Press Ctrl+C to stop both servers${NC}"
echo

# Check if root package.json exists with dev script
if [ -f "package.json" ] && grep -q '"dev"' package.json; then
    echo -e "${BLUE}🎯 Starting with root package.json script...${NC}"
    npm run dev
else
    echo -e "${BLUE}🎯 Starting servers manually...${NC}"
    
    # Start backend in background
    echo "Starting backend server..."
    cd backend
    npm run dev &
    BACKEND_PID=$!
    cd ..
    
    # Wait a moment for backend to start
    sleep 2
    
    # Start frontend in foreground
    echo "Starting frontend server..."
    cd frontend
    npm run dev
    cd ..
fi

echo
echo -e "${GREEN}👋 Servers stopped${NC}"