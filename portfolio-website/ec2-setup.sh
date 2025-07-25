#!/bin/bash

# AWS EC2 Setup Script for Portfolio Website
# Run this script on a fresh Ubuntu 22.04 EC2 instance

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 AWS EC2 Portfolio Website Setup Script${NC}"
echo "================================================"
echo "This script will set up your portfolio website on AWS EC2"
echo "Make sure you have:"
echo "• Fresh Ubuntu 22.04 EC2 instance"
echo "• Security groups configured (ports 22, 80, 443, 3000, 3001)"
echo "• Your domain name ready"
echo

# Function to prompt for user input
prompt_input() {
    local prompt="$1"
    local variable="$2"
    read -p "$prompt: " $variable
}

# Get configuration from user
echo -e "${YELLOW}📋 Configuration Setup${NC}"
prompt_input "Enter your domain name (e.g., yourdomain.com)" DOMAIN_NAME
prompt_input "Enter your GitHub repository URL" REPO_URL
prompt_input "Enter database password for portfolio_user" DB_PASSWORD
prompt_input "Enter your email for SSL certificate" EMAIL

echo
echo -e "${BLUE}🔧 Starting system setup...${NC}"

# Update system
echo -e "${YELLOW}📦 Updating system packages...${NC}"
sudo apt update && sudo apt upgrade -y

# Install Node.js 18.x
echo -e "${YELLOW}📦 Installing Node.js 18.x...${NC}"
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verify Node.js installation
echo -e "${GREEN}✅ Node.js version:${NC} $(node --version)"
echo -e "${GREEN}✅ npm version:${NC} $(npm --version)"

# Install PostgreSQL
echo -e "${YELLOW}📦 Installing PostgreSQL...${NC}"
sudo apt install postgresql postgresql-contrib -y

# Start and enable PostgreSQL
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Configure PostgreSQL
echo -e "${YELLOW}🗄️ Configuring PostgreSQL database...${NC}"
sudo -u postgres psql << EOF
CREATE DATABASE portfolio_db;
CREATE USER portfolio_user WITH PASSWORD '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON DATABASE portfolio_db TO portfolio_user;
\q
EOF

echo -e "${GREEN}✅ PostgreSQL configured${NC}"

# Install PM2 globally
echo -e "${YELLOW}📦 Installing PM2 process manager...${NC}"
sudo npm install -g pm2

# Install Nginx
echo -e "${YELLOW}📦 Installing Nginx...${NC}"
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

# Install Git (if not already installed)
echo -e "${YELLOW}📦 Installing Git...${NC}"
sudo apt install git -y

# Install UFW firewall
echo -e "${YELLOW}🔒 Configuring firewall...${NC}"
sudo ufw --force enable
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw allow 3000
sudo ufw allow 3001

echo -e "${GREEN}✅ Firewall configured${NC}"

# Clone repository
echo -e "${YELLOW}📥 Cloning repository...${NC}"
cd ~
if [ -d "SmartPortfolioPoweredChatbot" ]; then
    rm -rf SmartPortfolioPoweredChatbot
fi
git clone $REPO_URL
cd SmartPortfolioPoweredChatbot/portfolio-website

# Setup backend
echo -e "${YELLOW}🔧 Setting up backend...${NC}"
cd backend

# Install backend dependencies
npm install --production

# Create backend .env file
cat > .env << EOF
# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=portfolio_db
DB_USER=portfolio_user
DB_PASSWORD=$DB_PASSWORD

# Server Configuration
PORT=3001
NODE_ENV=production

# CORS Configuration
FRONTEND_URL=https://$DOMAIN_NAME

# n8n Webhook Configuration
N8N_WEBHOOK_URL=https://lmouud.app.n8n.cloud/webhook/c490c45a-1828-4ba9-84bc-3c36450218c7/chat
EOF

echo -e "${GREEN}✅ Backend environment configured${NC}"

# Setup database schema
echo -e "${YELLOW}🗄️ Setting up database schema...${NC}"
sudo -u postgres psql -d portfolio_db -f ../database/schema.sql

# Setup frontend
echo -e "${YELLOW}🔧 Setting up frontend...${NC}"
cd ../frontend

# Install frontend dependencies
npm install

# Create frontend production environment
cat > .env.production << EOF
NEXT_PUBLIC_API_URL=https://$DOMAIN_NAME/api
NEXT_PUBLIC_CHAT_WEBHOOK_URL=https://lmouud.app.n8n.cloud/webhook/c490c45a-1828-4ba9-84bc-3c36450218c7/chat
EOF

# Build frontend
echo -e "${YELLOW}🏗️ Building frontend...${NC}"
npm run build

echo -e "${GREEN}✅ Frontend built successfully${NC}"

# Create PM2 ecosystem file
echo -e "${YELLOW}⚙️ Creating PM2 configuration...${NC}"
cd ~/SmartPortfolioPoweredChatbot/portfolio-website

cat > ecosystem.config.js << EOF
module.exports = {
  apps: [
    {
      name: 'portfolio-backend',
      script: './backend/server.js',
      cwd: './backend',
      env: {
        NODE_ENV: 'production',
        PORT: 3001
      },
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',
      error_file: './logs/backend-error.log',
      out_file: './logs/backend-out.log',
      log_file: './logs/backend-combined.log',
    },
    {
      name: 'portfolio-frontend',
      script: 'npm',
      args: 'start',
      cwd: './frontend',
      env: {
        NODE_ENV: 'production',
        PORT: 3000
      },
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',
      error_file: './logs/frontend-error.log',
      out_file: './logs/frontend-out.log',
      log_file: './logs/frontend-combined.log',
    }
  ]
};
EOF

