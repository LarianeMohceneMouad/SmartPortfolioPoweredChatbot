import { useEffect } from 'react'

export default function ScrollAnimations() {
  useEffect(() => {
    const observerOptions = {
      threshold: 0.1,
      rootMargin: '0px 0px -50px 0px'
    }

    const observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add('revealed')
          
          // Add stagger animation to children if the element has stagger class
          if (entry.target.classList.contains('stagger-children')) {
            const children = entry.target.children
            Array.from(children).forEach((child, index) => {
              setTimeout(() => {
                child.classList.add('animate-slide-in-up')
              }, index * 100)
            })
          }
        }
      })
    }, observerOptions)

    // Observe all elements with scroll-reveal class
    const elements = document.querySelectorAll('.scroll-reveal')
    elements.forEach((el) => observer.observe(el))

    // Floating elements animation
    const floatingElements = document.querySelectorAll('.animate-float')
    floatingElements.forEach((element, index) => {
      element.style.animationDelay = `${index * 0.5}s`
    })

    // Parallax effect for background elements
    const handleScroll = () => {
      const scrolled = window.pageYOffset
      const parallaxElements = document.querySelectorAll('.parallax-element')
      
      parallaxElements.forEach((element) => {
        const speed = element.dataset.speed || 0.5
        const yPos = -(scrolled * speed)
        element.style.transform = `translateY(${yPos}px)`
      })
    }

    window.addEventListener('scroll', handleScroll)

    return () => {
      observer.disconnect()
      window.removeEventListener('scroll', handleScroll)
    }
  }, [])

  return null
}