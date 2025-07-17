export default function Projects() {
  const projects = [
    {
      id: 1,
      title: "Talky-App-Project",
      description: "A mobile application for kids focused on pronunciation learning for different languages. Built with Java, featuring automatic speech recognition and interactive learning modules for language education.",
      image: "https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=600&h=400&fit=crop",
      technologies: ["Java", "Speech Recognition", "Mobile Development", "NLP", "Audio Processing"],
      liveDemo: "https://github.com/LarianeMohceneMouad/Talky-App-Project",
      sourceCode: "https://github.com/LarianeMohceneMouad/Talky-App-Project"
    },
    {
      id: 2,
      title: "Quantum Machine Learning Binary Classifier",
      description: "Implementation of Variational Circuit Based Hybrid Quantum-Classical Algorithm (VC-HQCA) from scratch. Comprehensive comparison with Qiskit VQC classifier for binary classification tasks.",
      image: "https://images.unsplash.com/photo-1635070041078-e363dbe005cb?w=600&h=400&fit=crop",
      technologies: ["Python", "Qiskit", "Quantum Computing", "Machine Learning", "Circuit Design"],
      liveDemo: "https://github.com/LarianeMohceneMouad/Variation-Circuit-Based-Hybrid-Quantum-Classical-Binary-Algorithm",
      sourceCode: "https://github.com/LarianeMohceneMouad/Variation-Circuit-Based-Hybrid-Quantum-Classical-Binary-Algorithm"
    },
    {
      id: 3,
      title: "Azure AI Solutions Portfolio",
      description: "Collection of enterprise-grade Generative AI solutions built on Azure platform. Includes LLM integrations, responsible AI implementations, and production-ready GenAI applications.",
      image: "https://images.unsplash.com/photo-1677442136019-21780ecad995?w=600&h=400&fit=crop",
      technologies: ["Azure OpenAI", "LangChain", "Python", "REST APIs", "Azure Cognitive Services"],
      liveDemo: "https://github.com/LarianeMohceneMouad",
      sourceCode: "https://github.com/LarianeMohceneMouad"
    },
    {
      id: 4,
      title: "Research Publications & Papers",
      description: "Academic research contributions including the published paper on 'Variational Circuit Based Hybrid Quantum-Classical Algorithm VC-HQCA' presented at QSAC 2023 conference.",
      image: "/images/profile.jfif",
      technologies: ["Research", "Quantum ML", "Academic Writing", "Conference Presentation", "Peer Review"],
      liveDemo: "https://link.springer.com/chapter/10.1007/978-3-031-50215-6_1",
      sourceCode: "https://github.com/LarianeMohceneMouad"
    }
  ]

  const researchPapers = [
    {
      title: "Variational Circuit Based Hybrid Quantum-Classical Algorithm VC-HQCA",
      authors: "Lariane, M.M., Belhadef, H.",
      conference: "QSAC 2023 - Quantum Computing: Applications and Challenges",
      year: "2024",
      description: "Novel approach to quantum machine learning using variational circuits for binary classification tasks.",
      link: "https://link.springer.com/chapter/10.1007/978-3-031-50215-6_1"
    }
  ]

  return (
    <section id="projects" className="section-padding bg-gradient-to-br from-gray-50 to-gray-100 relative">
      {/* Subtle background pattern */}
      <div className="absolute inset-0 opacity-20">
        <div className="absolute inset-0 bg-gradient-to-r from-transparent via-gray-300/10 to-transparent animate-pulse"></div>
      </div>
      
      <div className="container-max relative z-10">
        <h2 className="text-4xl font-bold text-center text-gray-800 mb-12">
          <span className="relative">
            Featured Projects & Research
            <div className="absolute -bottom-2 left-1/2 transform -translate-x-1/2 w-24 h-1 bg-gradient-to-r from-blue-500 to-purple-600 rounded-full"></div>
          </span>
        </h2>
        
        <div className="grid md:grid-cols-2 gap-8 mb-16">
          {projects.map((project, index) => (
            <div 
              key={project.id} 
              className="group relative bg-white rounded-2xl shadow-xl overflow-hidden border border-gray-200/50 hover:shadow-2xl hover:shadow-blue-500/10 transition-all duration-500 hover:-translate-y-2 animate-fade-in-scale"
              style={{animationDelay: `${index * 0.2}s`}}
            >
              {/* Cool gradient border on hover */}
              <div className="absolute inset-0 bg-gradient-to-r from-blue-500 via-purple-500 to-pink-500 rounded-2xl opacity-0 group-hover:opacity-100 transition-opacity duration-500 -z-10 blur-sm"></div>
              
              <div className="relative overflow-hidden rounded-t-2xl">
                <img 
                  src={project.image} 
                  alt={project.title}
                  className="w-full h-48 object-cover transition-all duration-500 group-hover:scale-110"
                />
                <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-all duration-300 flex items-center justify-center">
                  <div className="transform translate-y-4 group-hover:translate-y-0 transition-transform duration-300">
                    <div className="flex space-x-4">
                      <a 
                        href={project.liveDemo} 
                        target="_blank" 
                        rel="noopener noreferrer"
                        className="bg-white/90 backdrop-blur-sm text-gray-800 px-4 py-2 rounded-lg font-medium hover:bg-white transition-all duration-300 transform hover:scale-105"
                      >
                        View Project
                      </a>
                      <a 
                        href={project.sourceCode} 
                        target="_blank" 
                        rel="noopener noreferrer"
                        className="bg-gray-800/90 backdrop-blur-sm text-white px-4 py-2 rounded-lg font-medium hover:bg-gray-800 transition-all duration-300 transform hover:scale-105"
                      >
                        Source Code
                      </a>
                    </div>
                  </div>
                </div>
              </div>
              
              <div className="relative p-6 bg-white">
                <h3 className="text-xl font-semibold text-gray-800 mb-3 group-hover:text-blue-600 transition-colors duration-300">
                  {project.title}
                </h3>
                <p className="text-gray-600 mb-4 leading-relaxed">
                  {project.description}
                </p>
                
                <div className="flex flex-wrap gap-2 mb-4">
                  {project.technologies.map((tech, techIndex) => (
                    <span 
                      key={techIndex}
                      className="bg-gradient-to-r from-blue-100 to-purple-100 text-blue-700 text-xs px-3 py-1 rounded-full font-medium hover:from-blue-200 hover:to-purple-200 transition-all duration-300 hover:scale-105 cursor-default"
                    >
                      {tech}
                    </span>
                  ))}
                </div>
                
                <div className="flex space-x-4">
                  <a 
                    href={project.liveDemo} 
                    target="_blank" 
                    rel="noopener noreferrer"
                    className="group/link text-blue-600 hover:text-blue-800 font-medium transition-all duration-300 flex items-center"
                  >
                    View Project 
                    <svg className="w-4 h-4 ml-1 transform group-hover/link:translate-x-1 transition-transform duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 8l4 4m0 0l-4 4m4-4H3" />
                    </svg>
                  </a>
                  <a 
                    href={project.sourceCode} 
                    target="_blank" 
                    rel="noopener noreferrer"
                    className="group/link text-gray-600 hover:text-gray-800 font-medium transition-all duration-300 flex items-center"
                  >
                    View Code
                    <svg className="w-4 h-4 ml-1 transform group-hover/link:translate-x-1 transition-transform duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 8l4 4m0 0l-4 4m4-4H3" />
                    </svg>
                  </a>
                </div>
              </div>
            </div>
          ))}
        </div>

        {/* Research Publications Section */}
        <div className="mt-16">
          <h3 className="text-3xl font-semibold text-gray-800 mb-8 text-center">
            Research Publications
          </h3>
          
          {researchPapers.map((paper, index) => (
            <div key={index} className="bg-gray-50 rounded-lg p-8 shadow-md mb-6">
              <div className="flex flex-col md:flex-row md:justify-between md:items-start mb-4">
                <div className="flex-1">
                  <h4 className="text-xl font-semibold text-gray-800 mb-2">{paper.title}</h4>
                  <p className="text-gray-600 mb-2">
                    <span className="font-medium">Authors:</span> {paper.authors}
                  </p>
                  <p className="text-blue-600 font-medium mb-2">{paper.conference}</p>
                  <p className="text-gray-600 leading-relaxed">{paper.description}</p>
                </div>
                <div className="mt-4 md:mt-0 md:ml-6">
                  <span className="bg-blue-100 text-blue-800 px-3 py-1 rounded-full text-sm font-medium">
                    {paper.year}
                  </span>
                </div>
              </div>
              <div className="flex space-x-4">
                <a 
                  href={paper.link} 
                  target="_blank" 
                  rel="noopener noreferrer"
                  className="text-blue-600 hover:text-blue-800 font-medium transition-colors"
                >
                  Read Paper →
                </a>
              </div>
            </div>
          ))}
        </div>

        {/* GitHub Stats */}
        <div className="mt-16 text-center">
          <h3 className="text-3xl font-semibold text-gray-800 mb-8">
            Open Source Contributions
          </h3>
          
          <div className="grid md:grid-cols-3 gap-6 mb-8">
            <div className="bg-gray-50 rounded-lg p-6 text-center hover-lift">
              <div className="text-3xl font-bold text-blue-600 mb-2">10+</div>
              <p className="text-gray-600">Repositories</p>
            </div>
            <div className="bg-gray-50 rounded-lg p-6 text-center hover-lift">
              <div className="text-3xl font-bold text-green-600 mb-2">1</div>
              <p className="text-gray-600">Published Paper</p>
            </div>
            <div className="bg-gray-50 rounded-lg p-6 text-center hover-lift">
              <div className="text-3xl font-bold text-purple-600 mb-2">3+</div>
              <p className="text-gray-600">Years Experience</p>
            </div>
          </div>
          
          <a 
            href="https://github.com/LarianeMohceneMouad" 
            target="_blank" 
            rel="noopener noreferrer"
            className="btn-primary inline-flex items-center"
          >
            View All Projects on GitHub
            <svg className="w-5 h-5 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
            </svg>
          </a>
        </div>
      </div>
    </section>
  )
}