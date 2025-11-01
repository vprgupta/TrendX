import { google } from 'googleapis';
import cacheService from './cacheService';

interface YouTubeVideo {
  id: string;
  title: string;
  description: string;
  channelTitle: string;
  publishedAt: string;
  thumbnails: any;
  statistics: {
    viewCount: string;
    likeCount: string;
    commentCount: string;
  };
}

class YouTubeService {
  private youtube: any;

  constructor() {
    if (process.env.YOUTUBE_API_KEY) {
      this.youtube = google.youtube({
        version: 'v3',
        auth: process.env.YOUTUBE_API_KEY
      });
    }
  }

  async getTrendingVideos(regionCode = 'US', maxResults = 50): Promise<YouTubeVideo[]> {
    if (!this.youtube) {
      throw new Error('YouTube API not configured');
    }

    const cacheKey = cacheService.generateKey('youtube', 'trending', regionCode);
    const cached = await cacheService.get(cacheKey);
    if (cached) return cached;

    try {
      const response = await this.youtube.videos.list({
        part: ['snippet', 'statistics'],
        chart: 'mostPopular',
        regionCode,
        maxResults,
        videoCategoryId: '0'
      });

      const videos: YouTubeVideo[] = response.data.items.map((item: any) => ({
        id: item.id,
        title: item.snippet.title,
        description: item.snippet.description,
        channelTitle: item.snippet.channelTitle,
        publishedAt: item.snippet.publishedAt,
        thumbnails: item.snippet.thumbnails,
        statistics: {
          viewCount: item.statistics.viewCount || '0',
          likeCount: item.statistics.likeCount || '0',
          commentCount: item.statistics.commentCount || '0'
        }
      }));

      await cacheService.set(cacheKey, videos, 300); // 5 minutes cache
      return videos;
    } catch (error) {
      console.error('YouTube API error:', error);
      throw new Error('Failed to fetch YouTube trending videos');
    }
  }

  async searchVideos(query: string, maxResults = 25): Promise<YouTubeVideo[]> {
    if (!this.youtube) {
      throw new Error('YouTube API not configured');
    }

    const cacheKey = cacheService.generateKey('youtube', 'search', query);
    const cached = await cacheService.get(cacheKey);
    if (cached) return cached;

    try {
      const searchResponse = await this.youtube.search.list({
        part: ['snippet'],
        q: query,
        type: 'video',
        maxResults,
        order: 'relevance'
      });

      const videoIds = searchResponse.data.items.map((item: any) => item.id.videoId);
      
      const videosResponse = await this.youtube.videos.list({
        part: ['snippet', 'statistics'],
        id: videoIds.join(',')
      });

      const videos: YouTubeVideo[] = videosResponse.data.items.map((item: any) => ({
        id: item.id,
        title: item.snippet.title,
        description: item.snippet.description,
        channelTitle: item.snippet.channelTitle,
        publishedAt: item.snippet.publishedAt,
        thumbnails: item.snippet.thumbnails,
        statistics: {
          viewCount: item.statistics.viewCount || '0',
          likeCount: item.statistics.likeCount || '0',
          commentCount: item.statistics.commentCount || '0'
        }
      }));

      await cacheService.set(cacheKey, videos, 600); // 10 minutes cache
      return videos;
    } catch (error) {
      console.error('YouTube search error:', error);
      throw new Error('Failed to search YouTube videos');
    }
  }

  async getTrendingShorts(regionCode = 'US'): Promise<YouTubeVideo[]> {
    if (!this.youtube) {
      throw new Error('YouTube API not configured');
    }

    const cacheKey = cacheService.generateKey('youtube', 'shorts', regionCode);
    const cached = await cacheService.get(cacheKey);
    if (cached) return cached;

    try {
      const response = await this.youtube.search.list({
        part: ['snippet'],
        type: 'video',
        videoDuration: 'short',
        order: 'viewCount',
        publishedAfter: new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString(),
        maxResults: 25,
        regionCode
      });

      const videoIds = response.data.items.map((item: any) => item.id.videoId);
      
      const videosResponse = await this.youtube.videos.list({
        part: ['snippet', 'statistics', 'contentDetails'],
        id: videoIds.join(',')
      });

      const shorts: YouTubeVideo[] = videosResponse.data.items
        .filter((item: any) => {
          const duration = item.contentDetails.duration;
          return this.parseDuration(duration) <= 60; // 60 seconds or less
        })
        .map((item: any) => ({
          id: item.id,
          title: item.snippet.title,
          description: item.snippet.description,
          channelTitle: item.snippet.channelTitle,
          publishedAt: item.snippet.publishedAt,
          thumbnails: item.snippet.thumbnails,
          statistics: {
            viewCount: item.statistics.viewCount || '0',
            likeCount: item.statistics.likeCount || '0',
            commentCount: item.statistics.commentCount || '0'
          }
        }));

      await cacheService.set(cacheKey, shorts, 300); // 5 minutes cache
      return shorts;
    } catch (error) {
      console.error('YouTube Shorts error:', error);
      throw new Error('Failed to fetch YouTube Shorts');
    }
  }

  private parseDuration(duration: string): number {
    const match = duration.match(/PT(\d+H)?(\d+M)?(\d+S)?/);
    if (!match) return 0;
    
    const hours = parseInt(match[1]) || 0;
    const minutes = parseInt(match[2]) || 0;
    const seconds = parseInt(match[3]) || 0;
    
    return hours * 3600 + minutes * 60 + seconds;
  }
}

export default new YouTubeService();