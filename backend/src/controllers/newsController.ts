import { Request, Response } from 'express';
import { getNews } from '../services/newsService';

export const getNewsByCategory = async (req: Request, res: Response) => {
    const { category } = req.params;
    const { country = 'US' } = req.query;

    try {
        const newsItems = await getNews(category, country as string);
        res.json({
            success: true,
            category,
            country,
            count: newsItems.length,
            data: newsItems
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            error: 'Failed to fetch news'
        });
    }
};
