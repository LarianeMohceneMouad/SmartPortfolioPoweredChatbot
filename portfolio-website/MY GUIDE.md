  1.2 Access AWS Console

  1. Go to: https://console.aws.amazon.com
  2. Sign in with your credentials
  3. You'll see the AWS Management Console

  ---
  🖥️ Step 2: Launch EC2 Instance

  2.1 Navigate to EC2

  1. In AWS Console, search for "EC2" in the top search bar
  2. Click "EC2" from the results
  3. You'll see the EC2 Dashboard

  2.2 Launch Instance

  1. Click the orange "Launch Instance" button
  2. You'll see the Launch Instance wizard

  2.3 Configure Instance - Name and Tags

  Name: portfolio-website

  2.4 Configure Instance - Application and OS Images

  1. Choose "Quick Start"
  2. Select "Ubuntu"
  3. Choose "Ubuntu Server 22.04 LTS (HVM), SSD Volume Type"
  4. Architecture: 64-bit (x86)
  5. Make sure it says "Free tier eligible" ✅

  2.5 Configure Instance - Instance Type

  1. Select "t2.micro" (should be selected by default)
  2. Make sure it shows "Free tier eligible" ✅

  2.6 Configure Instance - Key Pair

  1. Click "Create new key pair"
  2. Key pair name: portfolio-key
  3. Key pair type: RSA
  4. Private key file format: .pem
  5. Click "Create key pair"
  6. Download will start automatically - Save this file securely!

  2.7 Configure Instance - Network Settings

  1. Click "Edit" next to Network settings
  2. Auto-assign public IP: Enable
  3. Create security group: Select this option
  4. Security group name: portfolio-security-group
  5. Description: Security group for portfolio website

  Add these rules (click "Add security group rule" for each):

  | Type       | Protocol | Port Range | Source    | Description  |
  |------------|----------|------------|-----------|--------------|
  | SSH        | TCP      | 22         | My IP     | SSH access   |
  | HTTP       | TCP      | 80         | 0.0.0.0/0 | HTTP access  |
  | HTTPS      | TCP      | 443        | 0.0.0.0/0 | HTTPS access |
  | Custom TCP | TCP      | 3000       | 0.0.0.0/0 | Frontend     |
  | Custom TCP | TCP      | 3001       | 0.0.0.0/0 | Backend API  |

  2.8 Configure Instance - Storage

  1. Size: 30 GiB (maximum for free tier)
  2. Volume type: gp3
  3. Keep all other defaults

  2.9 Launch Instance

  1. Review all settings
  2. Click "Launch Instance"
  3. Wait 2-3 minutes for instance to start

  2.10 Get Instance Details

  1. Click "View all instances"
  2. Find your instance (should be "Running")
  3. Note down the "Public IPv4 address" - you'll need this!

  ---
  🔐 Step 3: Connect to Your EC2 Instance

  3.1 Prepare Your Key File (Windows)

  If you're using Windows PowerShell or Git Bash:
  # Navigate to where you downloaded the .pem file
  cd Downloads

  # Set correct permissions
  chmod 400 portfolio-key.pem

  If you're using Windows Command Prompt:
  You'll need to use PuTTY - download from: https://www.putty.org/

  3.2 Connect via SSH

  Using PowerShell/Git Bash:
  ssh -i "portfolio-key.pem" ubuntu@YOUR_INSTANCE_PUBLIC_IP

  Replace YOUR_INSTANCE_PUBLIC_IP with the actual IP from Step 2.10

  Using PuTTY (Windows):
  1. Convert .pem to .ppk using PuTTYgen
  2. In PuTTY:
    - Host: ubuntu@YOUR_INSTANCE_PUBLIC_IP
    - Port: 22
    - Connection > SSH > Auth > Browse for your .ppk file

  3.3 First Connection

  1. You'll see a security warning - type "yes" and press Enter
  2. You should see: ubuntu@ip-xxx-xxx-xxx-xxx:~$
  3. You're now connected to your EC2 instance! 🎉

  ---
  🛠️ Step 4: Run Automated Setup

● Update Todos
  ⎿  ☒ Guide user through AWS account setup and EC2 launch
     ☒ Help with SSH connection to EC2 instance
     ☐ Guide through automated setup script execution
     ☐ Help configure domain DNS settings
     ☐ Guide through SSL certificate setup

● 4.1 Download the Setup Script

  In your EC2 terminal, run:
  # Download the automated setup script
  curl -o ec2-setup.sh
  https://raw.githubusercontent.com/LarianeMohceneMouad/SmartPortfolioPoweredChatbot/main/ec2-setup.sh

  # Make it executable
  chmod +x ec2-setup.sh

  4.2 Run the Setup Script

  ./ec2-setup.sh

  4.3 Answer the Prompts

  The script will ask you for:

  1. Domain name: yourdomain.com (your actual domain)
  2. GitHub repository URL: https://github.com/LarianeMohceneMouad/SmartPortfolioPoweredChatbot.git
  3. Database password: Choose a secure password (e.g., MySecurePass123!)
  4. Email for SSL: Your email address

  4.4 Wait for Setup to Complete

  - The script takes 10-15 minutes
  - It will install Node.js, PostgreSQL, PM2, Nginx
  - Clone your repository
  - Build and start your applications
  - You'll see progress messages

  4.5 Setup Complete!

  When finished, you'll see:
  🎉 EC2 Setup Complete!
  =================================

  Applications Status:
  ┌─────────────────────┬────┬─────────┬─────────┬─────────┬─────────┬────────┬─────┬───────────┬──────────┐
  │ App name            │ id │ version │ mode    │ pid     │ status  │ restart│ ...
  ├─────────────────────┼────┼─────────┼─────────┼─────────┼─────────┼────────┼─────┼───────────┼──────────┤
  │ portfolio-backend   │ 0  │ 1.0.0   │ fork    │ 1234    │ online  │ 0      │ ...
  │ portfolio-frontend  │ 1  │ 1.0.0   │ fork    │ 5678    │ online  │ 0      │ ...
  └─────────────────────┴────┴─────────┴─────────┴─────────┴─────────┴────────┴─────┴───────────┴──────────┘

  Your website will be available at: http://yourdomain.com
  Server IP Address: XXX.XXX.XXX.XXX