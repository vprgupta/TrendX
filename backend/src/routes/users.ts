import express from 'express';
import * as userController from '../controllers/userController';
import { authenticate } from '../middleware/auth';

const router = express.Router();

// All user routes require authentication
router.use(authenticate);

router.get('/profile', userController.getProfile);
router.put('/profile', userController.updateProfile);
router.get('/saved-trends', userController.getSavedTrends);
router.post('/saved-trends/:trendId', userController.saveTrend);
router.delete('/saved-trends/:trendId', userController.unsaveTrend);
router.post('/interactions', userController.trackInteraction);

export default router;