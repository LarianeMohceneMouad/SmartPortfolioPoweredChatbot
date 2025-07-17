const express = require('express')
const db = require('../config/database')
const { validateContact, handleValidationErrors } = require('../middleware/validation')

const router = express.Router()

// POST /api/contact - Submit contact form (forward to chatbot only)
router.post('/contact', validateContact, handleValidationErrors, async (req, res) => {
  const { name, email, message, webhook_format, contact_phone, contact_location } = req.body
  
  try {
    console.log(`📝 Contact form submission from ${email} - forwarding to chatbot`)
    
    // Send directly to n8n webhook (no database storage)
    const webhookUrl = process.env.N8N_WEBHOOK_URL
    
    if (!webhookUrl || webhookUrl === 'YOUR_WEBHOOK_URL_HERE') {
      throw new Error('n8n webhook URL not configured')
    }
    
    console.log('🤖 Forwarding to n8n webhook:', webhookUrl)
    
    const axios = require('axios')
    
    // Create formatted message
    const chatInput = `📝 **CONTACT FORM MESSAGE**

**Name:** ${name}
**Email:** ${email}
**Phone:** ${contact_phone || '+48 579-202-139'}
**Location:** ${contact_location || 'Poland / Remote'}

**Message:**
${message}

---
*This was a contact form submission from the portfolio website. Please respond to this inquiry about Mohcene's work and expertise.*`
    
    const webhookResponse = await axios.post(webhookUrl, {
      action: 'sendMessage',
      chatInput: chatInput,
      sessionId: `contact_form_${Date.now()}`
    }, {
      headers: {
        'Content-Type': 'application/json'
      },
      timeout: 15000
    })
    
    console.log('✅ Successfully forwarded to chatbot webhook:', webhookResponse.status)
    
    res.status(200).json({
      success: true,
      message: 'Contact form forwarded to chatbot successfully',
      data: {
        name: name,
        email: email,
        timestamp: new Date().toISOString(),
        webhook_status: webhookResponse.status
      }
    })
    
  } catch (error) {
    console.error('❌ Error forwarding contact form to chatbot:', error.message)
    console.error('Webhook error details:', error.response?.data)
    
    res.status(500).json({
      success: false,
      message: 'Failed to forward message to chatbot. Please try again later.',
      error: process.env.NODE_ENV === 'development' ? error.message : 'Internal error'
    })
  }
})

// GET /api/contacts - Get all contacts (for admin use)
router.get('/contacts', async (req, res) => {
  try {
    const query = `
      SELECT id, name, email, message, created_at
      FROM contacts
      ORDER BY created_at DESC
    `
    
    const result = await db.query(query)
    
    res.json({
      success: true,
      data: result.rows,
      count: result.rows.length
    })
    
  } catch (error) {
    console.error('Error fetching contacts:', error)
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    })
  }
})

// DELETE /api/contacts - Clear all contacts
router.delete('/contacts', async (req, res) => {
  try {
    const query = 'DELETE FROM contacts'
    const result = await db.query(query)
    
    console.log('🗑️ All contact data cleared')
    
    res.json({
      success: true,
      message: 'All contact data cleared successfully',
      deletedCount: result.rowCount || 0
    })
    
  } catch (error) {
    console.error('Error clearing contacts:', error)
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    })
  }
})

// GET /api/health - Health check endpoint
router.get('/health', async (req, res) => {
  try {
    await db.query('SELECT 1')
    res.json({
      success: true,
      message: 'API is healthy',
      timestamp: new Date().toISOString()
    })
  } catch (error) {
    console.error('Health check failed:', error)
    res.status(503).json({
      success: false,
      message: 'Service unavailable'
    })
  }
})

module.exports = router