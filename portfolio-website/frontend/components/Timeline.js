import { useState, useEffect } from 'react'

export default function Timeline() {
  const [expandedItems, setExpandedItems] = useState({})
  const [visibleItems, setVisibleItems] = useState({})

  const timelineData = [
    {
      id: 'current',
      date: 'Sep 2024 - Present',
      title: 'Azure AI Technical Lead',
      company: 'Microsoft - Accenture',
      type: 'work',
      color: 'blue',
      description: 'Leading development of end-to-end Generative AI solutions from concept to production on Azure. Designing GenAI strategies using Azure OpenAI, Machine Learning, and Cognitive Services while ensuring responsible AI practices.',
      achievements: [
        'Led implementation of 15+ GenAI solutions in production',
        'Optimized model performance achieving 40% cost reduction',
        'Mentored cross-functional teams on responsible AI practices'
      ]
    },
    {
      id: 'sme2024',
      date: 'May 2024 - Sep 2024',
      title: 'Azure AI Subject Matter Expert',
      company: 'Microsoft - LTIMindtree',
      type: 'work',
      color: 'green',
      description: 'Advised clients on Azure-based Generative AI integration best practices. Led design and deployment of LLM solutions using Azure OpenAI and mentored junior engineers in building scalable GenAI applications.',
      achievements: [
        'Consulted for 10+ enterprise clients on AI strategy',
        'Designed scalable LLM architectures for production',
        'Trained 25+ engineers in Azure AI technologies'
      ]
    },
    {
      id: 'bip2024',
      date: 'May 2024 - Jun 2024',
      title: 'BIP - Data Analytics',
      company: 'Varna University, Bulgaria',
      type: 'education',
      color: 'purple',
      description: 'Erasmus+ International Program focused on advanced data analytics methodologies and cross-cultural academic collaboration.',
      achievements: [
        'Advanced statistical modeling techniques',
        'Cross-cultural research methodologies',
        'International academic collaboration'
      ]
    },
    {
      id: 'master2023',
      date: '2023 - 2025',
      title: "Master's in Data Science",
      company: 'WSB University',
      type: 'education',
      color: 'indigo',
      description: 'Advanced studies in data science methodologies, machine learning algorithms, and statistical analysis. Master thesis: "Driving fatigue detector based on Facial Recognition".',
      achievements: [
        'Advanced ML algorithms and neural networks',
        'Computer vision and facial recognition systems',
        'Statistical analysis and data visualization'
      ]
    },
    {
      id: 'engineer2023',
      date: 'May 2023 - May 2024',
      title: 'Azure AI Engineer',
      company: 'Microsoft - LTIMindtree',
      type: 'work',
      color: 'orange',
      description: 'Supported Azure AI services with issue resolution and uptime assurance. Collaborated with product teams to address limitations and improve offerings.',
      achievements: [
        'Maintained 99.9% uptime for AI services',
        'Resolved 200+ technical issues',
        'Improved service performance by 30%'
      ]
    },
    {
      id: 'erasmus2023',
      date: 'March 2023 - August 2023',
      title: 'Erasmus+ Mobility Program',
      company: 'WSB University - Data Science',
      type: 'education',
      color: 'pink',
      description: 'International exchange program focusing on data science applications and cross-cultural academic collaboration in European context.',
      achievements: [
        'International data science methodologies',
        'Cross-cultural academic projects',
        'European research collaboration'
      ]
    },
    {
      id: 'master2021',
      date: '2021 - 2023',
      title: "Master's in Networks & Distributed Systems",
      company: 'University of Constantine 2 • Valedictorian',
      type: 'education',
      color: 'red',
      description: 'Specialized in distributed computing, network architecture, and quantum machine learning. Dissertation: "Variational Circuits based Quantum Machine Learning binary classifier".',
      achievements: [
        'Graduated as Valedictorian (Top of Class)',
        'Published research on Quantum ML at QSAC 2023',
        'Advanced distributed systems architecture'
      ]
    },
    {
      id: 'researcher2021',
      date: 'Sep 2021 - Jun 2023',
      title: 'AI Researcher',
      company: 'University Of Constantine 2',
      type: 'work',
      color: 'teal',
      description: 'Conducted cutting-edge research in language models, Natural Language Processing, and Quantum Machine Learning. Co-authored research paper on VC-HQCA presented at QSAC 2023.',
      achievements: [
        'Co-authored paper published at QSAC 2023 conference',
        'Developed novel quantum-classical hybrid algorithms',
        'Advanced NLP and language model research'
      ]
    },
    {
      id: 'bachelor2018',
      date: '2018 - 2021',
      title: "Bachelor's in Computer Science",
      company: 'University of Constantine 2 • Valedictorian',
      type: 'education',
      color: 'emerald',
      description: 'Foundation in computer science principles, programming, and software engineering. Dissertation: "Virtual space for pronunciation learning of different languages based on automatic speech recognition".',
      achievements: [
        'Graduated as Valedictorian (Top of Class)',
        'Advanced speech recognition research',
        'Mobile app development for language learning'
      ]
    }
  ]

  useEffect(() => {
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            const id = entry.target.getAttribute('data-id')
            setVisibleItems(prev => ({ ...prev, [id]: true }))
          }
        })
      },
      { threshold: 0.3 }
    )

    const elements = document.querySelectorAll('[data-id]')
    elements.forEach((el) => observer.observe(el))

    return () => observer.disconnect()
  }, [])

  const toggleExpand = (id) => {
    setExpandedItems(prev => ({
      ...prev,
      [id]: !prev[id]
    }))
  }

  const getColorClasses = (color) => {
    const colors = {
      blue: 'border-blue-600 text-blue-600 bg-blue-600',
      green: 'border-green-600 text-green-600 bg-green-600',
      purple: 'border-purple-600 text-purple-600 bg-purple-600',
      indigo: 'border-indigo-600 text-indigo-600 bg-indigo-600',
      orange: 'border-orange-600 text-orange-600 bg-orange-600',
      pink: 'border-pink-600 text-pink-600 bg-pink-600',
      red: 'border-red-600 text-red-600 bg-red-600',
      teal: 'border-teal-600 text-teal-600 bg-teal-600',
      yellow: 'border-yellow-600 text-yellow-600 bg-yellow-600',
      emerald: 'border-emerald-600 text-emerald-600 bg-emerald-600'
    }
    return colors[color] || colors.blue
  }

  return (
    <div className="mt-16">
      <h3 className="text-3xl font-semibold text-gray-800 mb-12 text-center animate-fade-in">
        Professional Journey & Education Timeline
      </h3>
      
      <div className="relative">
        {/* Timeline Line */}
        <div className="absolute left-1/2 transform -translate-x-px h-full w-0.5 bg-gradient-to-b from-blue-600 via-purple-600 to-yellow-600"></div>
        
        {/* Timeline Items */}
        <div className="space-y-12">
          {timelineData.map((item, index) => {
            const isLeft = index % 2 === 0
            const isExpanded = expandedItems[item.id]
            const isVisible = visibleItems[item.id]
            const colorClasses = getColorClasses(item.color)
            
            return (
              <div 
                key={item.id}
                data-id={item.id}
                className={`relative flex items-center transition-all duration-1000 transform ${
                  isVisible 
                    ? 'translate-y-0 opacity-100' 
                    : isLeft 
                      ? '-translate-x-20 opacity-0' 
                      : 'translate-x-20 opacity-0'
                }`}
                style={{ transitionDelay: `${index * 200}ms` }}
              >
                {/* Left Content */}
                <div className={`flex-1 ${isLeft ? 'text-right pr-8' : 'pr-8'}`}>
                  {isLeft && (
                    <div 
                      className={`bg-white p-6 rounded-lg shadow-lg border-l-4 ${colorClasses} cursor-pointer transform transition-all duration-300 hover:shadow-xl hover:scale-105`}
                      onClick={() => toggleExpand(item.id)}
                    >
                      <div className={`text-sm font-semibold mb-1 ${colorClasses.split(' ')[1]}`}>
                        {item.date}
                      </div>
                      <div className="flex items-center justify-between mb-2">
                        <h4 className="text-xl font-bold text-gray-800">{item.title}</h4>
                        <svg 
                          className={`w-5 h-5 text-gray-400 transition-transform duration-300 ${isExpanded ? 'rotate-180' : ''}`}
                          fill="none" 
                          stroke="currentColor" 
                          viewBox="0 0 24 24"
                        >
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                        </svg>
                      </div>
                      <p className={`font-medium mb-3 ${colorClasses.split(' ')[1]}`}>
                        {item.company}
                      </p>
                      <p className="text-gray-600 leading-relaxed">
                        {item.description}
                      </p>
                      
                      {/* Expandable Content */}
                      <div className={`overflow-hidden transition-all duration-500 ${
                        isExpanded ? 'max-h-96 opacity-100 mt-4' : 'max-h-0 opacity-0'
                      }`}>
                        <div className="border-t pt-4">
                          <h5 className="font-semibold text-gray-800 mb-2">Key Achievements:</h5>
                          <ul className="space-y-1">
                            {item.achievements.map((achievement, idx) => (
                              <li key={idx} className="text-gray-600 flex items-start">
                                <span className={`w-2 h-2 rounded-full ${colorClasses.split(' ')[2]} mt-2 mr-2 flex-shrink-0`}></span>
                                {achievement}
                              </li>
                            ))}
                          </ul>
                        </div>
                      </div>
                    </div>
                  )}
                </div>
                
                {/* Center Dot */}
                <div className={`absolute left-1/2 transform -translate-x-1/2 w-6 h-6 ${colorClasses.split(' ')[2]} rounded-full border-4 border-white shadow-lg z-10 transition-all duration-500 hover:scale-125`}>
                  <div className={`absolute inset-1 ${colorClasses.split(' ')[2]} rounded-full animate-pulse`}></div>
                </div>
                
                {/* Right Content */}
                <div className={`flex-1 ${!isLeft ? 'pl-8' : 'pl-8'}`}>
                  {!isLeft && (
                    <div 
                      className={`bg-white p-6 rounded-lg shadow-lg border-r-4 ${colorClasses} cursor-pointer transform transition-all duration-300 hover:shadow-xl hover:scale-105`}
                      onClick={() => toggleExpand(item.id)}
                    >
                      <div className={`text-sm font-semibold mb-1 ${colorClasses.split(' ')[1]}`}>
                        {item.date}
                      </div>
                      <div className="flex items-center justify-between mb-2">
                        <h4 className="text-xl font-bold text-gray-800">{item.title}</h4>
                        <svg 
                          className={`w-5 h-5 text-gray-400 transition-transform duration-300 ${isExpanded ? 'rotate-180' : ''}`}
                          fill="none" 
                          stroke="currentColor" 
                          viewBox="0 0 24 24"
                        >
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                        </svg>
                      </div>
                      <p className={`font-medium mb-3 ${colorClasses.split(' ')[1]}`}>
                        {item.company}
                      </p>
                      <p className="text-gray-600 leading-relaxed">
                        {item.description}
                      </p>
                      
                      {/* Expandable Content */}
                      <div className={`overflow-hidden transition-all duration-500 ${
                        isExpanded ? 'max-h-96 opacity-100 mt-4' : 'max-h-0 opacity-0'
                      }`}>
                        <div className="border-t pt-4">
                          <h5 className="font-semibold text-gray-800 mb-2">Key Achievements:</h5>
                          <ul className="space-y-1">
                            {item.achievements.map((achievement, idx) => (
                              <li key={idx} className="text-gray-600 flex items-start">
                                <span className={`w-2 h-2 rounded-full ${colorClasses.split(' ')[2]} mt-2 mr-2 flex-shrink-0`}></span>
                                {achievement}
                              </li>
                            ))}
                          </ul>
                        </div>
                      </div>
                    </div>
                  )}
                </div>
              </div>
            )
          })}
        </div>
      </div>
    </div>
  )
}