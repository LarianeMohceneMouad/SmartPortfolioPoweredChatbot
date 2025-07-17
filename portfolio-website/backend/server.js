const express = require('express')
const cors = require('cors')
const helmet = require('helmet')
const rateLimit = require('express-rate-limit')
require('dotenv').config()

const db = require('./config/database')
const apiRoutes = require('./routes/api')

const app = express()
const PORT = process.env.PORT || 3001

// Security middleware
app.use(helmet({
  crossOriginResourcePolicy: { policy: "cross-origin" }
}))

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
  message: {
    success: false,
    message: 'Too many requests from this IP, please try again later.'
  }
})

const contactLimiter = rateLimit({
  windowMs: 60 * 60 * 1000, // 1 hour
  max: 5, // limit each IP to 5 contact form submissions per hour
  message: {
    success: false,
    message: 'Too many contact form submissions. Please try again later.'
  }
})

app.use(limiter)

// CORS configuration - Local development and ngrok
const corsOptions = {
  origin: [
    'http://localhost:3000',
    'http://127.0.0.1:3000',
    'https://6cc5a2851f6c.ngrok-free.app'  // Your new ngrok frontend URL
  ],
  credentials: true,
  optionsSuccessStatus: 200,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
}

app.use(cors(corsOptions))

// Body parsing middleware
app.use(express.json({ limit: '10mb' }))
app.use(express.urlencoded({ extended: true, limit: '10mb' }))

// Apply contact rate limiter to contact endpoint
app.use('/api/contact', contactLimiter)

// Routes
app.use('/api', apiRoutes)

// Root endpoint
app.get('/', (req, res) => {
  res.json({
    success: true,
    message: 'Portfolio Backend API',
    version: '1.0.0',
    endpoints: {
      contact: 'POST /api/contact',
      health: 'GET /api/health',
      contacts: 'GET /api/contacts'
    }
  })
})

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({
    success: false,
    message: 'Endpoint not found'
  })
})

// Global error handler
app.use((error, req, res, next) => {
  console.error('Unhandled error:', error)
  
  res.status(500).json({
    success: false,
    message: process.env.NODE_ENV === 'production' 
      ? 'Internal server error' 
      : error.message
  })
})

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('SIGTERM received. Shutting down gracefully...')
  server.close(() => {
    console.log('Process terminated')
  })
})

process.on('SIGINT', () => {
  console.log('SIGINT received. Shutting down gracefully...')
  server.close(() => {
    console.log('Process terminated')
  })
})

// Initialize database and start server
const startServer = async () => {
  try {
    await db.createTables()
    
    const server = app.listen(PORT, () => {
      console.log(`✅ Server running on port ${PORT}`)
      console.log(`🌍 Environment: ${process.env.NODE_ENV || 'development'}`)
      console.log(`📡 API Health: http://localhost:${PORT}/api/health`)
    })
    
    return server
  } catch (error) {
    console.error('❌ Failed to start server:', error)
    process.exit(1)
  }
}

startServer()

module.exports = app