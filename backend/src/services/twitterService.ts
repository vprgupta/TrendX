import { TwitterApi } from 'twitter-api-v2';
import cacheService from './cacheService';

interface TwitterTrend {
  name: string;
  url: string;
  promoted_content: boolean;
  query: string;
  tweet_volume: number | null;
}

interface Tweet {
  id: string;
  text: string;
  author_id: string;
  created_at: string;
  public_metrics: {
    retweet_count: number;
    like_count: number;
    reply_count: number;
    quote_count: number;
  };
  author?: {
    username: string;
    name: string;
    profile_image_url: string;
  };
}

class TwitterService {
  private client: TwitterApi | null = null;

  constructor() {
    if (process.env.TWITTER_BEARER_TOKEN) {
      this.client = new TwitterApi(process.env.TWITTER_BEARER_TOKEN);
    }
  }

  async getTrendingTopics(woeid = 1): Promise<TwitterTrend[]> {
    if (!this.client) {
      throw new Error('Twitter API not configured');
    }

    const cacheKey = cacheService.generateKey('twitter', 'trends', woeid.toString());
    const cached = await cacheService.get(cacheKey);
    if (cached) return cached;

    try {
      const trends = await this.client.v1.trendsAvailable();
      const trendData = trends.find(location => location.woeid === woeid);
      
      if (!trendData) {
        throw new Error('Location not found');
      }

      const trendingTopics = await this.client.v1.trends({ id: woeid });
      const trends_list: TwitterTrend[] = trendingTopics[0].trends.map(trend => ({
        name: trend.name,
        url: trend.url,
        promoted_content: trend.promoted_content || false,
        query: trend.query,
        tweet_volume: trend.tweet_volume
      }));

      await cacheService.set(cacheKey, trends_list, 300); // 5 minutes cache
      return trends_list;
    } catch (error) {
      console.error('Twitter trends error:', error);
      throw new Error('Failed to fetch Twitter trending topics');
    }
  }

  async searchTweets(query: string, maxResults = 100): Promise<Tweet[]> {
    if (!this.client) {
      throw new Error('Twitter API not configured');
    }

    const cacheKey = cacheService.generateKey('twitter', 'search', query);
    const cached = await cacheService.get(cacheKey);
    if (cached) return cached;

    try {
      const tweets = await this.client.v2.search(query, {
        max_results: maxResults,
        'tweet.fields': ['created_at', 'public_metrics', 'author_id'],
        'user.fields': ['username', 'name', 'profile_image_url'],
        expansions: ['author_id']
      });

      const users = tweets.includes?.users || [];
      const userMap = new Map(users.map(user => [user.id, user]));

      const formattedTweets: Tweet[] = tweets.data?.map(tweet => ({
        id: tweet.id,
        text: tweet.text,
        author_id: tweet.author_id!,
        created_at: tweet.created_at!,
        public_metrics: tweet.public_metrics!,
        author: userMap.get(tweet.author_id!)
      })) || [];

      await cacheService.set(cacheKey, formattedTweets, 300); // 5 minutes cache
      return formattedTweets;
    } catch (error) {
      console.error('Twitter search error:', error);
      throw new Error('Failed to search tweets');
    }
  }

  async getTrendingTweets(count = 50): Promise<Tweet[]> {
    if (!this.client) {
      throw new Error('Twitter API not configured');
    }

    const cacheKey = cacheService.generateKey('twitter', 'trending_tweets');
    const cached = await cacheService.get(cacheKey);
    if (cached) return cached;

    try {
      // Get trending topics first
      const trends = await this.getTrendingTopics();
      const topTrends = trends.slice(0, 5); // Get top 5 trends

      const allTweets: Tweet[] = [];
      
      for (const trend of topTrends) {
        try {
          const tweets = await this.searchTweets(trend.query, Math.ceil(count / 5));
          allTweets.push(...tweets);
        } catch (error) {
          console.warn(`Failed to fetch tweets for trend: ${trend.name}`);
        }
      }

      // Sort by engagement (likes + retweets + replies)
      const sortedTweets = allTweets
        .sort((a, b) => {
          const aEngagement = a.public_metrics.like_count + 
                            a.public_metrics.retweet_count + 
                            a.public_metrics.reply_count;
          const bEngagement = b.public_metrics.like_count + 
                            b.public_metrics.retweet_count + 
                            b.public_metrics.reply_count;
          return bEngagement - aEngagement;
        })
        .slice(0, count);

      await cacheService.set(cacheKey, sortedTweets, 300); // 5 minutes cache
      return sortedTweets;
    } catch (error) {
      console.error('Twitter trending tweets error:', error);
      throw new Error('Failed to fetch trending tweets');
    }
  }

  async getAvailableLocations() {
    if (!this.client) {
      throw new Error('Twitter API not configured');
    }

    const cacheKey = cacheService.generateKey('twitter', 'locations');
    const cached = await cacheService.get(cacheKey);
    if (cached) return cached;

    try {
      const locations = await this.client.v1.trendsAvailable();
      await cacheService.set(cacheKey, locations, 3600); // 1 hour cache
      return locations;
    } catch (error) {
      console.error('Twitter locations error:', error);
      throw new Error('Failed to fetch available locations');
    }
  }
}

export default new TwitterService();