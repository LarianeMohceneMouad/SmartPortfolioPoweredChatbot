# 🚀 Free Backend Deployment Options

Multiple free hosting platforms for your Node.js backend with PostgreSQL database.

## 📊 Comparison Table

| Platform | Free Tier | Database | Pros | Cons |
|----------|-----------|----------|------|------|
| **Railway** | $5 credit/month | PostgreSQL ✅ | No sleep, fast, easy | Credit-based |
| **Render** | 750 hours/month | PostgreSQL ✅ | Reliable, good UI | Sleeps after 15min |
| **Heroku** | 550 hours/month | PostgreSQL ✅ | Mature, stable | Sleeps after 30min |
| **Fly.io** | 3 apps free | PostgreSQL ✅ | Fast, global | Complex setup |
| **Supabase** | Edge Functions | Built-in DB ✅ | Serverless, fast | TypeScript focused |
| **Vercel** | Serverless ✅ | External DB needed | Fast cold starts | No persistent storage |

---

# 🎯 Option 1: Render (Recommended Alternative)

## Why Render?
- ✅ **Completely free** (no credits)
- ✅ **PostgreSQL database** included
- ✅ **Auto-deploy** from GitHub
- ✅ **Custom domains** supported
- ✅ **SSL certificates** automatic
- ⚠️ **Sleeps after 15 minutes** of inactivity

## Deploy to Render

