"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getRedditTrends = void 0;
const axios_1 = __importDefault(require("axios"));
const getRedditTrends = async () => {
    try {
        const response = await axios_1.default.get('https://www.reddit.com/r/popular.json?limit=10', {
            headers: {
                'User-Agent': 'TrendX-Backend/1.0'
            }
        });
        if (response.status === 200 && response.data.data && response.data.data.children) {
            return response.data.data.children.map((child) => {
                const post = child.data;
                return {
                    title: post.title,
                    content: post.selftext || post.url,
                    subreddit: post.subreddit,
                    score: post.score,
                    comments: post.num_comments,
                    author: post.author,
                    url: post.url,
                    thumbnail: post.thumbnail !== 'self' && post.thumbnail !== 'default' ? post.thumbnail : null
                };
            });
        }
        return [];
    }
    catch (error) {
        console.error('Error fetching Reddit trends:', error instanceof Error ? error.message : String(error));
        return [];
    }
};
exports.getRedditTrends = getRedditTrends;
