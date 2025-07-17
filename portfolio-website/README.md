# Portfolio Website

A modern, responsive portfolio website built with Next.js, Node.js, and PostgreSQL. Features a beautiful frontend with smooth animations and a robust backend API for contact form submissions. Powered by a customized AI chatbot from n8b automation workflow agent

## 🚀 Features

- **Modern Design**: Clean, minimalist design with smooth animations
- **Responsive**: Fully responsive design that works on all devices
- **Contact Form**: Functional contact form with backend API and database storage
- **Performance**: Optimized for speed with Next.js and efficient database queries
- **Security**: Rate limiting, input validation, and SQL injection protection
- **SEO Friendly**: Proper meta tags and semantic HTML structure
- **Chatbot**: Connected to n8n Chatbot (I Workflow Agent) that handles questions about my resume

## 🛠️ Technology Stack

### Frontend
- **Next.js 14** - React framework with SSR and routing
- **React 18** - Modern React with hooks
- **Tailwind CSS** - Utility-first CSS framework
- **Axios** - HTTP client for API requests

### Backend
- **Node.js** - JavaScript runtime
- **Express.js** - Web application framework
- **PostgreSQL** - Relational database
- **pg** - PostgreSQL client for Node.js

### Additional Tools
- **Helmet** - Security middleware
- **CORS** - Cross-Origin Resource Sharing
- **Express Validator** - Input validation and sanitization
- **Express Rate Limit** - Rate limiting middleware
- **dotenv** - Environment variable management

## 📁 Project Structure

```
portfolio-website/
├── frontend/                 # Next.js frontend application
│   ├── components/          # Reusable React components
│   │   ├── Navbar.js
│   │   ├── Hero.js
│   │   ├── About.js
│   │   ├── Skills.js
│   │   ├── Projects.js
│   │   ├── ContactForm.js
│   │   └── Footer.js
│   ├── pages/               # Next.js pages
│   │   ├── _app.js
│   │   └── index.js
│   ├── styles/              # CSS styles
│   │   └── globals.css
│   ├── package.json
│   ├── tailwind.config.js
│   ├── postcss.config.js
│   └── next.config.js
├── backend/                 # Node.js backend API
│   ├── config/             # Configuration files
│   │   └── database.js
│   ├── middleware/         # Express middleware
│   │   └── validation.js
│   ├── routes/             # API routes
│   │   └── api.js
│   ├── server.js           # Main server file
│   ├── package.json
│   └── .env.example
├── database/               # Database schema and scripts
│   └── schema.sql
├── package.json           # Root package.json for scripts
├── .gitignore
└── README.md
```

## 🚀 Quick Start

### Prerequisites

Before you begin, ensure you have the following installed:
- **Node.js** (v16 or higher)
- **npm** (v8 or higher)
- **PostgreSQL** (v12 or higher)

### 1. Clone the Repository

```bash
git clone <your-repository-url>
cd portfolio-website
```

### 2. Install Dependencies

Install all dependencies for both frontend and backend:

```bash
npm run setup
```

Or install them manually:

```bash
# Install root dependencies
npm install

# Install frontend dependencies
cd frontend
npm install

# Install backend dependencies
cd ../backend
npm install
cd ..
```

### 3. Set Up PostgreSQL Database

#### Create Database
```sql
-- Connect to PostgreSQL as a superuser
psql -U postgres

-- Create database
CREATE DATABASE portfolio_db;

-- Create user (optional)
CREATE USER portfolio_user WITH PASSWORD 'your_password';
GRANT ALL PRIVILEGES ON DATABASE portfolio_db TO portfolio_user;
```

#### Run Database Schema
```bash
# Navigate to database directory
cd database

# Run the schema file
psql -U postgres -d portfolio_db -f schema.sql
```

### 4. Configure Environment Variables

Create a `.env` file in the `backend` directory:

```bash
cd backend
cp .env.example .env
```

Edit the `.env` file with your database credentials:

```env
# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=portfolio_db
DB_USER=postgres
DB_PASSWORD=your_password

# Server Configuration
PORT=3001
NODE_ENV=development

# CORS Configuration
FRONTEND_URL=http://localhost:3000
```

### 5. Start the Development Servers

From the root directory:

```bash
# Start both frontend and backend concurrently
npm run dev
```

Or start them separately:

