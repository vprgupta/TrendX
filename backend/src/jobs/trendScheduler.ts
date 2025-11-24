import cron from 'node-cron';
import Trend from '../models/Trend';
import { getTwitterTrends } from '../services/twitterService';
import { getInstagramTrends } from '../services/instagramService';
import { getTikTokTrends } from '../services/tiktokService';
import { getRedditTrends } from '../services/redditService';
import { getYouTubeTrends } from '../services/youtubeService';

export const initializeScheduler = () => {
    console.log('📅 Initializing Trend Scheduler...');

    // Run every 6 hours
    cron.schedule('0 */6 * * *', async () => {
        console.log('🔄 Starting scheduled trend ingestion...');
        await ingestAllTrends();
    });

    // Run immediately on startup (optional, for demo purposes)
    // setTimeout(() => ingestAllTrends(), 5000);
};

export const ingestAllTrends = async () => {
    try {
        console.log('📥 Ingesting trends from all sources...');

        // Parallel fetching
        const [twitter, instagram, tiktok, reddit, youtube] = await Promise.all([
            getTwitterTrends().catch(e => []),
            getInstagramTrends().catch(e => []),
            getTikTokTrends().catch(e => []),
            getRedditTrends().catch(e => []),
            getYouTubeTrends().catch(e => [])
        ]);

        // Process and Save
        await saveTrends(twitter, 'twitter');
        await saveTrends(instagram, 'instagram');
        await saveTrends(tiktok, 'tiktok');
        await saveTrends(reddit, 'reddit');
        await saveTrends(youtube, 'youtube');

        console.log('✅ Trend ingestion complete!');
    } catch (error) {
        console.error('❌ Error during trend ingestion:', error);
    }
};

const saveTrends = async (trends: any[], platform: string) => {
    if (!trends.length) return;
    console.log(`💾 Saving ${trends.length} trends for ${platform}...`);

    for (const item of trends) {
        try {
            // Normalize data structure
            const trendData = {
                title: item.title || item.name || 'Untitled Trend',
                content: item.content || item.description || item.title || '',
                platform,
                category: item.subreddit || 'general',
                country: 'global',
                metrics: {
                    views: item.views || item.tweet_volume || item.posts || 0,
                    likes: item.score || 0,
                    shares: 0,
                    comments: item.comments || 0,
                    engagement: 0
                },
                createdAt: new Date()
            };

            // Upsert (update if exists, insert if new) based on title and platform
            await Trend.findOneAndUpdate(
                { title: trendData.title, platform },
                trendData,
                { upsert: true, new: true }
            );
        } catch (err) {
            console.error(`Failed to save trend ${item.name || item.title}:`, err);
        }
    }
};
