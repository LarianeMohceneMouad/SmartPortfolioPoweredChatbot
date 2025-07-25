# 🚀 AWS Deployment Guide - Portfolio Website

This guide covers deploying your portfolio website on AWS with a custom domain name.

## 📋 Prerequisites

- AWS Account with billing enabled
- Custom domain name (purchased from any registrar)
- AWS CLI installed and configured
- Basic understanding of AWS services

## 🏗️ Architecture Overview

```
Domain (yourname.com) 
    ↓
Route 53 (DNS)
    ↓
CloudFront (CDN + SSL)
    ↓
S3 (Frontend Static Files)

API (api.yourname.com)
    ↓ 
Application Load Balancer
    ↓
ECS/EC2 (Backend API)
    ↓
RDS (PostgreSQL Database)
```

## 🎯 Deployment Options

### Option 1: Full AWS (Recommended)
- **Frontend**: S3 + CloudFront + Route 53
- **Backend**: ECS Fargate + RDS
- **Cost**: ~$20-50/month
- **Scalability**: High

### Option 2: Hybrid (Cost-Effective)
- **Frontend**: S3 + CloudFront + Route 53
- **Backend**: Railway/Heroku
- **Cost**: ~$10-25/month
- **Scalability**: Medium

### Option 3: Simple (Easiest)
- **Everything**: AWS Amplify
- **Cost**: ~$15-30/month
- **Scalability**: Medium

---

# 🌐 Part 1: Domain & DNS Setup

## Step 1: Purchase Domain (if needed)
- Buy from any registrar (Namecheap, GoDaddy, etc.)
- Or transfer to Route 53 for easier management

## Step 2: Configure Route 53

### Create Hosted Zone
```bash
aws route53 create-hosted-zone \
    --name yourname.com \
    --caller-reference $(date +%s)
```

### Update Nameservers
1. Go to Route 53 console
2. Copy the 4 nameservers from your hosted zone
3. Update nameservers in your domain registrar

---

# 📦 Part 2: Frontend Deployment (S3 + CloudFront)

## Step 1: Prepare Frontend for Production

### Update Next.js Config
```javascript
// frontend/next.config.js
/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',
  trailingSlash: true,
  images: {
    unoptimized: true
  },
  env: {
    NEXT_PUBLIC_API_URL: 'https://api.yourname.com'
  }
}

module.exports = nextConfig
```

### Create Production Environment
```bash
# frontend/.env.production
NEXT_PUBLIC_API_URL=https://api.yourname.com
NEXT_PUBLIC_CHAT_WEBHOOK_URL=https://lmouud.app.n8n.cloud/webhook/c490c45a-1828-4ba9-84bc-3c36450218c7/chat
```

### Build Frontend
```bash
cd frontend
npm run build
```

## Step 2: Create S3 Bucket

### Create Bucket
```bash
aws s3 mb s3://yourname.com
```

### Configure as Website
```bash
aws s3 website s3://yourname.com \
    --index-document index.html \
    --error-document 404.html
```

### Upload Files
```bash
cd frontend/out
aws s3 sync . s3://yourname.com --delete
```

## Step 3: Setup CloudFront Distribution

### Create CloudFront Distribution
```json
{
  "CallerReference": "portfolio-2024",
  "DefaultRootObject": "index.html",
  "Origins": {
    "Quantity": 1,
    "Items": [
      {
        "Id": "S3-yourname.com",
        "DomainName": "yourname.com.s3.amazonaws.com",
        "S3OriginConfig": {
          "OriginAccessIdentity": ""
        }
      }
    ]
  },
  "DefaultCacheBehavior": {
    "TargetOriginId": "S3-yourname.com",
    "ViewerProtocolPolicy": "redirect-to-https",
    "TrustedSigners": {
      "Enabled": false,
      "Quantity": 0
    },
    "ForwardedValues": {
      "QueryString": false,
      "Cookies": {
        "Forward": "none"
      }
    }
  },
  "Aliases": {
    "Quantity": 2,
    "Items": ["yourname.com", "www.yourname.com"]
  },
  "ViewerCertificate": {
    "ACMCertificateArn": "arn:aws:acm:us-east-1:ACCOUNT:certificate/CERT-ID",
    "SSLSupportMethod": "sni-only"
  }
}
```

