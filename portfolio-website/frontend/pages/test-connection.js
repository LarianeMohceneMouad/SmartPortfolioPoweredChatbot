import { useState, useEffect } from 'react'
import axios from 'axios'

export default function TestConnection() {
  const [testResult, setTestResult] = useState('')
  const [isLoading, setIsLoading] = useState(false)
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
  }, [])

  const testBackendConnection = async () => {
    setIsLoading(true)
    setTestResult('Testing connection...')
    
    try {
      const backendUrl = process.env.NEXT_PUBLIC_BACKEND_URL || 'http://localhost:3001'
      console.log('Testing backend URL:', backendUrl)
      
      // Test health endpoint
      const healthResponse = await axios.get(`${backendUrl}/api/health`, {
        headers: {
          'ngrok-skip-browser-warning': 'true',
        },
        timeout: 10000,
      })
      
      console.log('Health check response:', healthResponse.data)
      
      // Test form submission
      const testData = {
        name: 'Test User',
        email: 'test@example.com',
        message: 'This is a test message to verify the connection works!'
      }
      
      const submitResponse = await axios.post(`${backendUrl}/api/contact`, testData, {
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        timeout: 10000,
      })
      
      console.log('Form submission response:', submitResponse.data)
      
      setTestResult(`
✅ SUCCESS! Connection working perfectly!

Backend URL: ${backendUrl}
Health Check: ${JSON.stringify(healthResponse.data, null, 2)}
Form Submission: ${JSON.stringify(submitResponse.data, null, 2)}
      `)
      
    } catch (error) {
      console.error('Connection test failed:', error)
      setTestResult(`
❌ CONNECTION FAILED!

Error: ${error.message}
Status: ${error.response?.status || 'No response'}
Backend URL: ${process.env.NEXT_PUBLIC_BACKEND_URL || 'http://localhost:3001'}

Details: ${JSON.stringify(error.response?.data || {}, null, 2)}
      `)
    } finally {
      setIsLoading(false)
    }
  }

  const viewContacts = async () => {
    setIsLoading(true)
    try {
      const backendUrl = process.env.NEXT_PUBLIC_BACKEND_URL || 'http://localhost:3001'
      const response = await axios.get(`${backendUrl}/api/contacts`, {
        timeout: 10000,
      })
      
      setTestResult(`
📋 CONTACTS IN DATABASE:

${JSON.stringify(response.data, null, 2)}
      `)
    } catch (error) {
      setTestResult(`❌ Failed to fetch contacts: ${error.message}`)
    } finally {
      setIsLoading(false)
    }
  }

  const clearContacts = async () => {
    setIsLoading(true)
    try {
      const backendUrl = process.env.NEXT_PUBLIC_BACKEND_URL || 'http://localhost:3001'
      const response = await axios.delete(`${backendUrl}/api/contacts`, {
        timeout: 10000,
      })
      
      setTestResult(`
🗑️ CONTACTS CLEARED:

${JSON.stringify(response.data, null, 2)}
      `)
    } catch (error) {
      setTestResult(`❌ Failed to clear contacts: ${error.message}`)
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <div style={{ padding: '20px', fontFamily: 'monospace' }}>
      <h1>🔧 Backend Connection Test</h1>
      
      <div style={{ marginBottom: '20px' }}>
        <p><strong>Frontend URL:</strong> {mounted ? window.location.origin : 'Loading...'}</p>
        <p><strong>Backend URL:</strong> {process.env.NEXT_PUBLIC_BACKEND_URL || 'http://localhost:3001'}</p>
      </div>
      
      <div style={{ marginBottom: '20px' }}>
        <button 
          onClick={testBackendConnection} 
          disabled={isLoading}
          style={{ 
            padding: '10px 20px', 
            marginRight: '10px', 
            backgroundColor: '#0070f3', 
            color: 'white', 
            border: 'none', 
            borderRadius: '5px',
            cursor: isLoading ? 'not-allowed' : 'pointer'
          }}
        >
          {isLoading ? 'Testing...' : 'Test Connection & Submit Form'}
        </button>
        
        <button 
          onClick={viewContacts} 
          disabled={isLoading}
          style={{ 
            padding: '10px 20px', 
            marginRight: '10px',
            backgroundColor: '#28a745', 
            color: 'white', 
            border: 'none', 
            borderRadius: '5px',
            cursor: isLoading ? 'not-allowed' : 'pointer'
          }}
        >
          View Database Contacts
        </button>

        <button 
          onClick={clearContacts} 
          disabled={isLoading}
          style={{ 
            padding: '10px 20px', 
            backgroundColor: '#dc3545', 
            color: 'white', 
            border: 'none', 
            borderRadius: '5px',
            cursor: isLoading ? 'not-allowed' : 'pointer'
          }}
        >
          Clear All Contacts
        </button>
      </div>
      
      <pre style={{ 
        backgroundColor: '#f5f5f5', 
        padding: '20px', 
        borderRadius: '5px', 
        border: '1px solid #ddd',
        whiteSpace: 'pre-wrap',
        minHeight: '200px'
      }}>
        {testResult || 'Click "Test Connection" to verify your setup...'}
      </pre>
      
      <div style={{ marginTop: '20px', fontSize: '14px', color: '#666' }}>
        <p><strong>Instructions:</strong></p>
        <ol>
          <li>Make sure your backend server is running (npm start)</li>
          <li>Make sure ngrok tunnel is active for backend</li>
          <li>Click "Test Connection" to verify everything works</li>
          <li>Check browser console (F12) for detailed logs</li>
        </ol>
      </div>
    </div>
  )
}