# Create logs directory
mkdir -p logs

# Start applications with PM2
echo -e "${YELLOW}🚀 Starting applications with PM2...${NC}"
pm2 start ecosystem.config.js

# Save PM2 configuration
pm2 save

# Setup PM2 to start on boot
pm2 startup
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u ubuntu --hp /home/ubuntu

echo -e "${GREEN}✅ Applications started with PM2${NC}"

# Configure Nginx
echo -e "${YELLOW}🌐 Configuring Nginx...${NC}"

# Remove default site
sudo rm -f /etc/nginx/sites-enabled/default

# Create Nginx configuration
sudo tee /etc/nginx/sites-available/portfolio << EOF
server {
    listen 80;
    server_name $DOMAIN_NAME www.$DOMAIN_NAME;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/javascript
        application/xml+rss
        application/json;

    # Frontend (Next.js)
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }

    # Backend API
    location /api {
        proxy_pass http://localhost:3001/api;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }

    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF

# Enable site
sudo ln -s /etc/nginx/sites-available/portfolio /etc/nginx/sites-enabled/

# Test Nginx configuration
sudo nginx -t

# Restart Nginx
sudo systemctl restart nginx

echo -e "${GREEN}✅ Nginx configured and restarted${NC}"

# Install Certbot for SSL
echo -e "${YELLOW}🔒 Installing Certbot for SSL...${NC}"
sudo apt install snapd -y
sudo snap install core
sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot

# Install PM2 log rotation
echo -e "${YELLOW}📝 Setting up log rotation...${NC}"
pm2 install pm2-logrotate
pm2 set pm2-logrotate:max_size 10M
pm2 set pm2-logrotate:retain 30

# Create deployment script
echo -e "${YELLOW}📜 Creating deployment script...${NC}"
cat > ~/deploy.sh << 'EOF'
#!/bin/bash

echo "🚀 Starting deployment..."

# Navigate to project directory
cd ~/SmartPortfolioPoweredChatbot/portfolio-website

# Pull latest changes
git pull origin main

# Update backend
cd backend
npm install --production
cd ..

# Update frontend
cd frontend
npm install
npm run build
cd ..

# Restart applications
pm2 restart all

echo "✅ Deployment completed!"
EOF

chmod +x ~/deploy.sh

# Create system monitoring script
cat > ~/monitor.sh << 'EOF'
#!/bin/bash

echo "📊 System Status Report"
echo "======================="

echo "💻 System Info:"
echo "Uptime: $(uptime -p)"
echo "Load: $(uptime | awk -F'load average:' '{ print $2 }')"

echo ""
echo "💾 Memory Usage:"
free -h

echo ""
echo "💽 Disk Usage:"
df -h /

echo ""
echo "🚀 PM2 Processes:"
pm2 list

echo ""
echo "🌐 Nginx Status:"
sudo systemctl status nginx --no-pager -l

echo ""
echo "🗄️ PostgreSQL Status:"
sudo systemctl status postgresql --no-pager -l
EOF

chmod +x ~/monitor.sh

echo
echo -e "${GREEN}🎉 EC2 Setup Complete!${NC}"
echo "================================="
echo
echo -e "${BLUE}📋 What was installed:${NC}"
echo "• Node.js $(node --version)"
echo "• PostgreSQL database"
echo "• PM2 process manager"
echo "• Nginx web server"
echo "• UFW firewall"
echo "• Certbot for SSL"
echo
echo -e "${BLUE}🚀 Applications Status:${NC}"
pm2 list
echo
echo -e "${BLUE}📊 System Resources:${NC}"
echo "Memory: $(free -h | awk '/^Mem:/ {print $3 "/" $2}')"
echo "Disk: $(df -h / | awk 'NR==2{print $3 "/" $2 " (" $5 " used)"}')"
echo
echo -e "${YELLOW}🔗 Next Steps:${NC}"
echo "1. Configure your domain DNS to point to this server's IP"
echo "2. Wait for DNS propagation (5-30 minutes)"
echo "3. Run SSL certificate setup:"
echo "   ${GREEN}sudo certbot --nginx -d $DOMAIN_NAME -d www.$DOMAIN_NAME${NC}"
echo
echo -e "${YELLOW}📁 Useful Commands:${NC}"
echo "• Monitor applications: ${GREEN}pm2 monit${NC}"
echo "• View logs: ${GREEN}pm2 logs${NC}"
echo "• Deploy updates: ${GREEN}~/deploy.sh${NC}"
echo "• System status: ${GREEN}~/monitor.sh${NC}"
echo
echo -e "${YELLOW}🌐 Your website will be available at:${NC}"
echo "• http://$DOMAIN_NAME (after DNS setup)"
echo "• https://$DOMAIN_NAME (after SSL setup)"
echo
echo -e "${BLUE}🔍 Server IP Address:${NC} $(curl -s ifconfig.me)"
echo
echo -e "${GREEN}Setup completed successfully! 🎊${NC}"