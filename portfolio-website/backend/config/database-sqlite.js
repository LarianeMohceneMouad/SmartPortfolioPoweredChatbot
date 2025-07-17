const sqlite3 = require('sqlite3').verbose()
const path = require('path')
require('dotenv').config()

const dbPath = path.join(__dirname, '..', 'portfolio.db')
const db = new sqlite3.Database(dbPath)

const createTables = async () => {
  return new Promise((resolve, reject) => {
    const createContactsTable = `
      CREATE TABLE IF NOT EXISTS contacts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        message TEXT NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      );
    `
    
    const createIndexes = `
      CREATE INDEX IF NOT EXISTS idx_contacts_email ON contacts(email);
      CREATE INDEX IF NOT EXISTS idx_contacts_created_at ON contacts(created_at DESC);
    `
    
    db.serialize(() => {
      db.run(createContactsTable, (err) => {
        if (err) {
          console.error('Error creating contacts table:', err)
          reject(err)
          return
        }
      })
      
      db.run(createIndexes, (err) => {
        if (err) {
          console.error('Error creating indexes:', err)
          reject(err)
          return
        }
        console.log('✅ SQLite database tables created successfully')
        resolve()
      })
    })
  })
}

const query = (sql, params = []) => {
  return new Promise((resolve, reject) => {
    if (sql.trim().toUpperCase().startsWith('SELECT')) {
      db.all(sql, params, (err, rows) => {
        if (err) {
          reject(err)
        } else {
          resolve({ rows })
        }
      })
    } else if (sql.trim().toUpperCase().startsWith('INSERT')) {
      db.run(sql, params, function(err) {
        if (err) {
          reject(err)
        } else {
          // For INSERT, return the new row with the inserted ID
          const selectSql = 'SELECT * FROM contacts WHERE id = ?'
          db.get(selectSql, [this.lastID], (err, row) => {
            if (err) {
              reject(err)
            } else {
              resolve({ rows: [row] })
            }
          })
        }
      })
    } else {
      db.run(sql, params, function(err) {
        if (err) {
          reject(err)
        } else {
          resolve({ rowCount: this.changes })
        }
      })
    }
  })
}

const closeDatabase = () => {
  return new Promise((resolve) => {
    db.close((err) => {
      if (err) {
        console.error('Error closing database:', err)
      } else {
        console.log('Database connection closed')
      }
      resolve()
    })
  })
}

module.exports = {
  query,
  createTables,
  closeDatabase
}