### 1. Create Account
1. Go to [render.com](https://render.com)
2. Sign up with GitHub

### 2. Create Web Service
1. Click **"New +"** → **"Web Service"**
2. Connect your GitHub repository
3. Configure:
   - **Name**: `portfolio-backend`
   - **Environment**: `Node`
   - **Region**: Choose closest to you
   - **Branch**: `main`
   - **Root Directory**: `backend`
   - **Build Command**: `npm install`
   - **Start Command**: `npm start`

### 3. Environment Variables
Add these in Render dashboard:
```env
NODE_ENV=production
PORT=10000
FRONTEND_URL=https://yourdomain.com
N8N_WEBHOOK_URL=https://lmouud.app.n8n.cloud/webhook/c490c45a-1828-4ba9-84bc-3c36450218c7/chat
```

### 4. Add PostgreSQL Database
1. Click **"New +"** → **"PostgreSQL"**
2. Choose **"Free"** tier
3. Copy the **Internal Database URL**
4. Add to your web service environment:
   ```env
   DATABASE_URL=your-internal-database-url
   ```

### 5. Deploy
- Render auto-deploys on git push
- First deployment takes 5-10 minutes
- Your API will be at: `https://your-app.onrender.com`

---

# 🎯 Option 2: Heroku (Classic Option)

## Why Heroku?
- ✅ **550 free hours/month** (23 days)
- ✅ **PostgreSQL add-on** available
- ✅ **Mature platform** with good docs
- ✅ **Easy CLI** deployment
- ⚠️ **Sleeps after 30 minutes** of inactivity

## Deploy to Heroku

### 1. Install Heroku CLI
```bash
# Download from: https://devcenter.heroku.com/articles/heroku-cli
# Or using npm:
npm install -g heroku
```

### 2. Login and Create App
```bash
heroku login
heroku create your-portfolio-api
```

### 3. Add PostgreSQL Add-on
```bash
heroku addons:create heroku-postgresql:mini
```

### 4. Set Environment Variables
```bash
heroku config:set NODE_ENV=production
heroku config:set FRONTEND_URL=https://yourdomain.com
heroku config:set N8N_WEBHOOK_URL=https://lmouud.app.n8n.cloud/webhook/c490c45a-1828-4ba9-84bc-3c36450218c7/chat
```

### 5. Create Procfile
```bash
# Create backend/Procfile
echo "web: npm start" > backend/Procfile
```

### 6. Deploy
```bash
# Deploy only backend folder
git subtree push --prefix backend heroku main
```

### 7. Run Database Schema
```bash
heroku pg:psql
# Then run your schema SQL commands
```

---

# 🎯 Option 3: Fly.io (Performance Option)

## Why Fly.io?
- ✅ **3 apps free** forever
- ✅ **Global deployment**
- ✅ **No sleep** mode
- ✅ **PostgreSQL** via fly postgres
- ⚠️ **More complex** setup

## Deploy to Fly.io

### 1. Install Fly CLI
```bash
# Download from: https://fly.io/docs/getting-started/installing-flyctl/
curl -L https://fly.io/install.sh | sh
```

### 2. Login and Initialize
```bash
fly auth login
cd backend
fly launch
```

### 3. Configure fly.toml
```toml
app = "your-portfolio-backend"

[build]

[env]
  NODE_ENV = "production"
  PORT = "8080"

[[services]]
  http_checks = []
  internal_port = 8080
  processes = ["app"]
  protocol = "tcp"
  script_checks = []

  [services.concurrency]
    hard_limit = 25
    soft_limit = 20
    type = "connections"

  [[services.ports]]
    force_https = true
    handlers = ["http"]
    port = 80

  [[services.ports]]
    handlers = ["tls", "http"]
    port = 443

  [[services.tcp_checks]]
    grace_period = "1s"
    interval = "15s"
    restart_limit = 0
    timeout = "2s"
```

### 4. Create PostgreSQL
```bash
fly postgres create --name your-portfolio-db
fly postgres attach your-portfolio-db
```

### 5. Deploy
```bash
fly deploy
```

---

# 🎯 Option 4: Supabase Edge Functions

## Why Supabase?
- ✅ **Serverless** (no cold sleep)
- ✅ **Built-in database** and auth
- ✅ **Fast edge network**
- ✅ **Real-time subscriptions**
- ⚠️ **TypeScript/Deno** based

## Deploy to Supabase

### 1. Install Supabase CLI
```bash
npm install -g supabase
```

### 2. Initialize Project
```bash
supabase init
supabase login
```

### 3. Create Edge Function
```typescript
// supabase/functions/api/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? ''
    )

    const url = new URL(req.url)
    const path = url.pathname

    // Route your API endpoints here
    if (path === '/api/contact' && req.method === 'POST') {
      const body = await req.json()
      
      // Forward to n8n webhook
      const webhookUrl = Deno.env.get('N8N_WEBHOOK_URL')
      const response = await fetch(webhookUrl, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          action: 'sendMessage',
          chatInput: `Contact form: ${body.message}`,
          sessionId: `contact_${Date.now()}`
        })
      })

      return new Response(JSON.stringify({ success: true }), {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      })
    }

    return new Response('Not Found', { status: 404, headers: corsHeaders })
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' }
    })
  }
})
```

### 4. Deploy
```bash
supabase functions deploy api
```

---

# 🎯 Option 5: Vercel Serverless Functions

## Why Vercel?
- ✅ **Same platform** as frontend
- ✅ **Instant cold starts**
- ✅ **Auto-scaling**
- ✅ **Easy integration**
- ⚠️ **No persistent storage**

## Deploy to Vercel

### 1. Create API Routes
```javascript
// api/contact.js
export default async function handler(req, res) {
  // Enable CORS
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS')
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type')

  if (req.method === 'OPTIONS') {
    return res.status(200).end()
  }

  if (req.method === 'POST') {
    try {
      const { name, email, message } = req.body

      // Forward to n8n webhook
      const webhookUrl = process.env.N8N_WEBHOOK_URL
      const response = await fetch(webhookUrl, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          action: 'sendMessage',
          chatInput: `📝 Contact from ${name} (${email}): ${message}`,
          sessionId: `contact_${Date.now()}`
        })
      })

      res.status(200).json({ success: true })
    } catch (error) {
      res.status(500).json({ error: 'Internal server error' })
    }
  } else {
    res.status(405).json({ error: 'Method not allowed' })
  }
}
```

### 2. Configure vercel.json
```json
{
  "functions": {
    "api/contact.js": {
      "maxDuration": 30
    }
  },
  "env": {
    "N8N_WEBHOOK_URL": "@n8n_webhook_url"
  }
}
```

---

# 🎯 Option 6: Back4App (Parse Server)

## Why Back4App?
- ✅ **25k requests/month** free
- ✅ **1GB database** storage
- ✅ **Real-time database**
- ✅ **No sleep mode**

## Deploy to Back4App

### 1. Create Account
Go to [back4app.com](https://back4app.com)

### 2. Create App
1. Choose "Build new app"
2. Select "Backend as a Service"
3. Choose database location

### 3. Deploy Code
```javascript
// Use Parse Server SDK
Parse.Cloud.define("contact", async (request) => {
  const { name, email, message } = request.params

  // Forward to n8n webhook
  const webhookResponse = await Parse.Cloud.httpRequest({
    method: 'POST',
    url: 'https://lmouud.app.n8n.cloud/webhook/c490c45a-1828-4ba9-84bc-3c36450218c7/chat',
    headers: { 'Content-Type': 'application/json' },
    body: {
      action: 'sendMessage',
      chatInput: `Contact: ${message}`,
      sessionId: `contact_${Date.now()}`
    }
  })

  return { success: true }
})
```

---

# 📋 Quick Comparison for Your Use Case

## **Best for Simplicity**: Render
- One-click deploy from GitHub
- Free PostgreSQL included
- Good for portfolio websites

## **Best for Performance**: Fly.io
- Global edge deployment
- No sleep mode
- More complex setup

## **Best for Integration**: Vercel Serverless
- Same platform as frontend
- Instant scaling
- No database persistence

## **Best for Features**: Supabase
- Built-in auth and real-time
- Edge functions
- Modern stack

## **Most Reliable**: Heroku
- Mature platform
- Extensive documentation
- Large community

---

# 🚀 Recommended Deployment Order

## 1st Choice: **Render**
- Easiest to set up
- Free PostgreSQL
- Good performance

## 2nd Choice: **Railway**
- $5 monthly credit
- No sleep mode
- Great developer experience

## 3rd Choice: **Heroku**
- Most documentation
- Proven platform
- Easy CLI

Which option would you like me to help you set up? I can provide detailed step-by-step instructions for any of these platforms.