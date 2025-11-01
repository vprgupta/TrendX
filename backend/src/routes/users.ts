import { Router } from 'express';
import {
  getProfile,
  updateProfile,
  saveTrend,
  unsaveTrend,
  getSavedTrends,
  trackInteraction
} from '../controllers/userController';
import { authenticate } from '../middleware/auth';
import { validate } from '../middleware/validation';
import { updateProfileSchema, interactionSchema } from '../utils/validation';

const router = Router();

router.use(authenticate);

router.get('/profile', getProfile);
router.put('/profile', validate(updateProfileSchema), updateProfile);
router.get('/saved-trends', getSavedTrends);
router.post('/saved-trends/:trendId', saveTrend);
router.delete('/saved-trends/:trendId', unsaveTrend);
router.post('/interactions', validate(interactionSchema), trackInteraction);

export default router;
