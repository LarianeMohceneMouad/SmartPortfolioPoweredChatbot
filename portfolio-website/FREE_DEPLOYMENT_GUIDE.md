# 🆓 FREE Deployment Guide - Portfolio Website

Deploy your complete portfolio website **100% FREE** using modern hosting platforms with generous free tiers.

## 🎯 Free Deployment Options

### Option 1: Vercel + Railway (Recommended)
- **Frontend**: Vercel (Free tier)
- **Backend**: Railway (Free $5/month credit)
- **Database**: Railway PostgreSQL (Free)
- **Domain**: Custom domain support
- **SSL**: Automatic HTTPS
- **Cost**: **$0/month** (Railway gives $5 monthly credit)

### Option 2: Netlify + Render
- **Frontend**: Netlify (Free tier)
- **Backend**: Render (Free tier)
- **Database**: Supabase (Free tier)
- **Cost**: **$0/month**

### Option 3: GitHub Pages + Heroku
- **Frontend**: GitHub Pages (Free)
- **Backend**: Heroku (Free dyno hours)
- **Database**: Heroku Postgres (Free)
- **Cost**: **$0/month**

---

# 🌟 Option 1: Vercel + Railway (Recommended)

## Why This Option?
- ✅ **Easiest setup** with GitHub integration
- ✅ **Automatic deployments** on git push
- ✅ **Custom domain** with SSL
- ✅ **Fast CDN** for frontend
- ✅ **No sleep/cold starts** on Railway
- ✅ **Production-ready** performance

---

## 🚀 Step 1: Deploy Frontend to Vercel

### 1.1 Prepare Your Repository
```bash
# Push your code to GitHub if not already done
git add .
git commit -m "Prepare for deployment"
git push origin main
```

