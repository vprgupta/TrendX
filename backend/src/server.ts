import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';
import dotenv from 'dotenv';
import path from 'path';
import 'express-async-errors';
import authRoutes from './routes/auth';
import trendRoutes from './routes/trends';
import userRoutes from './routes/users';
import adminRoutes from './routes/admin';
import sessionRoutes from './routes/sessions';
import { errorHandler } from './middleware/errorHandler';
import { connectDB } from './config/database';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Security middleware
app.use(helmet());
app.use(cors());
app.use(express.json({ limit: '10mb' }));

// Rate limiting
const generalLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
  message: { error: 'Too many requests, please try again later' }
});

const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 5, // limit auth requests
  message: { error: 'Too many auth attempts, please try again later' }
});

app.use('/api/', generalLimiter);
app.use('/api/auth/', authLimiter);

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/trends', trendRoutes);
app.use('/api/users', userRoutes);
app.use('/api/admin', adminRoutes);
app.use('/api/sessions', sessionRoutes);

// Serve dashboard
app.get('/dashboard', (req, res) => {
  res.sendFile(path.join(__dirname, '../admin-dashboard-with-sidebar.html'));
});

// Health check
app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', message: 'TrendX Backend is running' });
});

// Error handler
app.use(errorHandler);

// Start server
const startServer = async () => {
  await connectDB();
  app.listen(PORT, () => {
    console.log(`🚀 TrendX Backend running on port ${PORT}`);
  });
};

startServer();