import { Request } from 'express';
import { Document } from 'mongoose';

export interface IUser extends Document {
  email: string;
  password: string;
  name: string;
  preferences: {
    platforms: string[];
    categories: string[];
    countries: string[];
  };
  savedTrends: string[];
  createdAt: Date;
  comparePassword(password: string): Promise<boolean>;
}

export interface ITrend extends Document {
  title: string;
  content: string;
  platform: string;
  category: string;
  country: string;
  metrics: {
    views: number;
    likes: number;
    shares: number;
    comments: number;
    engagement: number;
  };
  createdAt: Date;
}

export interface IUserInteraction extends Document {
  userId: string;
  trendId: string;
  type: 'view' | 'like' | 'save' | 'share';
  timestamp: Date;
}

export interface AuthRequest extends Request {
  user?: IUser;
}