### 1.2 Deploy to Vercel
1. **Go to [vercel.com](https://vercel.com)**
2. **Sign up/Login** with GitHub
3. **Click "New Project"**
4. **Import your portfolio repository**
5. **Configure project**:
   - **Framework Preset**: Next.js
   - **Root Directory**: `frontend`
   - **Build Command**: `npm run build`
   - **Output Directory**: Leave default

### 1.3 Environment Variables in Vercel
Add these environment variables in Vercel dashboard:
```env
NEXT_PUBLIC_API_URL=https://your-backend.railway.app
NEXT_PUBLIC_CHAT_WEBHOOK_URL=https://lmouud.app.n8n.cloud/webhook/c490c45a-1828-4ba9-84bc-3c36450218c7/chat
```

### 1.4 Custom Domain Setup
1. **In Vercel Dashboard** → Your Project → Settings → Domains
2. **Add your domain**: `yourname.com`
3. **Configure DNS** at your domain registrar:
   ```
   Type: CNAME
   Name: www
   Value: cname.vercel-dns.com
   
   Type: A
   Name: @
   Value: 76.76.19.61
   ```
4. **SSL Certificate**: Automatic ✅

---

## 🔧 Step 2: Deploy Backend to Railway

### 2.1 Prepare Backend for Railway
Create `railway.json` in backend directory:
```json
{
  "$schema": "https://railway.app/railway.schema.json",
  "build": {
    "builder": "NIXPACKS"
  },
  "deploy": {
    "startCommand": "npm start",
    "healthcheckPath": "/api/health",
    "healthcheckTimeout": 30,
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 10
  }
}
```

### 2.2 Deploy to Railway
1. **Go to [railway.app](https://railway.app)**
2. **Sign up/Login** with GitHub
3. **Click "New Project"**
4. **Select "Deploy from GitHub repo"**
5. **Choose your portfolio repository**
6. **Select backend folder** as root directory

### 2.3 Add PostgreSQL Database
1. **In Railway Dashboard** → Your Project
2. **Click "New Service"** → Database → PostgreSQL
3. **Database will be automatically created**

### 2.4 Environment Variables in Railway
Railway auto-generates database connection variables. Add these additional ones:
```env
NODE_ENV=production
PORT=3001
FRONTEND_URL=https://yourname.com
N8N_WEBHOOK_URL=https://lmouud.app.n8n.cloud/webhook/c490c45a-1828-4ba9-84bc-3c36450218c7/chat
```

### 2.5 Setup Database Schema
1. **Connect to Railway database**:
   ```bash
   # Install Railway CLI
   npm install -g @railway/cli
   
   # Login and connect
   railway login
   railway link
   railway connect postgres
   ```

2. **Run your schema**:
   ```bash
   # Copy your schema to Railway database
   \i database/schema.sql
   ```

### 2.6 Custom Domain for Backend (Optional)
1. **In Railway** → Settings → Domains
2. **Add custom domain**: `api.yourname.com`
3. **Configure DNS**:
   ```
   Type: CNAME
   Name: api
   Value: your-railway-app.railway.app
   ```

---

## 📱 Step 3: Update Frontend Configuration

Update your Vercel environment variables with the actual Railway backend URL:
```env
NEXT_PUBLIC_API_URL=https://your-app.railway.app
# or if using custom domain:
NEXT_PUBLIC_API_URL=https://api.yourname.com
```

---

# 🌐 Option 2: Netlify + Render + Supabase

## Frontend: Netlify

### Deploy to Netlify
1. **Go to [netlify.com](https://netlify.com)**
2. **Connect GitHub repository**
3. **Build settings**:
   - **Build command**: `cd frontend && npm run build`
   - **Publish directory**: `frontend/out`
4. **Environment variables**:
   ```env
   NEXT_PUBLIC_API_URL=https://your-backend.onrender.com
   NEXT_PUBLIC_CHAT_WEBHOOK_URL=https://lmouud.app.n8n.cloud/webhook/c490c45a-1828-4ba9-84bc-3c36450218c7/chat
   ```

## Backend: Render

### Deploy to Render
1. **Go to [render.com](https://render.com)**
2. **Create Web Service** from GitHub
3. **Settings**:
   - **Build Command**: `cd backend && npm install`
   - **Start Command**: `cd backend && npm start`
4. **Environment variables**:
   ```env
   NODE_ENV=production
   DATABASE_URL=your-supabase-connection-string
   FRONTEND_URL=https://your-site.netlify.app
   N8N_WEBHOOK_URL=https://lmouud.app.n8n.cloud/webhook/c490c45a-1828-4ba9-84bc-3c36450218c7/chat
   ```

## Database: Supabase

### Setup Supabase
1. **Go to [supabase.com](https://supabase.com)**
2. **Create new project**
3. **Go to SQL Editor** and run your schema
4. **Get connection string** from Settings → Database
5. **Add to Render environment variables**

---

# 📄 Option 3: GitHub Pages + Heroku

## Frontend: GitHub Pages

### Setup GitHub Pages
1. **In your repository** → Settings → Pages
2. **Source**: Deploy from a branch
3. **Branch**: Create `gh-pages` branch
4. **Folder**: `/` (root)

### Build and Deploy Script
```bash
# Create deployment script
npm run build
cp -r frontend/out/* .
git add .
git commit -m "Deploy to GitHub Pages"
git push origin gh-pages
```

## Backend: Heroku

### Deploy to Heroku
```bash
# Install Heroku CLI
# Create app
heroku create your-portfolio-api

# Add PostgreSQL
heroku addons:create heroku-postgresql:mini

# Set environment variables
heroku config:set NODE_ENV=production
heroku config:set FRONTEND_URL=https://username.github.io

# Deploy
git subtree push --prefix backend heroku main
```

---

# 🔄 Automatic Deployments

## GitHub Actions for Vercel
```yaml
# .github/workflows/deploy.yml
name: Deploy to Vercel

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - name: Install Vercel CLI
        run: npm install --global vercel@latest
      - name: Pull Vercel Environment Information
        run: vercel pull --yes --environment=production --token=${{ secrets.VERCEL_TOKEN }}
      - name: Build Project Artifacts
        run: vercel build --prod --token=${{ secrets.VERCEL_TOKEN }}
      - name: Deploy Project Artifacts to Vercel
        run: vercel deploy --prebuilt --prod --token=${{ secrets.VERCEL_TOKEN }}
```

## GitHub Actions for Railway
```yaml
# .github/workflows/railway.yml
name: Deploy to Railway

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - name: Install Railway CLI
        run: npm install -g @railway/cli
      - name: Deploy to Railway
        run: railway up
        env:
          RAILWAY_TOKEN: ${{ secrets.RAILWAY_TOKEN }}
```

---

# 💰 Free Tier Limits

## Vercel Free Tier
- ✅ **100 GB bandwidth/month**
- ✅ **Unlimited websites**
- ✅ **Custom domains**
- ✅ **Automatic SSL**
- ✅ **Global CDN**

## Railway Free Tier
- ✅ **$5 monthly credit** (covers small apps)
- ✅ **512 MB RAM**
- ✅ **1 GB disk**
- ✅ **No sleep mode**
- ✅ **Custom domains**

## Netlify Free Tier
- ✅ **100 GB bandwidth/month**
- ✅ **300 build minutes/month**
- ✅ **Custom domains**
- ✅ **SSL certificates**

## Render Free Tier
- ✅ **750 hours/month**
- ✅ **512 MB RAM**
- ⚠️ **Sleeps after 15min inactivity**

## Supabase Free Tier
- ✅ **500 MB database**
- ✅ **2 GB bandwidth/month**
- ✅ **50K monthly active users**

---

# 🛠️ Quick Setup Commands

## Vercel Deployment
```bash
# Install Vercel CLI
npm i -g vercel

# Login and deploy
vercel login
cd frontend
vercel

# Set custom domain
vercel domains add yourname.com
```

## Railway Deployment
```bash
# Install Railway CLI
npm i -g @railway/cli

# Login and deploy
railway login
cd backend
railway init
railway up

# Add database
railway add postgresql
```

---

# 🔧 Configuration Files

## Vercel Configuration
```json
{
  "version": 2,
  "builds": [
    {
      "src": "package.json",
      "use": "@vercel/next"
    }
  ],
  "routes": [
    {
      "src": "/(.*)",
      "dest": "/$1"
    }
  ]
}
```

## Netlify Configuration
```toml
# netlify.toml
[build]
  base = "frontend"
  publish = "out"
  command = "npm run build"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
```

---

# 📋 Deployment Checklist

## Pre-Deployment
- [ ] Code pushed to GitHub
- [ ] Environment variables ready
- [ ] Frontend builds successfully
- [ ] Backend starts without errors

## Frontend Deployment
- [ ] Vercel/Netlify project created
- [ ] Custom domain added
- [ ] Environment variables set
- [ ] SSL certificate active
- [ ] Build and deployment successful

## Backend Deployment
- [ ] Railway/Render service created
- [ ] Database connected
- [ ] Environment variables set
- [ ] Health check endpoint working
- [ ] API accessible from frontend

## Final Testing
- [ ] Website loads on custom domain
- [ ] Contact form works
- [ ] Chatbot functions
- [ ] All pages accessible
- [ ] Mobile responsive
- [ ] HTTPS enabled

---

# 🚨 Troubleshooting

## Common Issues

### Frontend Not Loading
- Check build logs in Vercel/Netlify
- Verify API URL environment variable
- Check for console errors

### Backend API Errors
- Check Railway/Render logs
- Verify database connection
- Check CORS settings

### Domain Not Working
- Verify DNS settings (may take 24-48 hours)
- Check SSL certificate status
- Try accessing via deployment URL first

### Database Connection Issues
- Check connection string format
- Verify database is running
- Check firewall/security settings

---

# 🎉 Success!

Once deployed, your website will be:
- ✅ **Completely FREE**
- ✅ **Production-ready**
- ✅ **Automatically deploying** on git push
- ✅ **SSL secured** with custom domain
- ✅ **Globally distributed** via CDN
- ✅ **Highly available**

Your portfolio will be live at `https://yourname.com` with professional hosting quality at $0 cost!

---

## 📞 Support

If you encounter issues:
1. Check the platform documentation (Vercel, Railway, etc.)
2. Look at deployment logs
3. Test locally first
4. Check environment variables

Most free tier limitations won't affect a portfolio website's traffic levels.