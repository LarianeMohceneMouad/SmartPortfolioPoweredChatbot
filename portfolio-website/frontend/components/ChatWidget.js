import { useEffect } from 'react'
import '@n8n/chat/style.css'

export default function ChatWidget() {
  const webhookUrl = process.env.NEXT_PUBLIC_CHAT_WEBHOOK_URL || 'YOUR_WEBHOOK_URL_HERE'

  useEffect(() => {
    console.log('🔗 n8n Chat widget webhook URL:', webhookUrl)
    
    if (webhookUrl === 'YOUR_WEBHOOK_URL_HERE') {
      console.warn('⚠️ Webhook URL not configured!')
      return
    }

    // Clean up any existing chat widget first
    const existingChat = document.querySelector('#n8n-chat')
    if (existingChat) {
      existingChat.innerHTML = ''
    }

    // Dynamically import createChat to avoid SSR issues
    import('@n8n/chat').then(({ createChat }) => {
      console.log('✅ Creating n8n chat widget...')
      
      createChat({
        webhookUrl: webhookUrl,
        mode: 'window',
        showWelcomeScreen: false,
        loadPreviousSession: false,
        initialMessages: [
          'Hi there! 👋',
          "I'm Mohcene's AI assistant. How can I help you learn more about his expertise in AI, machine learning, and quantum computing?"
        ],
        i18n: {
          en: {
            title: 'Chat with AI Assistant',
            subtitle: "Ask me anything about Mohcene's work and experience!",
            footer: '',
            getStarted: 'New Conversation',
            inputPlaceholder: 'Type your question...',
          },
        },
        target: '#n8n-chat'
      })
      
      console.log('✅ n8n chat widget created successfully')
      
    }).catch(error => {
      console.error('❌ Failed to load n8n chat:', error)
      console.error('Error details:', error.message)
    })
  }, [webhookUrl])

  return (
    <>
      {/* Container for n8n chat widget */}
      <div id="n8n-chat"></div>
      
      {/* Custom CSS to style the n8n chat widget */}
      <style jsx global>{`
        :root {
          --chat--color-primary: #2563eb;
          --chat--color-primary-shade-50: #1d4ed8;
          --chat--color-primary-shade-100: #1e40af;
          --chat--color-secondary: #10b981;
          --chat--color-secondary-shade-50: #059669;
          --chat--color-white: #ffffff;
          --chat--color-light: #f8fafc;
          --chat--color-light-shade-50: #e2e8f0;
          --chat--color-light-shade-100: #cbd5e1;
          --chat--color-medium: #64748b;
          --chat--color-dark: #1e293b;
          --chat--color-disabled: #94a3b8;
          --chat--color-typing: #475569;

          --chat--spacing: 1rem;
          --chat--border-radius: 0.5rem;
          --chat--transition-duration: 0.2s;

          --chat--window--width: 380px;
          --chat--window--height: 600px;

          --chat--header--background: linear-gradient(135deg, #2563eb 0%, #1e40af 100%);
          --chat--header--color: var(--chat--color-white);
          --chat--header--padding: 1.5rem;
          
          --chat--message--font-size: 0.95rem;
          --chat--message--padding: 0.75rem 1rem;
          --chat--message--border-radius: 1rem;
          --chat--message--bot--background: #f1f5f9;
          --chat--message--bot--color: #334155;
          --chat--message--user--background: #2563eb;
          --chat--message--user--color: var(--chat--color-white);

          --chat--toggle--background: #2563eb;
          --chat--toggle--hover--background: #1d4ed8;
          --chat--toggle--active--background: #1e40af;
          --chat--toggle--color: var(--chat--color-white);
          --chat--toggle--size: 60px;
        }
        
        /* Additional custom styling */
        #n8n-chat {
          font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }
        
        /* Ensure chat appears above other elements */
        [data-chat-window] {
          z-index: 1000 !important;
        }
        
        [data-chat-toggle] {
          z-index: 1001 !important;
          box-shadow: 0 4px 20px rgba(37, 99, 235, 0.3) !important;
        }
        
        [data-chat-toggle]:hover {
          box-shadow: 0 6px 25px rgba(37, 99, 235, 0.4) !important;
          transform: scale(1.05) !important;
        }
      `}</style>
    </>
  )
}