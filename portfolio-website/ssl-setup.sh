#!/bin/bash

# SSL Certificate Setup Script for AWS EC2
# Run this AFTER your domain DNS is properly configured

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔒 SSL Certificate Setup Script${NC}"
echo "=================================="
echo

# Function to prompt for user input
prompt_input() {
    local prompt="$1"
    local variable="$2"
    read -p "$prompt: " $variable
}

# Get domain and email from user
prompt_input "Enter your domain name (e.g., yourdomain.com)" DOMAIN_NAME
prompt_input "Enter your email address for SSL certificate" EMAIL

echo
echo -e "${YELLOW}⚠️  IMPORTANT: Make sure your domain DNS is configured${NC}"
echo "Your domain should point to this server's IP address:"
echo -e "${BLUE}Server IP:${NC} $(curl -s ifconfig.me)"
echo
echo "DNS Configuration needed:"
echo "Type: A Record, Name: @, Value: $(curl -s ifconfig.me)"
echo "Type: A Record, Name: www, Value: $(curl -s ifconfig.me)"
echo

read -p "Has your DNS been configured and propagated? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Please configure your DNS first, then run this script again.${NC}"
    exit 1
fi

# Test domain connectivity
echo -e "${BLUE}🔍 Testing domain connectivity...${NC}"

# Test if domain resolves to this server
DOMAIN_IP=$(dig +short $DOMAIN_NAME | tail -n1)
SERVER_IP=$(curl -s ifconfig.me)

if [ "$DOMAIN_IP" != "$SERVER_IP" ]; then
    echo -e "${YELLOW}⚠️  Warning: Domain IP ($DOMAIN_IP) doesn't match server IP ($SERVER_IP)${NC}"
    echo "This might be due to DNS propagation delay."
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Test HTTP connectivity
echo -e "${BLUE}🌐 Testing HTTP connectivity...${NC}"
if curl -f -s "http://$DOMAIN_NAME" > /dev/null; then
    echo -e "${GREEN}✅ HTTP connection successful${NC}"
else
    echo -e "${RED}❌ HTTP connection failed${NC}"
    echo "Make sure Nginx is running and configured correctly."
    exit 1
fi

# Install Certbot if not already installed
if ! command -v certbot &> /dev/null; then
    echo -e "${YELLOW}📦 Installing Certbot...${NC}"
    sudo apt update
    sudo apt install snapd -y
    sudo snap install core
    sudo snap refresh core
    sudo snap install --classic certbot
    sudo ln -s /snap/bin/certbot /usr/bin/certbot
fi

echo -e "${GREEN}✅ Certbot is installed${NC}"

# Get SSL certificate
echo -e "${BLUE}🔒 Obtaining SSL certificate...${NC}"
sudo certbot --nginx \
    -d $DOMAIN_NAME \
    -d www.$DOMAIN_NAME \
    --email $EMAIL \
    --agree-tos \
    --no-eff-email \
    --redirect

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ SSL certificate obtained successfully!${NC}"
else
    echo -e "${RED}❌ SSL certificate setup failed${NC}"
    echo "Please check the error messages above and try again."
    exit 1
fi

# Test SSL certificate
echo -e "${BLUE}🔍 Testing SSL certificate...${NC}"
if curl -f -s "https://$DOMAIN_NAME" > /dev/null; then
    echo -e "${GREEN}✅ HTTPS connection successful${NC}"
else
    echo -e "${RED}❌ HTTPS connection failed${NC}"
fi

# Test SSL certificate details
echo -e "${BLUE}📋 SSL Certificate Details:${NC}"
sudo certbot certificates

# Setup automatic renewal
echo -e "${BLUE}🔄 Setting up automatic renewal...${NC}"

# Test renewal
sudo certbot renew --dry-run

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Auto-renewal test successful${NC}"
else
    echo -e "${RED}❌ Auto-renewal test failed${NC}"
fi

# Check renewal timer
echo -e "${BLUE}⏰ Checking renewal timer...${NC}"
sudo systemctl status snap.certbot.renew.timer

# Create SSL monitoring script
echo -e "${BLUE}📜 Creating SSL monitoring script...${NC}"

cat > ~/ssl-check.sh << 'EOF'
#!/bin/bash

DOMAIN=$1