## Step 4: SSL Certificate

### Request Certificate in ACM (us-east-1 required for CloudFront)
```bash
aws acm request-certificate \
    --domain-name yourname.com \
    --subject-alternative-names www.yourname.com \
    --validation-method DNS \
    --region us-east-1
```

### Validate Certificate
1. Go to ACM console
2. Click on certificate
3. Create DNS records in Route 53
4. Wait for validation (5-30 minutes)

---

# 🔧 Part 3: Backend Deployment Options

## Option A: ECS Fargate (Recommended)

### Create Dockerfile
```dockerfile
# backend/Dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .

EXPOSE 3001

CMD ["npm", "start"]
```

### Build and Push to ECR
```bash
# Create ECR repository
aws ecr create-repository --repository-name portfolio-backend

# Get login token
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ACCOUNT.dkr.ecr.us-east-1.amazonaws.com

# Build and tag
docker build -t portfolio-backend ./backend
docker tag portfolio-backend:latest ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/portfolio-backend:latest

# Push
docker push ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/portfolio-backend:latest
```

### Create ECS Service
```yaml
# ecs-task-definition.json
{
  "family": "portfolio-backend",
  "networkMode": "awsvpc",
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "256",
  "memory": "512",
  "executionRoleArn": "arn:aws:iam::ACCOUNT:role/ecsTaskExecutionRole",
  "containerDefinitions": [
    {
      "name": "portfolio-backend",
      "image": "ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/portfolio-backend:latest",
      "portMappings": [
        {
          "containerPort": 3001,
          "protocol": "tcp"
        }
      ],
      "environment": [
        {
          "name": "NODE_ENV",
          "value": "production"
        },
        {
          "name": "PORT",
          "value": "3001"
        }
      ],
      "secrets": [
        {
          "name": "DB_HOST",
          "valueFrom": "arn:aws:ssm:us-east-1:ACCOUNT:parameter/portfolio/db-host"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/portfolio-backend",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
}
```

## Option B: Simple with Railway/Heroku

### Railway Deployment
```bash
# Install Railway CLI
npm install -g @railway/cli

# Login and deploy
railway login
railway init
railway up
```

### Environment Variables for Railway
```env
NODE_ENV=production
PORT=3001
DB_HOST=your-db-host
DB_NAME=portfolio_db
DB_USER=postgres
DB_PASSWORD=your-password
N8N_WEBHOOK_URL=https://lmouud.app.n8n.cloud/webhook/c490c45a-1828-4ba9-84bc-3c36450218c7/chat
FRONTEND_URL=https://yourname.com
```

---

# 🗄️ Part 4: Database Setup

## Option A: RDS PostgreSQL
```bash
aws rds create-db-instance \
    --db-instance-identifier portfolio-db \
    --db-instance-class db.t3.micro \
    --engine postgres \
    --master-username postgres \
    --master-user-password YourSecurePassword123 \
    --allocated-storage 20 \
    --vpc-security-group-ids sg-xxxxxxxx \
    --db-subnet-group-name default \
    --backup-retention-period 7 \
    --storage-encrypted
```

## Option B: External Database
- **Neon.tech** (PostgreSQL) - Free tier available
- **PlanetScale** (MySQL) - Free tier available
- **Supabase** (PostgreSQL) - Free tier available

---

# 🔗 Part 5: Final DNS Configuration

## Create Route 53 Records

### Main Domain (A Record)
```bash
aws route53 change-resource-record-sets \
    --hosted-zone-id Z123456789 \
    --change-batch '{
      "Changes": [{
        "Action": "CREATE",
        "ResourceRecordSet": {
          "Name": "yourname.com",
          "Type": "A",
          "AliasTarget": {
            "DNSName": "d123456789.cloudfront.net",
            "EvaluateTargetHealth": false,
            "HostedZoneId": "Z2FDTNDATAQYW2"
          }
        }
      }]
    }'
```

