import mongoose from 'mongoose';

const trendSchema = new mongoose.Schema({
  platform: { type: String, required: true },
  title: { type: String, required: true },
  content: String,
  author: String,
  country: { type: String, default: 'global' },
  category: String,
  videoId: String,
  mediaUrl: String,
  externalUrl: String,
  rank: Number,
  metrics: {
    views: { type: Number, default: 0 },
    likes: { type: Number, default: 0 },
    shares: { type: Number, default: 0 },
    comments: { type: Number, default: 0 },
    engagement: { type: Number, default: 0 }
  },
  // Keep backward compatibility
  likes: { type: Number, default: 0 },
  comments: { type: Number, default: 0 },
  shares: { type: Number, default: 0 }
}, { timestamps: true });

export default mongoose.model('Trend', trendSchema);