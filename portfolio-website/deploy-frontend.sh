#!/bin/bash

# Frontend Deployment Script for AWS S3 + CloudFront
# Usage: ./deploy-frontend.sh [bucket-name] [distribution-id]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
BUCKET_NAME=${1:-"yourname.com"}
DISTRIBUTION_ID=${2:-""}
BUILD_DIR="frontend/out"

echo -e "${BLUE}🚀 Starting Frontend Deployment to AWS${NC}"
echo "========================================"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo -e "${RED}❌ AWS CLI is not installed${NC}"
    echo "Please install AWS CLI: https://aws.amazon.com/cli/"
    exit 1
fi

# Check if AWS is configured
if ! aws sts get-caller-identity &> /dev/null; then
    echo -e "${RED}❌ AWS CLI is not configured${NC}"
    echo "Please run: aws configure"
    exit 1
fi

echo -e "${GREEN}✅ AWS CLI configured${NC}"

# Check if bucket name is provided
if [ "$BUCKET_NAME" = "yourname.com" ]; then
    echo -e "${YELLOW}⚠️  Using default bucket name: yourname.com${NC}"
    echo "Please provide your actual bucket name as first argument"
    echo "Usage: $0 your-bucket-name [distribution-id]"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Build the frontend
echo -e "${BLUE}🔨 Building frontend...${NC}"
cd frontend

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}📦 Installing dependencies...${NC}"
    npm install
fi

# Build for production
echo -e "${BLUE}🏗️  Building for production...${NC}"
npm run build

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Build failed${NC}"
    exit 1
fi

cd ..

# Check if build directory exists
if [ ! -d "$BUILD_DIR" ]; then
    echo -e "${RED}❌ Build directory not found: $BUILD_DIR${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Build completed successfully${NC}"

# Check if S3 bucket exists
echo -e "${BLUE}🔍 Checking S3 bucket...${NC}"
if ! aws s3 ls "s3://$BUCKET_NAME" &> /dev/null; then
    echo -e "${YELLOW}⚠️  Bucket $BUCKET_NAME does not exist${NC}"
    read -p "Create bucket? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}🪣 Creating S3 bucket...${NC}"
        aws s3 mb "s3://$BUCKET_NAME"
        
        # Configure bucket for website hosting
        aws s3 website "s3://$BUCKET_NAME" \
            --index-document index.html \
            --error-document 404.html
        
        echo -e "${GREEN}✅ Bucket created and configured${NC}"
    else
        echo -e "${RED}❌ Deployment cancelled${NC}"
        exit 1
    fi
fi

# Sync files to S3
echo -e "${BLUE}📤 Uploading files to S3...${NC}"
aws s3 sync "$BUILD_DIR" "s3://$BUCKET_NAME" \
    --delete \
    --cache-control "public,max-age=31536000,immutable" \
    --exclude "*.html" \
    --exclude "*.xml" \
    --exclude "*.txt"

# Upload HTML files with shorter cache
aws s3 sync "$BUILD_DIR" "s3://$BUCKET_NAME" \
    --delete \
    --cache-control "public,max-age=0,must-revalidate" \
    --include "*.html" \
    --include "*.xml" \
    --include "*.txt"

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Upload failed${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Files uploaded successfully${NC}"

# CloudFront invalidation
if [ -n "$DISTRIBUTION_ID" ]; then
    echo -e "${BLUE}🔄 Creating CloudFront invalidation...${NC}"
    INVALIDATION_ID=$(aws cloudfront create-invalidation \
        --distribution-id "$DISTRIBUTION_ID" \
        --paths "/*" \
        --query 'Invalidation.Id' \
        --output text)
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Invalidation created: $INVALIDATION_ID${NC}"
        echo -e "${YELLOW}⏳ Note: CloudFront changes may take 15-30 minutes to propagate${NC}"
    else
        echo -e "${YELLOW}⚠️  CloudFront invalidation failed${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  No CloudFront distribution ID provided${NC}"
    echo "To invalidate CloudFront cache, run:"
    echo "aws cloudfront create-invalidation --distribution-id YOUR_DISTRIBUTION_ID --paths '/*'"
fi

# Display website URL
echo
echo -e "${GREEN}🎉 Deployment completed successfully!${NC}"
echo "========================================"
echo -e "${BLUE}Website URL:${NC} http://$BUCKET_NAME.s3-website-$(aws configure get region).amazonaws.com"
if [ -n "$DISTRIBUTION_ID" ]; then
    CLOUDFRONT_DOMAIN=$(aws cloudfront get-distribution --id "$DISTRIBUTION_ID" --query 'Distribution.DomainName' --output text 2>/dev/null || echo "your-cloudfront-domain.cloudfront.net")
    echo -e "${BLUE}CloudFront URL:${NC} https://$CLOUDFRONT_DOMAIN"
fi
echo -e "${BLUE}Custom Domain:${NC} https://$BUCKET_NAME (if configured)"
echo

echo -e "${YELLOW}📋 Next Steps:${NC}"
echo "1. Configure your custom domain in Route 53"
echo "2. Set up SSL certificate in ACM"
echo "3. Configure CloudFront distribution"
echo "4. Update DNS records"
echo
echo "See AWS_DEPLOYMENT_GUIDE.md for detailed instructions"