```bash
# Terminal 1 - Frontend (Next.js)
npm run dev:frontend

# Terminal 2 - Backend (Express)
npm run dev:backend
```

### 6. Access the Application

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:3001
- **API Health Check**: http://localhost:3001/api/health

## 🔧 Available Scripts

### Root Directory
- `npm run setup` - Install all dependencies
- `npm run dev` - Start both servers in development mode
- `npm run build` - Build the frontend for production
- `npm start` - Start both servers in production mode

### Frontend (Next.js)
- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run start` - Start production server
- `npm run lint` - Run ESLint

### Backend (Express)
- `npm run dev` - Start development server with nodemon
- `npm start` - Start production server

## 📡 API Endpoints

### Contact Form
- **POST** `/api/contact` - Submit contact form
  ```json
  {
    "name": "John Doe",
    "email": "john@example.com",
    "message": "Hello, I'd like to discuss a project."
  }
  ```

### Admin Endpoints
- **GET** `/api/contacts` - Get all contact submissions
- **GET** `/api/health` - Health check endpoint

## 🔒 Security Features

- **Rate Limiting**: Prevents spam and DoS attacks
- **Input Validation**: Server-side validation and sanitization
- **SQL Injection Protection**: Parameterized queries
- **CORS Configuration**: Controlled cross-origin requests
- **Helmet**: Security headers
- **Environment Variables**: Sensitive data protection

## 🚀 Deployment

### Frontend (Vercel - Recommended)

1. **Push to GitHub**:
   ```bash
   git add .
   git commit -m "Initial commit"
   git push origin main
   ```

2. **Deploy to Vercel**:
   - Go to [vercel.com](https://vercel.com)
   - Import your GitHub repository
   - Set the root directory to `frontend`
   - Add environment variable: `NEXT_PUBLIC_API_URL=https://your-backend-url.com`

### Backend (Heroku)

1. **Create Heroku App**:
   ```bash
   heroku create your-portfolio-api
   ```

2. **Add PostgreSQL Add-on**:
   ```bash
   heroku addons:create heroku-postgresql:mini
   ```

3. **Set Environment Variables**:
   ```bash
   heroku config:set NODE_ENV=production
   heroku config:set FRONTEND_URL=https://your-frontend-url.vercel.app
   ```

4. **Deploy**:
   ```bash
   # Create a Procfile in backend directory
   echo "web: node server.js" > backend/Procfile
   
   # Deploy
   git subtree push --prefix backend heroku main
   ```

### Alternative Deployment Options

#### Backend
- **Railway**: Easy PostgreSQL + Node.js deployment
- **DigitalOcean App Platform**: Simple container deployment
- **AWS Elastic Beanstalk**: Scalable cloud deployment

#### Database
- **Heroku Postgres**: Managed PostgreSQL
- **AWS RDS**: Managed database service
- **DigitalOcean Managed Database**: Simple managed database

## 🎨 Customization

### Personalizing the Content

1. **Update Personal Information**:
   - Edit `frontend/components/Hero.js` - Name, title, bio
   - Edit `frontend/components/About.js` - About section content
   - Edit `frontend/components/Projects.js` - Your projects
   - Update social media links throughout components

2. **Styling**:
   - Modify `frontend/tailwind.config.js` for theme customization
   - Edit `frontend/styles/globals.css` for global styles
   - Update color schemes in component files

3. **Add New Sections**:
   - Create new components in `frontend/components/`
   - Import and add to `frontend/pages/index.js`

### Adding Features

1. **Blog Section**:
   - Add markdown support
   - Create blog API endpoints
   - Add blog components

2. **Admin Dashboard**:
   - Create admin authentication
   - Add contact management interface
   - Implement analytics

## 🐛 Troubleshooting

### Common Issues

1. **Database Connection Error**:
   - Verify PostgreSQL is running
   - Check database credentials in `.env`
   - Ensure database exists

2. **CORS Error**:
   - Check `FRONTEND_URL` in backend `.env`
   - Verify frontend is running on correct port

3. **Contact Form Not Working**:
   - Check network tab for API errors
   - Verify backend server is running
   - Check rate limiting settings

### Debug Mode

Enable debug logging by setting:
```env
NODE_ENV=development
```


## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Commit your changes: `git commit -m 'Add feature'`
4. Push to the branch: `git push origin feature-name`
5. Submit a pull request



Built with ❤️ by Mohcene Mouad Lariane