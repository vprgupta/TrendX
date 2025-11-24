"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ingestAllTrends = exports.initializeScheduler = void 0;
const node_cron_1 = __importDefault(require("node-cron"));
const Trend_1 = __importDefault(require("../models/Trend"));
const twitterService_1 = require("../services/twitterService");
const instagramService_1 = require("../services/instagramService");
const tiktokService_1 = require("../services/tiktokService");
const redditService_1 = require("../services/redditService");
const youtubeService_1 = require("../services/youtubeService");
const initializeScheduler = () => {
    console.log('📅 Initializing Trend Scheduler...');
    // Run every 6 hours
    node_cron_1.default.schedule('0 */6 * * *', async () => {
        console.log('🔄 Starting scheduled trend ingestion...');
        await (0, exports.ingestAllTrends)();
    });
    // Run immediately on startup (optional, for demo purposes)
    // setTimeout(() => ingestAllTrends(), 5000);
};
exports.initializeScheduler = initializeScheduler;
const ingestAllTrends = async () => {
    try {
        console.log('📥 Ingesting trends from all sources...');
        // Parallel fetching
        const [twitter, instagram, tiktok, reddit, youtube] = await Promise.all([
            (0, twitterService_1.getTwitterTrends)().catch(e => []),
            (0, instagramService_1.getInstagramTrends)().catch(e => []),
            (0, tiktokService_1.getTikTokTrends)().catch(e => []),
            (0, redditService_1.getRedditTrends)().catch(e => []),
            (0, youtubeService_1.getYouTubeTrends)().catch(e => [])
        ]);
        // Process and Save
        await saveTrends(twitter, 'twitter');
        await saveTrends(instagram, 'instagram');
        await saveTrends(tiktok, 'tiktok');
        await saveTrends(reddit, 'reddit');
        await saveTrends(youtube, 'youtube');
        console.log('✅ Trend ingestion complete!');
    }
    catch (error) {
        console.error('❌ Error during trend ingestion:', error);
    }
};
exports.ingestAllTrends = ingestAllTrends;
const saveTrends = async (trends, platform) => {
    if (!trends.length)
        return;
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
            await Trend_1.default.findOneAndUpdate({ title: trendData.title, platform }, trendData, { upsert: true, new: true });
        }
        catch (err) {
            console.error(`Failed to save trend ${item.name || item.title}:`, err);
        }
    }
};