### WWW Subdomain (CNAME)
```bash
aws route53 change-resource-record-sets \
    --hosted-zone-id Z123456789 \
    --change-batch '{
      "Changes": [{
        "Action": "CREATE",
        "ResourceRecordSet": {
          "Name": "www.yourname.com",
          "Type": "CNAME",
          "TTL": 300,
          "ResourceRecords": [{"Value": "yourname.com"}]
        }
      }]
    }'
```

### API Subdomain
```bash
aws route53 change-resource-record-sets \
    --hosted-zone-id Z123456789 \
    --change-batch '{
      "Changes": [{
        "Action": "CREATE",
        "ResourceRecordSet": {
          "Name": "api.yourname.com",
          "Type": "CNAME",
          "TTL": 300,
          "ResourceRecords": [{"Value": "your-alb-url.us-east-1.elb.amazonaws.com"}]
        }
      }]
    }'
```

---

# 🚀 Part 6: Deployment Automation

## GitHub Actions Workflow
```yaml
# .github/workflows/deploy.yml
name: Deploy to AWS

on:
  push:
    branches: [main]

jobs:
  deploy-frontend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          
      - name: Install and Build
        run: |
          cd frontend
          npm ci
          npm run build
          
      - name: Deploy to S3
        run: |
          aws s3 sync frontend/out s3://yourname.com --delete
          aws cloudfront create-invalidation --distribution-id E123456789 --paths "/*"
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_DEFAULT_REGION: us-east-1

  deploy-backend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Build and Deploy to ECS
        run: |
          docker build -t portfolio-backend ./backend
          # Push to ECR and update ECS service
```

---

# 💰 Cost Estimation

## Monthly Costs (USD)

### Full AWS Setup
- **Route 53 Hosted Zone**: $0.50
- **CloudFront**: $1-5 (depending on traffic)
- **S3**: $1-3
- **ECS Fargate**: $15-25
- **RDS t3.micro**: $15-20
- **Load Balancer**: $18
- **Total**: ~$50-70/month

### Hybrid Setup
- **Route 53 + CloudFront + S3**: $2-8
- **Railway/Heroku Backend**: $7-20
- **External Database**: $0-10
- **Total**: ~$10-35/month

### Traffic-based costs will increase with usage

---

# ✅ Deployment Checklist

## Pre-Deployment
- [ ] Domain purchased and nameservers updated
- [ ] AWS Account setup with billing
- [ ] Environment variables configured
- [ ] Frontend built and tested
- [ ] Backend Docker image created

## Frontend Deployment
- [ ] S3 bucket created and configured
- [ ] SSL certificate requested and validated
- [ ] CloudFront distribution created
- [ ] Files uploaded to S3
- [ ] DNS records created

## Backend Deployment
- [ ] Database created and accessible
- [ ] Backend service deployed
- [ ] Environment variables set
- [ ] Health checks passing
- [ ] API subdomain configured

## Post-Deployment
- [ ] Website accessible via custom domain
- [ ] SSL certificate working (HTTPS)
- [ ] Contact form functional
- [ ] Chatbot working
- [ ] Database connections stable
- [ ] Monitoring setup

---

# 🔧 Troubleshooting

## Common Issues

### SSL Certificate Issues
- Ensure certificate is in us-east-1 region for CloudFront
- Verify DNS validation records are correct
- Wait 5-30 minutes for validation

### CloudFront Not Updating
- Create invalidation: `aws cloudfront create-invalidation --distribution-id E123456789 --paths "/*"`
- CloudFront changes take 15-30 minutes to propagate

### Backend CORS Issues
- Update FRONTEND_URL in backend environment
- Verify API subdomain is accessible
- Check security group rules

### Database Connection Issues
- Verify VPC security groups
- Check database credentials in environment variables
- Ensure database is publicly accessible if using external access

---

Need help with any specific step? Let me know which deployment option you prefer!