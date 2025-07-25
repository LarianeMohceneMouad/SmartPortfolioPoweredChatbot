#!/bin/bash

# Docker Deployment Script for Portfolio Website

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🐳 Portfolio Website Docker Deployment${NC}"
echo "======================================"
echo

# Check if Docker and Docker Compose are installed
check_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}❌ Docker is not installed${NC}"
        echo "Please install Docker: https://docs.docker.com/get-docker/"
        exit 1
    fi

    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        echo -e "${RED}❌ Docker Compose is not installed${NC}"
        echo "Please install Docker Compose: https://docs.docker.com/compose/install/"
        exit 1
    fi

    echo -e "${GREEN}✅ Docker and Docker Compose are installed${NC}"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [dev|prod|stop|logs|clean]"
    echo
    echo "Commands:"
    echo "  dev     - Start development environment"
    echo "  prod    - Start production environment with nginx"
    echo "  stop    - Stop all containers"
    echo "  logs    - Show logs from all containers"
    echo "  clean   - Stop containers and remove volumes"
    echo "  build   - Rebuild all images"
    echo
}

# Development environment
start_dev() {
    echo -e "${YELLOW}🚀 Starting development environment...${NC}"
    
    # Build and start containers
    docker-compose up --build -d
    
    echo -e "${GREEN}✅ Development environment started${NC}"
    echo
    echo "Services available at:"
    echo "• Frontend: http://localhost:3000"
    echo "• Backend: http://localhost:3001"
    echo "• Database: localhost:5432"
    echo
    echo "To view logs: ./docker-start.sh logs"
    echo "To stop: ./docker-start.sh stop"
}

# Production environment
start_prod() {
    echo -e "${YELLOW}🚀 Starting production environment...${NC}"
    
    # Check if SSL certificates exist
    if [ ! -f "nginx/ssl/larianemohcenemouad.site.crt" ]; then
        echo -e "${YELLOW}⚠️  SSL certificates not found${NC}"
        echo "Creating self-signed certificates for testing..."
        mkdir -p nginx/ssl
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
            -keyout nginx/ssl/larianemohcenemouad.site.key \
            -out nginx/ssl/larianemohcenemouad.site.crt \
            -subj "/C=US/ST=State/L=City/O=Organization/CN=larianemohcenemouad.site"
    fi
    
    # Build and start containers
    docker-compose -f docker-compose.prod.yml up --build -d
    
    echo -e "${GREEN}✅ Production environment started${NC}"
    echo
    echo "Services available at:"
    echo "• Website: https://larianemohcenemouad.site (or https://localhost)"
    echo "• HTTP redirects to HTTPS"
    echo
    echo "To view logs: ./docker-start.sh logs"
    echo "To stop: ./docker-start.sh stop"
}

# Stop containers
stop_containers() {
    echo -e "${YELLOW}🛑 Stopping containers...${NC}"
    
    docker-compose down || true
    docker-compose -f docker-compose.prod.yml down || true
    
    echo -e "${GREEN}✅ Containers stopped${NC}"
}

# Show logs
show_logs() {
    echo -e "${BLUE}📋 Container logs:${NC}"
    echo
    
    if docker-compose ps -q | grep -q .; then
        docker-compose logs -f --tail=50
    elif docker-compose -f docker-compose.prod.yml ps -q | grep -q .; then
        docker-compose -f docker-compose.prod.yml logs -f --tail=50
    else
        echo "No containers are running"
    fi
}

# Clean up everything
clean_all() {
    echo -e "${YELLOW}🧹 Cleaning up containers and volumes...${NC}"
    
    # Stop containers
    docker-compose down -v --remove-orphans || true
    docker-compose -f docker-compose.prod.yml down -v --remove-orphans || true
    
    # Remove images
    docker-compose down --rmi all || true
    docker-compose -f docker-compose.prod.yml down --rmi all || true
    
    # Prune system
    docker system prune -f
    
    echo -e "${GREEN}✅ Cleanup completed${NC}"
}

# Build images
build_images() {
    echo -e "${YELLOW}🔨 Building Docker images...${NC}"
    
    docker-compose build --no-cache
    
    echo -e "${GREEN}✅ Images built successfully${NC}"
}

# Health check
health_check() {
    echo -e "${BLUE}🏥 Checking container health...${NC}"
    echo
    
    if docker-compose ps -q | grep -q .; then
        docker-compose ps
        echo
        echo "Health status:"
        docker-compose exec backend curl -f http://localhost:3001/api/health || echo "Backend health check failed"
        docker-compose exec frontend wget -q --spider http://localhost:3000/ || echo "Frontend health check failed"
    else
        echo "No containers are running"
    fi
}

# Main script logic
case "${1:-}" in
    "dev")
        check_docker
        start_dev
        ;;
    "prod")
        check_docker
        start_prod
        ;;
    "stop")
        stop_containers
        ;;
    "logs")
        show_logs
        ;;
    "clean")
        clean_all
        ;;
    "build")
        check_docker
        build_images
        ;;
    "health")
        health_check
        ;;
    *)
        show_usage
        exit 1
        ;;
esac