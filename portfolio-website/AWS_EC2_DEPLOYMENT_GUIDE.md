# 🚀 AWS EC2 Deployment Guide - Portfolio Website

Deploy your complete portfolio website on AWS EC2 with custom domain and SSL certificate.

## 🎯 What You'll Get

- **Frontend + Backend** on single EC2 instance
- **Custom domain** with SSL certificate
- **PostgreSQL database** on same instance
- **Nginx reverse proxy** for production
- **PM2 process management** for reliability
- **Free for 12 months** with AWS Free Tier

## 💰 Cost Breakdown

### AWS Free Tier (12 months)
- **EC2 t2.micro**: 750 hours/month (FREE)
- **EBS Storage**: 30 GB (FREE)
- **Data Transfer**: 15 GB/month (FREE)
- **Elastic IP**: FREE if attached to running instance

### After Free Tier (~$10-15/month)
- **EC2 t2.micro**: ~$8.50/month
- **EBS Storage**: ~$3/month
- **Data Transfer**: Pay as you go

---

# 🚀 Step 1: Launch EC2 Instance

## 1.1 Go to AWS Console
1. **Login to [AWS Console](https://console.aws.amazon.com)**
2. **Go to EC2 Dashboard**
3. **Click "Launch Instance"**

## 1.2 Configure Instance
**Name**: `portfolio-website`

**Application and OS Images**:
- **Ubuntu Server 22.04 LTS** (Free tier eligible)

**Instance Type**:
- **t2.micro** (Free tier eligible)

**Key Pair**:
- **Create new key pair** → Name: `portfolio-key`
- **Download .pem file** and save securely

**Network Settings**:
- **Create security group** with these rules:
  - **SSH (22)**: Your IP only
  - **HTTP (80)**: 0.0.0.0/0 (Anywhere)
  - **HTTPS (443)**: 0.0.0.0/0 (Anywhere)
  - **Custom TCP (3000)**: 0.0.0.0/0 (Frontend)
  - **Custom TCP (3001)**: 0.0.0.0/0 (Backend API)

**Storage**:
- **30 GB** gp3 (Free tier limit)

## 1.3 Launch Instance
- **Click "Launch Instance"**
- **Wait 2-3 minutes** for instance to start

---

# 🔗 Step 2: Connect to EC2 Instance

## 2.1 Get Connection Details
1. **Go to EC2 Instances**
2. **Select your instance**
3. **Click "Connect"**
4. **Copy the SSH command**

## 2.2 Connect via SSH

### Windows (PowerShell/Git Bash):
```bash
# Set permissions for key file
chmod 400 portfolio-key.pem

# Connect to instance
ssh -i "portfolio-key.pem" ubuntu@your-instance-public-ip
```

### Windows (PuTTY):
1. **Convert .pem to .ppk** using PuTTYgen
2. **Use .ppk file** in PuTTY authentication

---

# ⚙️ Step 3: Server Setup

## 3.1 Update System
```bash
sudo apt update && sudo apt upgrade -y
```

## 3.2 Install Node.js
```bash
# Install Node.js 18.x
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verify installation
node --version
npm --version
```

## 3.3 Install PostgreSQL
```bash
# Install PostgreSQL
sudo apt install postgresql postgresql-contrib -y

# Start and enable PostgreSQL
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Create database and user
sudo -u postgres psql
```

### In PostgreSQL prompt:
```sql
-- Create database
CREATE DATABASE portfolio_db;

-- Create user
CREATE USER portfolio_user WITH PASSWORD 'your_secure_password';

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE portfolio_db TO portfolio_user;

-- Exit
\q
```

## 3.4 Install PM2 (Process Manager)
```bash
sudo npm install -g pm2
```

## 3.5 Install Nginx
```bash
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
```

---

# 📦 Step 4: Deploy Your Application

## 4.1 Clone Repository
```bash
# Clone your repository
git clone https://github.com/LarianeMohceneMouad/SmartPortfolioPoweredChatbot.git
cd SmartPortfolioPoweredChatbot
```

## 4.2 Setup Backend
```bash
cd backend

# Install dependencies
npm install

# Create production environment file
sudo nano .env
```

### Backend .env Configuration:
```env
# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=portfolio_db
DB_USER=portfolio_user
DB_PASSWORD=your_secure_password

# Server Configuration
PORT=3001
NODE_ENV=production

# CORS Configuration
FRONTEND_URL=https://yourdomain.com

# n8n Webhook Configuration
N8N_WEBHOOK_URL=https://lmouud.app.n8n.cloud/webhook/c490c45a-1828-4ba9-84bc-3c36450218c7/chat
```

## 4.3 Setup Database Schema
```bash
# Connect to database and run schema
sudo -u postgres psql -d portfolio_db -f ../database/schema.sql
```

## 4.4 Setup Frontend
```bash
cd ../frontend

# Install dependencies
npm install

# Create production environment
sudo nano .env.production
```

### Frontend .env.production:
```env
NEXT_PUBLIC_API_URL=https://yourdomain.com/api
NEXT_PUBLIC_CHAT_WEBHOOK_URL=https://lmouud.app.n8n.cloud/webhook/c490c45a-1828-4ba9-84bc-3c36450218c7/chat
```

## 4.5 Build Frontend
```bash
npm run build
```

---

# 🔧 Step 5: Configure PM2 Process Management

## 5.1 Create PM2 Ecosystem File
```bash
cd ~/SmartPortfolioPoweredChatbot
sudo nano ecosystem.config.js
```

### ecosystem.config.js:
```javascript
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
    }
  ]
};
```

## 5.2 Start Applications with PM2
```bash
# Start both applications
pm2 start ecosystem.config.js

# Save PM2 configuration
pm2 save

# Setup PM2 to start on boot
pm2 startup
# Run the command that PM2 outputs

# Check status
pm2 status
pm2 logs
```

---

# 🌐 Step 6: Configure Nginx Reverse Proxy

## 6.1 Create Nginx Configuration
```bash
sudo nano /etc/nginx/sites-available/portfolio
```

### Nginx Configuration:
```nginx
server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;

    # Frontend (Next.js)
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }

    # Backend API
    location /api {
        proxy_pass http://localhost:3001/api;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;
}
```

## 6.2 Enable Site
```bash
# Enable site
sudo ln -s /etc/nginx/sites-available/portfolio /etc/nginx/sites-enabled/

# Remove default site
sudo rm /etc/nginx/sites-enabled/default

# Test configuration
sudo nginx -t

# Restart Nginx
sudo systemctl restart nginx
```

---

# 🔒 Step 7: Setup SSL Certificate with Let's Encrypt

## 7.1 Install Certbot
```bash
sudo apt install snapd
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
```

## 7.2 Configure Domain DNS
**Before getting SSL, configure your domain DNS:**

### At Your Domain Registrar:
```
Type: A
Name: @
Value: YOUR_EC2_PUBLIC_IP

Type: A  
Name: www
Value: YOUR_EC2_PUBLIC_IP
```

**Wait 5-30 minutes for DNS propagation**

## 7.3 Get SSL Certificate
```bash
# Get certificate for your domain
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com

# Follow the prompts:
# 1. Enter email address
# 2. Agree to terms
# 3. Choose redirect option (recommended)
```

## 7.4 Auto-renewal Setup
```bash
# Test auto-renewal
sudo certbot renew --dry-run

# Check renewal timer
sudo systemctl status snap.certbot.renew.timer
```

---

# 🚨 Step 8: Security & Monitoring

## 8.1 Configure Firewall
```bash
# Enable UFW firewall
sudo ufw enable

# Allow SSH, HTTP, HTTPS
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https

# Check status
sudo ufw status
```

## 8.2 Setup Monitoring
```bash
# Install htop for monitoring
sudo apt install htop

# Monitor processes
htop

# Monitor PM2 processes
pm2 monit
```

## 8.3 Setup Log Rotation
```bash
# Configure PM2 log rotation
pm2 install pm2-logrotate
pm2 set pm2-logrotate:max_size 10M
pm2 set pm2-logrotate:retain 30
```

---

# 🎯 Step 9: Allocate Elastic IP (Optional but Recommended)

## 9.1 Create Elastic IP
1. **Go to EC2 Dashboard** → Elastic IPs
2. **Click "Allocate Elastic IP address"**
3. **Click "Allocate"**

## 9.2 Associate with Instance
1. **Select the Elastic IP**
2. **Click "Actions" → "Associate Elastic IP address"**
3. **Select your instance**
4. **Click "Associate"**

## 9.3 Update DNS Records
Update your domain DNS with the new Elastic IP address.

---

# 🔄 Step 10: Deployment Automation

## 10.1 Create Deployment Script
```bash
sudo nano ~/deploy.sh
```

### Deployment Script:
```bash
#!/bin/bash

echo "🚀 Starting deployment..."

# Navigate to project directory
cd ~/SmartPortfolioPoweredChatbot

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
```

## 10.2 Make Script Executable
```bash
chmod +x ~/deploy.sh
```

## 10.3 Deploy Updates
```bash
# Run deployment
~/deploy.sh
```

---

# 📋 Verification Checklist

## ✅ Instance Setup
- [ ] EC2 instance running
- [ ] SSH connection working
- [ ] Security groups configured
- [ ] Elastic IP assigned (optional)

## ✅ Software Installation
- [ ] Node.js 18.x installed
- [ ] PostgreSQL installed and configured
- [ ] PM2 installed
- [ ] Nginx installed

## ✅ Application Deployment
- [ ] Repository cloned
- [ ] Dependencies installed
- [ ] Environment variables configured
- [ ] Database schema created
- [ ] Frontend built

## ✅ Process Management
- [ ] PM2 processes running
- [ ] Applications auto-restart on failure
- [ ] PM2 starts on boot

## ✅ Reverse Proxy
- [ ] Nginx configuration active
- [ ] Frontend accessible via domain
- [ ] API endpoints working
- [ ] Static files served correctly

## ✅ SSL Certificate
- [ ] Domain DNS configured
- [ ] SSL certificate obtained
- [ ] HTTPS redirect working
- [ ] Auto-renewal configured

## ✅ Security
- [ ] Firewall configured
- [ ] SSH key-based authentication
- [ ] Database access restricted
- [ ] Security headers configured

---

# 🔧 Troubleshooting

## Common Issues

### Application Not Starting
```bash
# Check PM2 logs
pm2 logs

# Check individual app logs
pm2 logs portfolio-backend
pm2 logs portfolio-frontend

# Restart applications
pm2 restart all
```

### Database Connection Issues
```bash
# Check PostgreSQL status
sudo systemctl status postgresql

# Check database connectivity
sudo -u postgres psql -d portfolio_db -c "SELECT 1;"

# Reset database password
sudo -u postgres psql
\password portfolio_user
```

### Nginx Issues
```bash
# Check Nginx status
sudo systemctl status nginx

# Test configuration
sudo nginx -t

# Check Nginx logs
sudo tail -f /var/log/nginx/error.log
```

### SSL Certificate Issues
```bash
# Check certificate status
sudo certbot certificates

# Renew certificate manually
sudo certbot renew

# Check Nginx SSL configuration
sudo nginx -t
```

### DNS Issues
```bash
# Check DNS propagation
nslookup yourdomain.com
dig yourdomain.com

# Test local connectivity
curl -I http://localhost:3000
curl -I http://localhost:3001/api/health
```

---

# 📊 Performance Optimization

## Enable Gzip Compression
```nginx
# Add to Nginx configuration
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
```

## Enable Caching
```nginx
# Add to Nginx configuration
location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
}
```

## Monitor Resource Usage
```bash
# Check memory usage
free -h

# Check disk usage
df -h

# Check CPU usage
top

# Check PM2 resource usage
pm2 monit
```

---

# 🎉 Success!

Your portfolio website is now live on AWS EC2 with:

- ✅ **Custom domain** with SSL certificate
- ✅ **Production-ready** setup with Nginx
- ✅ **Process management** with PM2
- ✅ **Database** with PostgreSQL
- ✅ **Security** with firewall and HTTPS
- ✅ **Monitoring** and logging
- ✅ **Auto-deployment** script

## 🔗 Your Website URLs
- **Frontend**: https://yourdomain.com
- **Backend API**: https://yourdomain.com/api
- **Health Check**: https://yourdomain.com/api/health

## 💡 Next Steps
1. **Monitor your application** with PM2 and system tools
2. **Set up backups** for your database
3. **Configure monitoring alerts**
4. **Optimize performance** as needed

Need help with any of these steps? Let me know!