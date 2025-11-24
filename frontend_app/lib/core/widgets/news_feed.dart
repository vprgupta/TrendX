import 'package:flutter/material.dart';
import '../models/news_item.dart';
import 'news_card.dart';

class NewsFeed extends StatelessWidget {
  final String categoryName;
  final List<NewsItem> newsItems;

  const NewsFeed({
    super.key,
    required this.categoryName,
    required this.newsItems,
  });

  @override
  Widget build(BuildContext context) {
    // Show top 50 for World, top 10 for others
    final limit = categoryName.toLowerCase().contains('world') ? 50 : 10;
    final topNews = newsItems.take(limit).toList();

    return Column(
      children: [
        // Gradient Header (matching Platform style)
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _getCategoryColor(categoryName).withValues(alpha: 0.8),
                _getCategoryColor(categoryName).withValues(alpha: 0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _getCategoryColor(categoryName).withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  _getCategoryIcon(categoryName),
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                categoryName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          offset: const Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
              ),
            ],
          ),
        ),
        // News Cards with ranking
        ...topNews.asMap().entries.map((entry) {
          final index = entry.key;
          final news = entry.value;
          return NewsCard(
            news: news,
            rank: index + 1, // Rank from 1 to 10
          );
        }),
        const SizedBox(height: 8),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'world news':
      case 'world':
        return Colors.blue;
      case 'technology news':
      case 'technology':
        return Colors.deepPurple;
      case 'country news':
      case 'country':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'world news':
      case 'world':
        return Icons.public;
      case 'technology news':
      case 'technology':
        return Icons.computer;
      case 'country news':
      case 'country':
        return Icons.flag;
      default:
        return Icons.newspaper;
    }
  }
}
