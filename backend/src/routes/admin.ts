import express from 'express';
import * as adminController from '../controllers/adminController';

const router = express.Router();

// Admin dashboard routes (no auth for demo - add auth middleware in production)
router.get('/stats', adminController.getDashboardStats);
router.get('/users', adminController.getUsersWithActivity);
router.get('/users/:userId/activity', adminController.getUserActivityDetails);
router.get('/active-users', adminController.getActiveUsers);
router.get('/analytics', adminController.getAnalytics);

export default router;