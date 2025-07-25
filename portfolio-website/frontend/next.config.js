/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  images: {
    domains: ['images.unsplash.com', 'via.placeholder.com'],
  },
  // Enable standalone output for Docker
  output: 'standalone',
  // Prevent hydration issues
  experimental: {
    esmExternals: false,
  },
  // Optimize for production
  compiler: {
    removeConsole: process.env.NODE_ENV === 'production',
  },
  // Configure for Docker networking
  async rewrites() {
    return [
      {
        source: '/api/:path*',
        destination: `${process.env.NEXT_PUBLIC_API_URL || 'http://backend:3001'}/api/:path*`,
      },
    ]
  },
}

module.exports = nextConfig