import 'package:flutter/material.dart';
import '../models/news_item.dart';
import '../ui/section_header.dart';
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
        // Section Header
        SectionHeader(
          title: categoryName,
          icon: _getCategoryIcon(categoryName),
          color: _getCategoryColor(categoryName),
        ),
        // News Cards with ranking
        ...topNews.asMap().entries.map((entry) {
          final index = entry.key;
          final news = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: NewsCard(
              news: news,
              rank: index + 1, // Rank from 1 to 10
            ),
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
