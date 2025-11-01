import { Response } from 'express';
import User from '../models/User';
import UserInteraction from '../models/UserInteraction';
import { AuthRequest } from '../types';

export const getProfile = async (req: AuthRequest, res: Response) => {
  const user = await User.findById(req.user?._id)
    .select('-password')
    .populate('savedTrends');
  
  res.json(user);
};

export const updateProfile = async (req: AuthRequest, res: Response) => {
  const { name, preferences } = req.body;
  
  const user = await User.findByIdAndUpdate(
    req.user?._id,
    { name, preferences },
    { new: true, runValidators: true }
  ).select('-password');

  res.json({ message: 'Profile updated', user });
};

export const saveTrend = async (req: AuthRequest, res: Response) => {
  const { trendId } = req.params;
  
  const user = await User.findById(req.user?._id);
  if (!user) {
    return res.status(404).json({ error: 'User not found' });
  }

  if (user.savedTrends.includes(trendId)) {
    return res.status(400).json({ error: 'Trend already saved' });
  }

  user.savedTrends.push(trendId);
  await user.save();

  await UserInteraction.create({
    userId: user._id,
    trendId,
    type: 'save'
  });

  res.json({ message: 'Trend saved successfully' });
};

export const unsaveTrend = async (req: AuthRequest, res: Response) => {
  const { trendId } = req.params;
  
  const user = await User.findById(req.user?._id);
  if (!user) {
    return res.status(404).json({ error: 'User not found' });
  }

  user.savedTrends = user.savedTrends.filter(id => id.toString() !== trendId);
  await user.save();

  res.json({ message: 'Trend removed from saved' });
};

export const getSavedTrends = async (req: AuthRequest, res: Response) => {
  const user = await User.findById(req.user?._id).populate('savedTrends');
  res.json({ savedTrends: user?.savedTrends || [] });
};

export const trackInteraction = async (req: AuthRequest, res: Response) => {
  const { trendId, type } = req.body;

  await UserInteraction.findOneAndUpdate(
    { userId: req.user?._id, trendId, type },
    { timestamp: new Date() },
    { upsert: true, new: true }
  );

  res.json({ message: 'Interaction tracked' });
};
