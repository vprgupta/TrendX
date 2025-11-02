import mongoose, { Document } from 'mongoose';
import bcrypt from 'bcryptjs';

interface IUser extends Document {
  email: string;
  password: string;
  name: string;
  savedTrends: mongoose.Types.ObjectId[];
  preferences: {
    platforms: string[];
    countries: string[];
    categories: string[];
  };
  stats: {
    following: number;
    bookmarks: number;
    views: number;
  };
  comparePassword(password: string): Promise<boolean>;
}

const userSchema = new mongoose.Schema<IUser>({
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  name: { type: String, required: true },
  savedTrends: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Trend' }],
  preferences: {
    platforms: [String],
    countries: [String],
    categories: [String]
  },
  stats: {
    following: { type: Number, default: 0 },
    bookmarks: { type: Number, default: 0 },
    views: { type: Number, default: 0 }
  }
}, { timestamps: true });

userSchema.pre('save', async function(next) {
  if (!this.isModified('password')) return next();
  this.password = await bcrypt.hash(this.password, 10);
  next();
});

userSchema.methods.comparePassword = async function(password: string) {
  return bcrypt.compare(password, this.password);
};

export default mongoose.model<IUser>('User', userSchema);