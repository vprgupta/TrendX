import { Response } from 'express';
import User from '../models/User';
import Trend from '../models/Trend';
import UserInteraction from '../models/UserInteraction';
import { AuthRequest } from '../types';

export const getProfile = async (req: AuthRequest, res: Response) => {
  const user = await User.findById(req.user?._id).select('-password').populate('savedTrends');
  res.json(user);
};

export const updateProfile = async (req: AuthRequest, res: Response) => {
  const { name, preferences } = req.body;
  
  const user = await User.findByIdAndUpdate(
    req.user?._id,
    { name, preferences },
    { new: true }
  ).select('-password');
  
  res.json({ message: 'Profile updated', user });
};

export const getSavedTrends = async (req: AuthRequest, res: Response) => {
  const user = await User.findById(req.user?._id).populate('savedTrends');
  res.json({ savedTrends: user?.savedTrends || [] });
};

export const saveTrend = async (req: AuthRequest, res: Response) => {
  const { trendId } = req.params;
  
  const trend = await Trend.findById(trendId);
  if (!trend) {
    return res.status(404).json({ error: 'Trend not found' });
  }

  await User.findByIdAndUpdate(req.user?._id, {
    $addToSet: { savedTrends: trendId }
  });

  // Track interaction
  await UserInteraction.create({
    userId: req.user?._id,
    trendId,
    type: 'save'
  });

  res.json({ message: 'Trend saved' });
};

export const unsaveTrend = async (req: AuthRequest, res: Response) => {
  const { trendId } = req.params;
  
  await User.findByIdAndUpdate(req.user?._id, {
    $pull: { savedTrends: trendId }
  });

  res.json({ message: 'Trend unsaved' });
};

export const trackInteraction = async (req: AuthRequest, res: Response) => {
  const { trendId, type } = req.body;
  
  await UserInteraction.create({
    userId: req.user?._id,
    trendId,
    type
  });

  res.json({ message: 'Interaction tracked' });
};