import mongoose, { Schema } from 'mongoose';
import { IUserInteraction } from '../types';

const userInteractionSchema = new Schema<IUserInteraction>({
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  trendId: {
    type: Schema.Types.ObjectId,
    ref: 'Trend',
    required: true
  },
  type: {
    type: String,
    required: true,
    enum: ['view', 'like', 'save', 'share']
  },
  timestamp: {
    type: Date,
    default: Date.now
  }
});

userInteractionSchema.index({ userId: 1, trendId: 1, type: 1 }, { unique: true });
userInteractionSchema.index({ timestamp: -1 });

export default mongoose.model<IUserInteraction>('UserInteraction', userInteractionSchema);