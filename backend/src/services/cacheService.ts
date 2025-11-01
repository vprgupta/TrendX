import { createClient, RedisClientType } from 'redis';
import NodeCache from 'node-cache';

class CacheService {
  private redisClient: RedisClientType | null = null;
  private nodeCache: NodeCache;
  private isRedisConnected = false;

  constructor() {
    this.nodeCache = new NodeCache({ 
      stdTTL: parseInt(process.env.CACHE_TTL || '300'),
      maxKeys: parseInt(process.env.CACHE_MAX_SIZE || '1000')
    });
    this.initRedis();
  }

  private async initRedis() {
    try {
      if (process.env.REDIS_URL) {
        this.redisClient = createClient({ url: process.env.REDIS_URL });
        
        this.redisClient.on('error', (err) => {
          console.error('Redis Client Error:', err);
          this.isRedisConnected = false;
        });

        this.redisClient.on('connect', () => {
          console.log('✅ Redis connected');
          this.isRedisConnected = true;
        });

        await this.redisClient.connect();
      }
    } catch (error) {
      console.warn('⚠️ Redis connection failed, using in-memory cache:', error);
      this.isRedisConnected = false;
    }
  }

  async get(key: string): Promise<any> {
    try {
      if (this.isRedisConnected && this.redisClient) {
        const value = await this.redisClient.get(key);
        return value ? JSON.parse(value) : null;
      }
      return this.nodeCache.get(key) || null;
    } catch (error) {
      console.error('Cache get error:', error);
      return null;
    }
  }

  async set(key: string, value: any, ttl?: number): Promise<void> {
    try {
      if (this.isRedisConnected && this.redisClient) {
        const serialized = JSON.stringify(value);
        if (ttl) {
          await this.redisClient.setEx(key, ttl, serialized);
        } else {
          await this.redisClient.set(key, serialized);
        }
      } else {
        this.nodeCache.set(key, value, ttl || 0);
      }
    } catch (error) {
      console.error('Cache set error:', error);
    }
  }

  async del(key: string): Promise<void> {
    try {
      if (this.isRedisConnected && this.redisClient) {
        await this.redisClient.del(key);
      } else {
        this.nodeCache.del(key);
      }
    } catch (error) {
      console.error('Cache delete error:', error);
    }
  }

  generateKey(prefix: string, ...parts: string[]): string {
    return `${prefix}:${parts.join(':')}`;
  }
}

export default new CacheService();