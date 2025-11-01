import { Router } from 'express';
import {
  getTrends,
  getTrendById,
  searchTrends,
  getTrendsByPlatform,
  getTrendsByCountry,
  getTrendsByCategory,
  createTrend
} from '../controllers/trendController';
import { authenticate } from '../middleware/auth';
import { validate } from '../middleware/validation';
import { trendSchema } from '../utils/validation';

const router = Router();

router.get('/', getTrends);
router.get('/search', searchTrends);
router.get('/platform/:platform', getTrendsByPlatform);
router.get('/country/:country', getTrendsByCountry);
router.get('/category/:category', getTrendsByCategory);
router.get('/:id', getTrendById);
router.post('/', authenticate, validate(trendSchema), createTrend);

export default router;
