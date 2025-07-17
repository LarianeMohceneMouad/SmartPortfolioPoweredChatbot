import Head from 'next/head'
import Navbar from '../components/Navbar'
import Hero from '../components/Hero'
import About from '../components/About'
import Skills from '../components/Skills'
import Projects from '../components/Projects'
import ContactForm from '../components/ContactForm'
import Footer from '../components/Footer'
import ScrollAnimations from '../components/ScrollAnimations'
import ChatWidget from '../components/ChatWidget'

export default function Home() {
  return (
    <>
      <Head>
        <title>Mohcene Mouad Lariane - Azure AI Technical Lead</title>
        <meta name="description" content="Mohcene Mouad Lariane - Azure AI Technical Lead specializing in Generative AI, Machine Learning, and Quantum Computing. Leading AI solutions at Microsoft-Accenture." />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <meta property="og:title" content="Mohcene Mouad Lariane - Azure AI Technical Lead" />
        <meta property="og:description" content="Azure AI Technical Lead specializing in Generative AI, Machine Learning, and Quantum Computing research." />
        <meta property="og:type" content="website" />
        <meta name="twitter:card" content="summary_large_image" />
        <meta name="keywords" content="Azure AI, Machine Learning, Quantum Computing, Generative AI, Python, TensorFlow, Azure OpenAI, Research, Data Science" />
        <meta name="author" content="Mohcene Mouad Lariane" />
        <link rel="icon" href="/favicon.ico" />
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="true" />
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
      </Head>

      <main>
        <ScrollAnimations />
        <Navbar />
        <Hero />
        <div className="scroll-reveal">
          <About />
        </div>
        <div className="scroll-reveal">
          <Skills />
        </div>
        <div className="scroll-reveal">
          <Projects />
        </div>
        <div className="scroll-reveal">
          <ContactForm />
        </div>
        <Footer />
        
        {/* Chat Widget */}
        <ChatWidget />
      </main>
    </>
  )
}