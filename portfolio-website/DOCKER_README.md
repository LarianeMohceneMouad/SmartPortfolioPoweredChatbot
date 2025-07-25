# 🐳 Docker Deployment Guide

Complete Docker containerization for the Portfolio Website with PostgreSQL database, Node.js backend, Next.js frontend, and Nginx reverse proxy.

## 🚀 Quick Start

### Development Environment
```bash
# Linux/macOS/WSL
./docker-start.sh dev

# Windows
docker-start.bat dev
```

### Production Environment
```bash
# Linux/macOS/WSL
./docker-start.sh prod

# Windows
docker-start.bat prod
```

## 📋 Available Commands

| Command | Description |
|---------|-------------|
| `dev` | Start development environment |
| `prod` | Start production environment with nginx |
| `stop` | Stop all containers |
| `logs` | Show logs from all containers |
| `clean` | Stop containers and remove volumes |
| `build` | Rebuild all images |
| `health` | Check container health |

## 🏗️ Architecture

### Development Setup (`docker-compose.yml`)
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│                 │    │                 │    │                 │
│    Frontend     │    │     Backend     │    │    Database     │
│   (Next.js)     │◄──►│   (Node.js)     │◄──►│  (PostgreSQL)   │
│   Port: 3000    │    │   Port: 3001    │    │   Port: 5432    │
│                 │    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### Production Setup (`docker-compose.prod.yml`)
```
                    ┌─────────────────┐
                    │                 │
                    │      Nginx      │
                    │  (Reverse Proxy)│
                    │  Ports: 80/443  │
                    │                 │
                    └─────────┬───────┘
                              │
              ┌───────────────┼───────────────┐
              │               │               │
              ▼               ▼               │
    ┌─────────────────┐    ┌─────────────────┐    │
    │                 │    │                 │    │
    │    Frontend     │    │     Backend     │    │
    │   (Next.js)     │    │   (Node.js)     │    │
    │   Port: 3000    │    │   Port: 3001    │    │
    │                 │    │                 │    │
    └─────────────────┘    └─────────┬───────┘    │
                                     │            │
                                     ▼            │
                           ┌─────────────────┐    │
                           │                 │    │
                           │    Database     │◄───┘
                           │  (PostgreSQL)   │
                           │   Port: 5432    │
                           │                 │
                           └─────────────────┘
```

## 🔧 Services Configuration

### Frontend Service
- **Image**: Custom Next.js build
- **Port**: 3000 (dev) / Internal (prod)
- **Environment**: Production optimized
- **Features**: 
  - Standalone output for Docker
  - Automatic API proxy to backend
  - Health checks enabled

### Backend Service
- **Image**: Custom Node.js build
- **Port**: 3001 (dev) / Internal (prod)
- **Features**:
  - Production dependencies only
  - Non-root user execution
  - Health checks via `/api/health`
  - Automatic database connection

### Database Service
- **Image**: PostgreSQL 15 Alpine
- **Port**: 5432 (dev only)
- **Features**:
  - Automatic schema initialization
  - Data persistence via volumes
  - Health checks enabled

### Nginx Service (Production)
- **Image**: Nginx Alpine
- **Ports**: 80 (HTTP), 443 (HTTPS)
- **Features**:
  - SSL/TLS termination
  - HTTP to HTTPS redirect
  - Rate limiting
  - Static file caching
  - Security headers

## 🌐 Environment Variables

### Development
```env
NODE_ENV=production
NEXT_PUBLIC_API_URL=http://backend:3001
NEXT_PUBLIC_CHAT_WEBHOOK_URL=https://lmouud.app.n8n.cloud/webhook/c490c45a-1828-4ba9-84bc-3c36450218c7/chat
DB_HOST=database
DB_USER=portfolio_user
DB_PASSWORD=25122000
DB_NAME=portfolio_db
```

### Production
```env
NODE_ENV=production
NEXT_PUBLIC_API_URL=https://larianemohcenemouad.site/api
NEXT_PUBLIC_CHAT_WEBHOOK_URL=https://lmouud.app.n8n.cloud/webhook/c490c45a-1828-4ba9-84bc-3c36450218c7/chat
FRONTEND_URL=https://larianemohcenemouad.site
```

## 🔒 SSL/TLS Configuration

### Development
- No SSL required
- Services communicate via Docker network

