import { Request, Response } from 'express';
import Trend from '../models/Trend';
import { AuthRequest } from '../types';

export const getTrends = async (req: Request, res: Response) => {
  const { platform, country, category, limit = 20, page = 1 } = req.query;
  
  const filter: any = {};
  if (platform) filter.platform = platform;
  if (country) filter.country = country;
  if (category) filter.category = category;

  const trends = await Trend.find(filter)
    .sort({ createdAt: -1 })
    .limit(Number(limit))
    .skip((Number(page) - 1) * Number(limit));

  const total = await Trend.countDocuments(filter);

  res.json({
    trends,
    pagination: {
      page: Number(page),
      limit: Number(limit),
      total,
      pages: Math.ceil(total / Number(limit))
    }
  });
};

export const getTrendById = async (req: Request, res: Response) => {
  const trend = await Trend.findById(req.params.id);
  
  if (!trend) {
    return res.status(404).json({ error: 'Trend not found' });
  }

  res.json(trend);
};

export const searchTrends = async (req: Request, res: Response) => {
  const { q, limit = 20 } = req.query;

  if (!q) {
    return res.status(400).json({ error: 'Search query required' });
  }

  const trends = await Trend.find({
    $or: [
      { title: { $regex: q, $options: 'i' } },
      { content: { $regex: q, $options: 'i' } }
    ]
  })
    .sort({ createdAt: -1 })
    .limit(Number(limit));

  res.json({ trends, count: trends.length });
};

export const getTrendsByPlatform = async (req: Request, res: Response) => {
  const { platform } = req.params;
  const { limit = 20 } = req.query;

  const trends = await Trend.find({ platform })
    .sort({ createdAt: -1 })
    .limit(Number(limit));

  res.json({ platform, trends, count: trends.length });
};

export const getTrendsByCountry = async (req: Request, res: Response) => {
  const { country } = req.params;
  const { limit = 20 } = req.query;

  const trends = await Trend.find({ country })
    .sort({ createdAt: -1 })
    .limit(Number(limit));

  res.json({ country, trends, count: trends.length });
};

export const getTrendsByCategory = async (req: Request, res: Response) => {
  const { category } = req.params;
  const { limit = 20 } = req.query;

  const trends = await Trend.find({ category })
    .sort({ createdAt: -1 })
    .limit(Number(limit));

  res.json({ category, trends, count: trends.length });
};

export const createTrend = async (req: Request, res: Response) => {
  const trend = await Trend.create(req.body);
  res.status(201).json({ message: 'Trend created', trend });
};
