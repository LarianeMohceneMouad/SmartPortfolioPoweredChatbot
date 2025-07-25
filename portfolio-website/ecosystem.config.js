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
      time: true,
      // Health check
      health_check_grace_period: 3000,
      health_check_fatal_exceptions: true,
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
      time: true,
      // Health check
      health_check_grace_period: 3000,
      health_check_fatal_exceptions: true,
    }
  ],

  deploy: {
    production: {
      user: 'ubuntu',
      host: 'your-server-ip',
      ref: 'origin/main',
      repo: 'https://github.com/LarianeMohceneMouad/SmartPortfolioPoweredChatbot.git',
      path: '/home/ubuntu/SmartPortfolioPoweredChatbot',
      'pre-deploy-local': '',
      'post-deploy': 'cd backend && npm install --production && cd ../frontend && npm install && npm run build && pm2 reload ecosystem.config.js --env production',
      'pre-setup': ''
    }
  }
};