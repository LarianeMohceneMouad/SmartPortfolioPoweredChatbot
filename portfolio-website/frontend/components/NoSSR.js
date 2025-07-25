import { useEffect, useState } from 'react'

// Component to prevent hydration issues for client-only content
export default function NoSSR({ children, fallback = null }) {
  const [hasMounted, setHasMounted] = useState(false)

  useEffect(() => {
    setHasMounted(true)
  }, [])

  if (!hasMounted) {
    return fallback
  }

  return children
}