# TrendX Backend API

A complete Node.js backend for the TrendX social media trend analysis platform.

## 🚀 Features

- **Express.js** server with TypeScript
- **MongoDB** database with Mongoose ODM
- **JWT** authentication system
- **bcrypt** password hashing
- **CORS** and security middleware
- **Rate limiting** protection
- **Input validation** with Joi
- **Error handling** middleware
- **RESTful API** endpoints

## 📦 Installation

```bash
cd backend
npm install
```

## 🔧 Configuration

1. Copy `.env.example` to `.env`:
```bash
cp .env.example .env
```

2. Update environment variables:
```env
PORT=5000
NODE_ENV=development
MONGODB_URI=mongodb://localhost:27017/trendx
JWT_SECRET=your-super-secret-jwt-key-here
JWT_EXPIRE=7d
BCRYPT_ROUNDS=12
```

## 🏃‍♂️ Running the Server

### Development
```bash
npm run dev
```

### Production
```bash
npm run build
npm start
```

### Quick Start
```bash
node start.js
```

## 📚 API Endpoints

### Authentication
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login

### Trends
- `GET /api/trends` - Get all trends (with pagination)
- `GET /api/trends/:id` - Get trend by ID
- `GET /api/trends/search?q=query` - Search trends
- `GET /api/trends/platform/:platform` - Get trends by platform
- `GET /api/trends/country/:country` - Get trends by country
- `GET /api/trends/category/:category` - Get trends by category
- `POST /api/trends` - Create new trend (authenticated)

### Users
- `GET /api/users/profile` - Get user profile (authenticated)
- `PUT /api/users/profile` - Update user profile (authenticated)
- `GET /api/users/saved-trends` - Get saved trends (authenticated)
- `POST /api/users/saved-trends/:trendId` - Save trend (authenticated)
- `DELETE /api/users/saved-trends/:trendId` - Unsave trend (authenticated)
- `POST /api/users/interactions` - Track user interaction (authenticated)

### Health Check
- `GET /health` - Server health status

## 🗄️ Database Schemas

### User Schema
```typescript
{
  email: string (unique, required)
  password: string (hashed, required)
  name: string (required)
  preferences: {
    platforms: string[]
    categories: string[]
    countries: string[]
  }
  savedTrends: ObjectId[]
  createdAt: Date
}
```

### Trend Schema
```typescript
{
  title: string (required)
  content: string (required)
  platform: 'youtube' | 'twitter' | 'reddit' | 'news' (required)
  category: string (required)
  country: string (default: 'global')
  metrics: {
    views: number
    likes: number
    shares: number
    comments: number
    engagement: number
  }
  createdAt: Date
}
```

### UserInteraction Schema
```typescript
{
  userId: ObjectId (required)
  trendId: ObjectId (required)
  type: 'view' | 'like' | 'save' | 'share' (required)
  timestamp: Date
}
```

## 🔒 Security Features

- **Helmet.js** for security headers
- **CORS** configuration
- **Rate limiting** (100 requests/15min, 5 auth requests/15min)
- **JWT** token authentication
- **bcrypt** password hashing (12 rounds)
- **Input validation** with Joi schemas
- **Request size limits** (10MB)

## 🛠️ Project Structure

```
backend/
├── src/
│   ├── controllers/     # Route controllers
│   ├── middleware/      # Custom middleware
│   ├── models/         # Database models
│   ├── routes/         # API routes
│   ├── types/          # TypeScript types
│   ├── utils/          # Utility functions
│   └── server.ts       # Main server file
├── .env.example        # Environment template
├── package.json        # Dependencies
├── tsconfig.json       # TypeScript config
└── start.js           # Development starter
```

## 📝 Usage Examples

### Register User
```bash
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123",
    "name": "John Doe"
  }'
```

### Login User
```bash
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123"
  }'
```

### Get Trends
```bash
curl -X GET "http://localhost:5000/api/trends?platform=youtube&limit=10"
```

### Save Trend (Authenticated)
```bash
curl -X POST http://localhost:5000/api/users/saved-trends/TREND_ID \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## 🚨 Error Handling

The API returns consistent error responses:

```json
{
  "error": "Error message",
  "details": ["Validation error details"]
}
```

Common HTTP status codes:
- `200` - Success
- `201` - Created
- `400` - Bad Request
- `401` - Unauthorized
- `404` - Not Found
- `429` - Too Many Requests
- `500` - Internal Server Error

## 🔄 Development

### Available Scripts
- `npm run dev` - Start development server with nodemon
- `npm run build` - Build TypeScript to JavaScript
- `npm start` - Start production server
- `npm test` - Run tests (when implemented)

### Code Style
- TypeScript for type safety
- Async/await for asynchronous operations
- Express async errors for error handling
- Mongoose for MongoDB operations
- Joi for input validation

## 📈 Next Steps

1. Add Redis caching
2. Implement WebSocket support
3. Add comprehensive testing
4. Set up CI/CD pipeline
5. Add API documentation with Swagger
6. Implement logging with Winston
7. Add monitoring and metrics
8. Set up Docker containerization

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.