### Production
- SSL certificates required in `nginx/ssl/`
- Automatic HTTP to HTTPS redirect
- Self-signed certificates created automatically for testing

### Setting up Let's Encrypt (Production)
```bash
# Install certbot
sudo apt-get install certbot

# Get certificate
sudo certbot certonly --standalone -d larianemohcenemouad.site

# Copy certificates
sudo cp /etc/letsencrypt/live/larianemohcenemouad.site/fullchain.pem nginx/ssl/larianemohcenemouad.site.crt
sudo cp /etc/letsencrypt/live/larianemohcenemouad.site/privkey.pem nginx/ssl/larianemohcenemouad.site.key

# Set permissions
sudo chown $USER:$USER nginx/ssl/*
```

## 📊 Monitoring & Logs

### View Logs
```bash
# All services
./docker-start.sh logs

# Specific service
docker-compose logs -f frontend
docker-compose logs -f backend
docker-compose logs -f database
```

### Health Checks
```bash
# Check all services
./docker-start.sh health

# Manual health checks
curl http://localhost:3001/api/health  # Backend
curl http://localhost:3000/            # Frontend
```

### Container Status
```bash
docker-compose ps
docker stats
```

## 🔧 Customization

### Environment Variables
Edit the environment section in `docker-compose.yml` or `docker-compose.prod.yml`:

```yaml
environment:
  - NODE_ENV=production
  - CUSTOM_VARIABLE=value
```

### Port Configuration
Change exposed ports in compose files:

```yaml
ports:
  - "8080:3000"  # Map to different host port
```

### Resource Limits
Add resource constraints:

```yaml
deploy:
  resources:
    limits:
      memory: 512M
      cpus: '0.5'
```

## 🚨 Troubleshooting

### Common Issues

#### Port Already in Use
```bash
# Find process using port
sudo lsof -i :3000
sudo lsof -i :3001

# Kill process
sudo kill -9 <PID>
```

#### Database Connection Issues
```bash
# Check database logs
docker-compose logs database

# Connect to database
docker-compose exec database psql -U portfolio_user -d portfolio_db
```

#### Build Failures
```bash
# Clean build cache
docker system prune -a

# Rebuild from scratch
./docker-start.sh clean
./docker-start.sh build
```

#### Frontend Not Loading
```bash
# Check Next.js build
docker-compose exec frontend ls -la .next/

# Check environment variables
docker-compose exec frontend env | grep NEXT_PUBLIC
```

### Debug Mode
Run containers in foreground to see real-time logs:

```bash
# Development
docker-compose up --build

# Production
docker-compose -f docker-compose.prod.yml up --build
```

## 🔄 Deployment Workflow

### Local Development
1. Make code changes
2. Run `./docker-start.sh dev`
3. Test at http://localhost:3000
4. Check logs with `./docker-start.sh logs`

### Production Deployment
1. Ensure SSL certificates are in place
2. Run `./docker-start.sh prod`
3. Test at https://larianemohcenemouad.site
4. Monitor with `./docker-start.sh health`

### Updates
1. Pull latest code
2. Run `./docker-start.sh stop`
3. Run `./docker-start.sh build`
4. Run `./docker-start.sh prod`

## 📁 File Structure

```
portfolio-website/
├── docker-compose.yml              # Development configuration
├── docker-compose.prod.yml         # Production configuration
├── docker-start.sh                 # Linux/macOS deployment script
├── docker-start.bat                # Windows deployment script
├── .dockerignore                   # Docker ignore file
├── backend/
│   ├── Dockerfile                  # Backend container definition
│   └── ...
├── frontend/
│   ├── Dockerfile                  # Frontend container definition
│   └── ...
├── nginx/
│   ├── nginx.conf                  # Nginx main configuration
│   ├── sites/
│   │   └── portfolio.conf          # Site-specific configuration
│   └── ssl/                        # SSL certificates directory
└── database/
    └── schema.sql                  # Database initialization
```

## 🚀 Performance Optimization

### Image Size Optimization
- Multi-stage builds for frontend
- Alpine Linux base images
- Production-only dependencies
- Layer caching optimization

### Runtime Optimization
- Non-root user execution
- Health checks for reliability
- Resource limits
- Restart policies

### Network Optimization
- Internal Docker networking
- Nginx caching for static assets
- Gzip compression
- CDN-ready headers

---

**Your portfolio website is now fully containerized and ready for deployment! 🎉**