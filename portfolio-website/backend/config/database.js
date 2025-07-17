require('dotenv').config()

// Choose database based on environment or availability
const usePostgreSQL = process.env.USE_POSTGRESQL === 'true' && process.env.DB_USER

let dbModule

if (usePostgreSQL) {
  // PostgreSQL setup
  const { Pool } = require('pg')
  
  const pool = new Pool({
    host: process.env.DB_HOST || 'localhost',
    port: process.env.DB_PORT || 5432,
    database: process.env.DB_NAME || 'portfolio_db',
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false,
    max: 20,
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 2000,
  })

  pool.on('connect', () => {
    console.log('✅ Connected to PostgreSQL database')
  })

  pool.on('error', (err) => {
    console.error('Unexpected error on idle client', err)
    process.exit(-1)
  })

  const createTables = async () => {
    try {
      const createContactsTable = `
        CREATE TABLE IF NOT EXISTS contacts (
          id SERIAL PRIMARY KEY,
          name VARCHAR(255) NOT NULL,
          email VARCHAR(255) NOT NULL,
          message TEXT NOT NULL,
          created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
      `
      
      await pool.query(createContactsTable)
      console.log('✅ PostgreSQL tables created successfully')
    } catch (error) {
      console.error('Error creating tables:', error)
      throw error
    }
  }

  dbModule = {
    query: (text, params) => pool.query(text, params),
    createTables
  }
} else {
  // SQLite setup (fallback)
  console.log('📁 Using SQLite database (PostgreSQL not configured)')
  const sqliteDb = require('./database-sqlite')
  dbModule = sqliteDb
}

module.exports = dbModule