#!/bin/bash

# Free Deployment Script for Portfolio Website
# Deploys frontend to Vercel and backend to Railway

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🆓 FREE Portfolio Deployment Script${NC}"
echo "====================================="
echo "This script will deploy your portfolio for FREE using:"
echo "• Frontend: Vercel"
echo "• Backend: Railway"
echo "• Database: Railway PostgreSQL"
echo

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
echo -e "${BLUE}🔍 Checking prerequisites...${NC}"

# Check Node.js
if ! command_exists node; then
    echo -e "${RED}❌ Node.js is not installed${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Node.js:${NC} $(node --version)"

# Check npm
if ! command_exists npm; then
    echo -e "${RED}❌ npm is not installed${NC}"
    exit 1
fi
echo -e "${GREEN}✅ npm:${NC} $(npm --version)"

# Check git
if ! command_exists git; then
    echo -e "${RED}❌ git is not installed${NC}"
    exit 1
fi
echo -e "${GREEN}✅ git:${NC} $(git --version | head -n1)"

echo

# Check if this is a git repository
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}⚠️  This is not a git repository${NC}"
    read -p "Initialize git repository? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git init
        git add .
        git commit -m "Initial commit for deployment"
        echo -e "${GREEN}✅ Git repository initialized${NC}"
    else
        echo -e "${RED}❌ Git repository required for deployment${NC}"
        exit 1
    fi
fi

# Check if code is committed
if ! git diff-index --quiet HEAD --; then
    echo -e "${YELLOW}⚠️  You have uncommitted changes${NC}"
    read -p "Commit changes before deployment? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git add .
        read -p "Commit message: " commit_message
        git commit -m "$commit_message"
        echo -e "${GREEN}✅ Changes committed${NC}"
    fi
fi

# Check if remote origin exists
if ! git remote get-url origin >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  No remote origin found${NC}"
    echo "You need to push your code to GitHub first"
    read -p "GitHub repository URL: " repo_url
    git remote add origin "$repo_url"
    git push -u origin main
    echo -e "${GREEN}✅ Code pushed to GitHub${NC}"
fi

echo -e "${BLUE}🚀 Starting deployment process...${NC}"
echo

# Install Vercel CLI if not present
if ! command_exists vercel; then
    echo -e "${YELLOW}📦 Installing Vercel CLI...${NC}"
    npm install -g vercel
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Failed to install Vercel CLI${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Vercel CLI installed${NC}"
fi

# Install Railway CLI if not present
if ! command_exists railway; then
    echo -e "${YELLOW}📦 Installing Railway CLI...${NC}"
    npm install -g @railway/cli
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Failed to install Railway CLI${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Railway CLI installed${NC}"
fi

echo

# Deploy Backend to Railway
echo -e "${BLUE}🚂 Deploying backend to Railway...${NC}"
echo

# Check if already logged in to Railway
if ! railway whoami >/dev/null 2>&1; then
    echo -e "${YELLOW}🔐 Please login to Railway${NC}"
    railway login
fi

cd backend

# Check if Railway project is linked
if [ ! -f ".railway" ]; then
    echo -e "${YELLOW}🔗 Linking Railway project...${NC}"
    railway init
fi

# Deploy backend
echo -e "${BLUE}📤 Deploying backend...${NC}"
railway up

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Backend deployed successfully to Railway${NC}"
    RAILWAY_URL=$(railway status --json | grep -o '"url":"[^"]*"' | cut -d'"' -f4)
    echo -e "${BLUE}🔗 Backend URL:${NC} $RAILWAY_URL"
else
    echo -e "${RED}❌ Backend deployment failed${NC}"
    exit 1
fi

cd ..

# Deploy Frontend to Vercel
echo
echo -e "${BLUE}▲ Deploying frontend to Vercel...${NC}"
echo

# Check if already logged in to Vercel
if ! vercel whoami >/dev/null 2>&1; then
    echo -e "${YELLOW}🔐 Please login to Vercel${NC}"
    vercel login
fi

cd frontend

# Set environment variables for production
if [ -n "$RAILWAY_URL" ]; then
    echo -e "${BLUE}🔧 Setting environment variables...${NC}"
    vercel env add NEXT_PUBLIC_API_URL production <<< "$RAILWAY_URL"
    vercel env add NEXT_PUBLIC_CHAT_WEBHOOK_URL production <<< "https://lmouud.app.n8n.cloud/webhook/c490c45a-1828-4ba9-84bc-3c36450218c7/chat"
fi

# Deploy frontend
echo -e "${BLUE}📤 Deploying frontend...${NC}"
vercel --prod

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Frontend deployed successfully to Vercel${NC}"
    VERCEL_URL=$(vercel ls | grep "✅" | awk '{print $2}' | head -1)
    echo -e "${BLUE}🔗 Frontend URL:${NC} https://$VERCEL_URL"
else
    echo -e "${RED}❌ Frontend deployment failed${NC}"
    exit 1
fi

cd ..

echo
echo -e "${GREEN}🎉 Deployment completed successfully!${NC}"
echo "============================================"
echo -e "${BLUE}Frontend:${NC} https://$VERCEL_URL"
echo -e "${BLUE}Backend:${NC} $RAILWAY_URL"
echo
echo -e "${YELLOW}📋 Next Steps:${NC}"
echo "1. Add custom domain in Vercel dashboard"
echo "2. Configure DNS settings at your domain registrar"
echo "3. SSL certificate will be automatically provisioned"
echo "4. Monitor your apps in Railway and Vercel dashboards"
echo
echo -e "${GREEN}💡 Pro Tips:${NC}"
echo "• Both services auto-deploy on git push"
echo "• Railway gives you $5/month credit (enough for small apps)"
echo "• Vercel provides 100GB bandwidth/month"
echo "• Your website is now globally distributed via CDN"
echo
echo -e "${BLUE}🔗 Useful Links:${NC}"
echo "• Vercel Dashboard: https://vercel.com/dashboard"
echo "• Railway Dashboard: https://railway.app/dashboard"
echo "• Add custom domain: https://vercel.com/docs/custom-domains"
echo
echo -e "${GREEN}🎊 Your portfolio is now live and FREE!${NC}"