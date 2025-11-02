import mongoose from 'mongoose';

const trendSchema = new mongoose.Schema({
  platform: { type: String, required: true },
  title: { type: String, required: true },
  content: String,
  author: String,
  likes: { type: Number, default: 0 },
  comments: { type: Number, default: 0 },
  shares: { type: Number, default: 0 },
  country: String,
  category: String,
  videoId: String,
  mediaUrl: String,
  externalUrl: String,
  rank: Number
}, { timestamps: true });

export default mongoose.model('Trend', trendSchema);