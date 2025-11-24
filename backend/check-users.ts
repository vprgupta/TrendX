import mongoose from 'mongoose';
import User from './src/models/User';
import { connectDB } from './src/config/database';
import dotenv from 'dotenv';
import path from 'path';

dotenv.config({ path: path.join(__dirname, '../../.env') });

(async () => {
    try {
        await connectDB();
        const count = await User.countDocuments();
        console.log(`User Count: ${count}`);

        if (count > 0) {
            const user = await User.findOne().sort({ createdAt: -1 });
            console.log('Latest User:', user?.email);
        }
    } catch (error) {
        console.error('Error:', error);
    } finally {
        await mongoose.disconnect();
        process.exit(0);
    }
})();
