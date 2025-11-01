import mongoose, { Schema } from 'mongoose';
import { ITrend } from '../types';

const trendSchema = new Schema<ITrend>({
  title: {
    type: String,
    required: true,
    trim: true
  },
  content: {
    type: String,
    required: true
  },
  platform: {
    type: String,
    required: true,
    enum: ['youtube', 'twitter', 'reddit', 'news']
  },
  category: {
    type: String,
    required: true
  },
  country: {
    type: String,
    required: true,
    default: 'global'
  },
  metrics: {
    views: { type: Number, default: 0 },
    likes: { type: Number, default: 0 },
    shares: { type: Number, default: 0 },
    comments: { type: Number, default: 0 },
    engagement: { type: Number, default: 0 }
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

trendSchema.index({ platform: 1, country: 1, createdAt: -1 });
trendSchema.index({ category: 1, createdAt: -1 });

export default mongoose.model<ITrend>('Trend', trendSchema);