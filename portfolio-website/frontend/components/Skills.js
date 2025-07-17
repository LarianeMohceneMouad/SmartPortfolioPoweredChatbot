export default function Skills() {
  const skillCategories = [
    {
      title: "Programming & Development",
      skills: [
        { name: "Python", level: 95 },
        { name: "React", level: 90 },
        { name: "TypeScript", level: 85 },
        { name: "SQL", level: 90 },
        { name: "REST API", level: 92 }
      ]
    },
    {
      title: "AI & Machine Learning",
      skills: [
        { name: "Azure OpenAI", level: 95 },
        { name: "TensorFlow", level: 90 },
        { name: "PyTorch", level: 88 },
        { name: "Hugging Face", level: 92 },
        { name: "LangChain", level: 90 }
      ]
    },
    {
      title: "Cloud & DevOps",
      skills: [
        { name: "Azure Services", level: 95 },
        { name: "Docker", level: 85 },
        { name: "Kubernetes", level: 80 },
        { name: "Linux", level: 88 },
        { name: "GitHub", level: 92 }
      ]
    },
    {
      title: "Specialized Technologies",
      skills: [
        { name: "Quantum Computing", level: 85 },
        { name: "Qiskit", level: 88 },
        { name: "Azure Cognitive Services", level: 95 },
        { name: "Vector Databases", level: 85 },
        { name: "Data Visualization", level: 80 }
      ]
    }
  ]

  return (
    <section className="section-padding bg-gradient-to-br from-slate-900 via-gray-900 to-slate-900 relative">
      {/* Cool background pattern */}
      <div className="absolute inset-0 bg-gradient-to-r from-blue-600/10 to-purple-600/10"></div>
      <div className="absolute inset-0 opacity-20">
        <div className="absolute inset-0 bg-gradient-to-r from-transparent via-white/5 to-transparent animate-pulse"></div>
      </div>
      
      <div className="container-max relative z-10">
        <h2 className="text-4xl font-bold text-center text-white mb-12">
          <span className="bg-gradient-to-r from-cyan-400 to-purple-600 bg-clip-text text-transparent">
            Technical Skills & Expertise
          </span>
        </h2>
        
        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-8">
          {skillCategories.map((category, categoryIndex) => (
            <div key={categoryIndex} className="group relative bg-white/10 backdrop-blur-md rounded-xl p-6 border border-white/20 hover:border-cyan-400/50 transition-all duration-500 hover:shadow-xl hover:shadow-cyan-400/20 hover:scale-105 animate-fade-in-scale" style={{animationDelay: `${categoryIndex * 0.2}s`}}>
              <div className="absolute inset-0 bg-gradient-to-r from-cyan-400/10 to-purple-600/10 rounded-xl opacity-0 group-hover:opacity-100 transition-opacity duration-500"></div>
              
              <h3 className="relative text-xl font-semibold text-white mb-6 text-center group-hover:text-cyan-300 transition-colors duration-300">
                {category.title}
              </h3>
              
              <div className="relative space-y-4">
                {category.skills.map((skill, skillIndex) => (
                  <div key={skillIndex}>
                    <div className="flex justify-between text-sm mb-2">
                      <span className="text-gray-300 font-medium">{skill.name}</span>
                      <span className="text-cyan-400 font-semibold">{skill.level}%</span>
                    </div>
                    <div className="w-full bg-gray-700/50 rounded-full h-2 backdrop-blur-sm">
                      <div 
                        className="bg-gradient-to-r from-cyan-400 to-blue-600 h-2 rounded-full transition-all duration-1000 ease-out relative overflow-hidden"
                        style={{ width: `${skill.level}%` }}
                      >
                        <div className="absolute inset-0 bg-gradient-to-r from-transparent via-white/30 to-transparent animate-shimmer"></div>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          ))}
        </div>
        
        {/* Additional Technologies */}
        <div className="mt-16 text-center">
          <h3 className="text-2xl font-semibold text-white mb-8">
            <span className="bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">
              Additional Technologies & Tools
            </span>
          </h3>
          <div className="flex flex-wrap justify-center gap-3">
            {[
              "RAG", "MCP", "Flask", "FastAPI", "Pylint", "Pytest", "OpenCV", 
              "Kusto", "RDMS", "NoSQL", "Entra ID", "Azure Storage", "NLP", 
              "OCR", "Document Intelligence", "AKS", "ACI", "Jenkins", "Regex"
            ].map((tech, index) => (
              <span 
                key={index}
                className="group relative bg-white/10 backdrop-blur-sm border border-white/20 text-gray-300 px-4 py-2 rounded-full text-sm hover:border-purple-400/50 hover:text-white hover:shadow-lg hover:shadow-purple-400/20 transition-all duration-300 hover:scale-105"
                style={{animationDelay: `${index * 0.05}s`}}
              >
                <span className="relative z-10">{tech}</span>
                <div className="absolute inset-0 bg-gradient-to-r from-purple-600/20 to-pink-600/20 rounded-full opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
              </span>
            ))}
          </div>
        </div>

        {/* Certifications */}
        <div className="mt-16">
          <h3 className="text-3xl font-semibold text-white mb-8 text-center">
            <span className="bg-gradient-to-r from-orange-400 to-red-400 bg-clip-text text-transparent">
              Professional Certifications
            </span>
          </h3>
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
            <div className="bg-white/10 backdrop-blur-md rounded-xl p-6 border border-white/20 text-center hover:border-blue-400/50 transition-all duration-300 hover:scale-105">
              <div className="w-16 h-16 bg-blue-500/20 backdrop-blur-sm rounded-full flex items-center justify-center mx-auto mb-4">
                <svg className="w-8 h-8 text-blue-400" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
                </svg>
              </div>
              <h4 className="text-lg font-semibold text-white mb-2">Azure OpenAI Specialist</h4>
              <p className="text-gray-300 text-sm">CloudAcademy</p>
            </div>

            <div className="bg-white/10 backdrop-blur-md rounded-xl p-6 border border-white/20 text-center hover:border-green-400/50 transition-all duration-300 hover:scale-105">
              <div className="w-16 h-16 bg-green-500/20 backdrop-blur-sm rounded-full flex items-center justify-center mx-auto mb-4">
                <svg className="w-8 h-8 text-green-400" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
                </svg>
              </div>
              <h4 className="text-lg font-semibold text-white mb-2">Azure Fundamentals AZ-900</h4>
              <p className="text-gray-300 text-sm">Microsoft</p>
            </div>

            <div className="bg-white/10 backdrop-blur-md rounded-xl p-6 border border-white/20 text-center hover:border-purple-400/50 transition-all duration-300 hover:scale-105">
              <div className="w-16 h-16 bg-purple-500/20 backdrop-blur-sm rounded-full flex items-center justify-center mx-auto mb-4">
                <svg className="w-8 h-8 text-purple-400" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
                </svg>
              </div>
              <h4 className="text-lg font-semibold text-white mb-2">Azure AI Fundamentals AI-900</h4>
              <p className="text-gray-300 text-sm">Microsoft</p>
            </div>

            <div className="bg-white/10 backdrop-blur-md rounded-xl p-6 border border-white/20 text-center hover:border-orange-400/50 transition-all duration-300 hover:scale-105">
              <div className="w-16 h-16 bg-orange-500/20 backdrop-blur-sm rounded-full flex items-center justify-center mx-auto mb-4">
                <svg className="w-8 h-8 text-orange-400" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
                </svg>
              </div>
              <h4 className="text-lg font-semibold text-white mb-2">Data Analysis Nano Degree</h4>
              <p className="text-gray-300 text-sm">Udacity</p>
            </div>

            <div className="bg-white/10 backdrop-blur-md rounded-xl p-6 border border-white/20 text-center hover:border-red-400/50 transition-all duration-300 hover:scale-105">
              <div className="w-16 h-16 bg-red-500/20 backdrop-blur-sm rounded-full flex items-center justify-center mx-auto mb-4">
                <svg className="w-8 h-8 text-red-400" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
                </svg>
              </div>
              <h4 className="text-lg font-semibold text-white mb-2">Software Engineer</h4>
              <p className="text-gray-300 text-sm">HackerRank</p>
            </div>

            <div className="bg-white/10 backdrop-blur-md rounded-xl p-6 border border-white/20 text-center hover:border-indigo-400/50 transition-all duration-300 hover:scale-105">
              <div className="w-16 h-16 bg-indigo-500/20 backdrop-blur-sm rounded-full flex items-center justify-center mx-auto mb-4">
                <svg className="w-8 h-8 text-indigo-400" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
                </svg>
              </div>
              <h4 className="text-lg font-semibold text-white mb-2">Azure Cognitive Services</h4>
              <p className="text-gray-300 text-sm">CloudAcademy</p>
            </div>
          </div>
        </div>

        {/* Languages */}
        <div className="mt-16">
          <h3 className="text-3xl font-semibold text-white mb-8 text-center">
            <span className="bg-gradient-to-r from-green-400 to-teal-400 bg-clip-text text-transparent">
              Languages
            </span>
          </h3>
          <div className="grid md:grid-cols-4 gap-6">
            <div className="text-center group">
              <div className="w-20 h-20 bg-blue-500/20 backdrop-blur-sm rounded-full flex items-center justify-center mx-auto mb-4 border border-white/20 group-hover:border-blue-400/50 transition-all duration-300 group-hover:scale-110">
                <span className="text-2xl font-bold text-blue-400">EN</span>
              </div>
              <h4 className="font-semibold text-white">English</h4>
              <p className="text-gray-300 text-sm">Fluent</p>
            </div>
            
            <div className="text-center group">
              <div className="w-20 h-20 bg-red-500/20 backdrop-blur-sm rounded-full flex items-center justify-center mx-auto mb-4 border border-white/20 group-hover:border-red-400/50 transition-all duration-300 group-hover:scale-110">
                <span className="text-2xl font-bold text-red-400">FR</span>
              </div>
              <h4 className="font-semibold text-white">French</h4>
              <p className="text-gray-300 text-sm">Native</p>
            </div>
            
            <div className="text-center group">
              <div className="w-20 h-20 bg-green-500/20 backdrop-blur-sm rounded-full flex items-center justify-center mx-auto mb-4 border border-white/20 group-hover:border-green-400/50 transition-all duration-300 group-hover:scale-110">
                <span className="text-2xl font-bold text-green-400">AR</span>
              </div>
              <h4 className="font-semibold text-white">Arabic</h4>
              <p className="text-gray-300 text-sm">Native</p>
            </div>
            
            <div className="text-center group">
              <div className="w-20 h-20 bg-purple-500/20 backdrop-blur-sm rounded-full flex items-center justify-center mx-auto mb-4 border border-white/20 group-hover:border-purple-400/50 transition-all duration-300 group-hover:scale-110">
                <span className="text-2xl font-bold text-purple-400">PL</span>
              </div>
              <h4 className="font-semibold text-white">Polish</h4>
              <p className="text-gray-300 text-sm">Beginner</p>
            </div>
          </div>
        </div>
      </div>
    </section>
  )
}