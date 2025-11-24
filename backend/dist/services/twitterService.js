"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getTwitterPosts = exports.getTwitterTrends = void 0;
const scraperUtils_1 = require("./scraperUtils");
// Minimal Twitter service implementation
const getTwitterTrends = async (country) => {
    try {
        const $ = await (0, scraperUtils_1.fetchHtml)('https://trendogate.com/');
        if (!$)
            return [];
        const trends = [];
        const seen = new Set();
        // Selectors based on Trendogate structure (adjust as needed based on actual HTML)
        $('.list-group-item').each((i, el) => {
            if (trends.length >= 10)
                return;
            const name = (0, scraperUtils_1.cleanText)($(el).find('a').text());
            const volumeText = (0, scraperUtils_1.cleanText)($(el).find('.badge').text());
            // Basic validation
            if (name && name.length > 1 && !seen.has(name)) {
                seen.add(name);
                trends.push({
                    name,
                    tweet_volume: parseInt(volumeText.replace(/,/g, '')) || 0,
                    url: $(el).find('a').attr('href')
                });
            }
        });
        return trends;
    }
    catch (error) {
        console.error('Error scraping Twitter trends:', error);
        return [];
    }
};
exports.getTwitterTrends = getTwitterTrends;
const getTwitterPosts = async (query) => {
    // Twitter scraping is hard without API, returning mock for posts
    return [];
};
exports.getTwitterPosts = getTwitterPosts;