if [ -z "$DOMAIN" ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

echo "🔒 SSL Certificate Check for $DOMAIN"
echo "===================================="

# Check certificate expiration
EXPIRY=$(echo | openssl s_client -servername $DOMAIN -connect $DOMAIN:443 2>/dev/null | openssl x509 -noout -dates | grep notAfter | cut -d= -f2)
EXPIRY_EPOCH=$(date -d "$EXPIRY" +%s)
CURRENT_EPOCH=$(date +%s)
DAYS_LEFT=$(( ($EXPIRY_EPOCH - $CURRENT_EPOCH) / 86400 ))

echo "Certificate expires: $EXPIRY"
echo "Days until expiration: $DAYS_LEFT"

if [ $DAYS_LEFT -lt 30 ]; then
    echo "⚠️  Certificate expires soon! Consider renewing."
elif [ $DAYS_LEFT -lt 7 ]; then
    echo "🚨 Certificate expires very soon! Renew immediately."
else
    echo "✅ Certificate is valid for $DAYS_LEFT more days."
fi

# Test HTTPS connectivity
if curl -f -s "https://$DOMAIN" > /dev/null; then
    echo "✅ HTTPS connection successful"
else
    echo "❌ HTTPS connection failed"
fi

# Check certificate details
echo ""
echo "Certificate details:"
echo | openssl s_client -servername $DOMAIN -connect $DOMAIN:443 2>/dev/null | openssl x509 -noout -subject -issuer
EOF

chmod +x ~/ssl-check.sh

# Update Nginx configuration to include security headers for HTTPS
echo -e "${BLUE}🔧 Updating Nginx security configuration...${NC}"

# Create enhanced security configuration
sudo tee /etc/nginx/conf.d/security.conf > /dev/null << 'EOF'
# Security headers
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header Referrer-Policy "strict-origin-when-cross-origin" always;

# Hide Nginx version
server_tokens off;

# SSL Configuration
ssl_protocols TLSv1.2 TLSv1.3;
ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA384;
ssl_prefer_server_ciphers on;
ssl_session_cache shared:SSL:10m;
ssl_session_timeout 10m;
EOF

# Test Nginx configuration
sudo nginx -t

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Nginx configuration is valid${NC}"
    sudo systemctl reload nginx
    echo -e "${GREEN}✅ Nginx reloaded${NC}"
else
    echo -e "${RED}❌ Nginx configuration error${NC}"
    exit 1
fi

# Final tests
echo
echo -e "${BLUE}🧪 Final Tests${NC}"
echo "==============="

# Test HTTP redirect
echo -e "${BLUE}Testing HTTP to HTTPS redirect...${NC}"
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "http://$DOMAIN_NAME")
if [ "$HTTP_STATUS" = "301" ] || [ "$HTTP_STATUS" = "302" ]; then
    echo -e "${GREEN}✅ HTTP redirects to HTTPS (Status: $HTTP_STATUS)${NC}"
else
    echo -e "${YELLOW}⚠️  HTTP redirect status: $HTTP_STATUS${NC}"
fi

# Test HTTPS
echo -e "${BLUE}Testing HTTPS connection...${NC}"
HTTPS_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "https://$DOMAIN_NAME")
if [ "$HTTPS_STATUS" = "200" ]; then
    echo -e "${GREEN}✅ HTTPS connection successful (Status: $HTTPS_STATUS)${NC}"
else
    echo -e "${RED}❌ HTTPS connection failed (Status: $HTTPS_STATUS)${NC}"
fi

# Test WWW redirect
echo -e "${BLUE}Testing WWW subdomain...${NC}"
WWW_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "https://www.$DOMAIN_NAME")
if [ "$WWW_STATUS" = "200" ]; then
    echo -e "${GREEN}✅ WWW subdomain working (Status: $WWW_STATUS)${NC}"
else
    echo -e "${YELLOW}⚠️  WWW subdomain status: $WWW_STATUS${NC}"
fi

echo
echo -e "${GREEN}🎉 SSL Setup Complete!${NC}"
echo "======================"
echo
echo -e "${BLUE}📋 Summary:${NC}"
echo "• SSL certificate obtained for $DOMAIN_NAME and www.$DOMAIN_NAME"
echo "• Automatic renewal configured"
echo "• Security headers added"
echo "• HTTP to HTTPS redirect enabled"
echo
echo -e "${BLUE}🔗 Your website is now available at:${NC}"
echo "• https://$DOMAIN_NAME"
echo "• https://www.$DOMAIN_NAME"
echo
echo -e "${BLUE}🛠️  Useful commands:${NC}"
echo "• Check SSL status: ${GREEN}~/ssl-check.sh $DOMAIN_NAME${NC}"
echo "• View certificates: ${GREEN}sudo certbot certificates${NC}"
echo "• Renew certificates: ${GREEN}sudo certbot renew${NC}"
echo "• Test renewal: ${GREEN}sudo certbot renew --dry-run${NC}"
echo
echo -e "${YELLOW}📅 Certificate Auto-Renewal:${NC}"
echo "Certificates will automatically renew before expiration."
echo "Check renewal status: ${GREEN}sudo systemctl status snap.certbot.renew.timer${NC}"
echo
echo -e "${GREEN}🎊 Your portfolio website is now live with SSL! 🎊${NC}"