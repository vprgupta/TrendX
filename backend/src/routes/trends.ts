import express from 'express';
import * as trendController from '../controllers/trendController';
import { authenticate } from '../middleware/auth';
import { validateTrend } from '../middleware/validation';

const router = express.Router();

router.get('/', trendController.getTrends);
router.get('/search', trendController.searchTrends);
router.get('/platform/:platform', trendController.getTrendsByPlatform);
router.get('/country/:country', trendController.getTrendsByCountry);
router.get('/category/:category', trendController.getTrendsByCategory);
router.get('/:id', trendController.getTrendById);
router.post('/', authenticate, validateTrend, trendController.createTrend);
router.put('/:id', authenticate, validateTrend, trendController.updateTrend);
router.delete('/:id', authenticate, trendController.deleteTrend);

export default router;