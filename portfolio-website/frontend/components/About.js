import Timeline from './Timeline'

export default function About() {
  return (
    <section id="about" className="section-padding bg-white">
      <div className="container-max">
        <div className="max-w-6xl mx-auto">
          <h2 className="text-4xl font-bold text-center text-gray-800 mb-12">
            About Me
          </h2>
          
          <div className="grid md:grid-cols-2 gap-12 items-center">
            <div className="animate-slide-up">
              <img 
                src="/images/profile.jfif" 
                alt="Mohcene Mouad Lariane" 
                className="w-80 h-80 rounded-full mx-auto object-cover shadow-lg"
              />
            </div>
            
            <div className="animate-slide-up">
              <h3 className="text-2xl font-semibold text-gray-800 mb-6">
                Hello! I'm Mohcene, an Azure AI Technical Lead and researcher.
              </h3>
              
              <p className="text-gray-600 mb-6 leading-relaxed">
                Currently leading end-to-end Generative AI solutions at Microsoft-Accenture, 
                I specialize in Azure OpenAI, Machine Learning, and responsible AI practices. 
                My expertise spans from traditional machine learning to cutting-edge quantum 
                computing applications.
              </p>
              
              <p className="text-gray-600 mb-6 leading-relaxed">
                With a strong academic background as a valedictorian in both my Bachelor's and 
                Master's degrees, I've co-authored research papers on Quantum Machine Learning 
                and continue to bridge the gap between theoretical research and practical AI 
                implementations in enterprise environments.
              </p>
              
              <div className="flex flex-wrap gap-3">
                <span className="bg-blue-100 text-blue-800 px-3 py-1 rounded-full text-sm">
                  AI Research
                </span>
                <span className="bg-green-100 text-green-800 px-3 py-1 rounded-full text-sm">
                  Azure Expert
                </span>
                <span className="bg-purple-100 text-purple-800 px-3 py-1 rounded-full text-sm">
                  Quantum Computing
                </span>
                <span className="bg-orange-100 text-orange-800 px-3 py-1 rounded-full text-sm">
                  Technical Leadership
                </span>
                <span className="bg-red-100 text-red-800 px-3 py-1 rounded-full text-sm">
                  Data Science
                </span>
              </div>
            </div>
          </div>

          <Timeline />

          {/* Education Section */}
          <div className="mt-16">
            <h3 className="text-3xl font-semibold text-gray-800 mb-8 text-center">
              Education & Certifications
            </h3>
            <div className="grid md:grid-cols-2 gap-6">
              <div className="bg-gray-50 rounded-lg p-6">
                <h4 className="text-lg font-semibold text-gray-800 mb-2">Master's in Data Science</h4>
                <p className="text-blue-600 font-medium mb-2">WSB University</p>
                <p className="text-gray-600 text-sm">2023 - 2025</p>
              </div>
              
              <div className="bg-gray-50 rounded-lg p-6">
                <h4 className="text-lg font-semibold text-gray-800 mb-2">Master's in Networks & Distributed Systems</h4>
                <p className="text-blue-600 font-medium mb-2">University of Constantine 2</p>
                <p className="text-gray-600 text-sm">2021 - 2023 • Valedictorian</p>
              </div>
              
              <div className="bg-gray-50 rounded-lg p-6">
                <h4 className="text-lg font-semibold text-gray-800 mb-2">Bachelor's in Computer Science</h4>
                <p className="text-blue-600 font-medium mb-2">University of Constantine 2</p>
                <p className="text-gray-600 text-sm">2018 - 2021 • Valedictorian</p>
              </div>
              
              <div className="bg-gray-50 rounded-lg p-6">
                <h4 className="text-lg font-semibold text-gray-800 mb-2">Data Analysis Nano Degree</h4>
                <p className="text-blue-600 font-medium mb-2">Udacity</p>
                <p className="text-gray-600 text-sm">Advanced Data Analysis & Visualization</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  )
}