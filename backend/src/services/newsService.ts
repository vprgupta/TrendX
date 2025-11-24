import Parser from 'rss-parser';

const parser = new Parser();

export interface NewsItem {
    title: string;
    link: string;
    pubDate: string;
    content: string;
    contentSnippet: string;
    source: string;
    imageUrl?: string;
}

export const getNews = async (category: string = 'world', country: string = 'US'): Promise<NewsItem[]> => {
    let feedUrl = '';

    // Country-specific news feeds
    if (category.toLowerCase() === 'country') {
        const countryFeeds: Record<string, string> = {
            'US': 'https://news.google.com/rss?hl=en-US&gl=US&ceid=US:en',
            'IN': 'https://news.google.com/rss?hl=en-IN&gl=IN&ceid=IN:en',
            'UK': 'https://news.google.com/rss?hl=en-GB&gl=GB&ceid=GB:en',
            'CA': 'https://news.google.com/rss?hl=en-CA&gl=CA&ceid=CA:en',
            'AU': 'https://news.google.com/rss?hl=en-AU&gl=AU&ceid=AU:en',
        };
        feedUrl = countryFeeds[country.toUpperCase()] || countryFeeds['US'];
    } else if (category.toLowerCase() === 'technology') {
        feedUrl = 'https://news.google.com/rss/headlines/section/topic/TECHNOLOGY?hl=en-US&gl=US&ceid=US:en';
    } else {
        // World news
        feedUrl = 'https://news.google.com/rss/headlines/section/topic/WORLD?hl=en-US&gl=US&ceid=US:en';
    }

    try {
        const feed = await parser.parseURL(feedUrl);

        return feed.items.map(item => {
            // Extract image URL from content HTML
            let imageUrl: string | undefined;
            if (item.content) {
                const imgMatch = item.content.match(/<img[^>]+src="([^">]+)"/);
                if (imgMatch && imgMatch[1]) {
                    imageUrl = imgMatch[1];
                }
            }

            // If no image found in content, try enclosure
            if (!imageUrl && (item as any).enclosure && (item as any).enclosure.url) {
                imageUrl = (item as any).enclosure.url;
            }

            return {
                title: item.title || 'No title',
                link: item.link || '#',
                pubDate: item.pubDate || new Date().toISOString(),
                content: item.content || '',
                contentSnippet: item.contentSnippet || '',
                source: item.creator || item.author || 'Google News',
                imageUrl: imageUrl
            };
        });
    } catch (error) {
        console.error('Error fetching news feed:', error);
        return [];
    }
};
