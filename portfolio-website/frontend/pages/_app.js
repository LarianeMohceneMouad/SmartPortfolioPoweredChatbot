import '../styles/globals.css'
import { useEffect } from 'react'

export default function App({ Component, pageProps }) {
  useEffect(() => {
    // Suppress hydration warnings in development
    if (process.env.NODE_ENV === 'development') {
      const originalError = console.error
      console.error = (...args) => {
        if (typeof args[0] === 'string' && args[0].includes('Warning: Text content did not match')) {
          return
        }
        if (typeof args[0] === 'string' && args[0].includes('Hydration failed')) {
          return
        }
        originalError.call(console, ...args)
      }
    }
  }, [])

  return <Component {...pageProps} />
}