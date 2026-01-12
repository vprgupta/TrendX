import 'package:flutter/material.dart';
import '../../../core/widgets/shimmer_card.dart';
import '../../../core/widgets/news_feed.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/models/news_item.dart';
import '../../../core/services/news_service.dart';
import '../../../core/services/preferences_service.dart';

class TechnologyScreen extends StatefulWidget {
  const TechnologyScreen({super.key});

  @override
  State<TechnologyScreen> createState() => _TechnologyScreenState();
}

class _TechnologyScreenState extends State<TechnologyScreen> {
  final NewsService _newsService = NewsService();
  final PreferencesService _prefsService = PreferencesService();

  final Map<String, String> _categoryIcons = {
    'AI': '🤖',
    'Mobile': '📱',
    'Web': '🌐',
    'Blockchain': '⛓️',
    'IoT': '📡',
    'Robotics': '🦾',
    'Cloud': '☁️',
    'Cybersecurity': '🔒',
  };

  @override
  void initState() {
    super.initState();
    _prefsService.addListener(_onPreferencesChanged);
    _prefsService.loadFromBackend();
  }

  @override
  void dispose() {
    _prefsService.removeListener(_onPreferencesChanged);
    super.dispose();
  }

  void _onPreferencesChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _prefsService.selectedTechCategories.isEmpty
          ? EmptyStateWidget(
              title: 'No Categories Selected',
              message: 'Please select technology categories in the settings to see relevant news.',
              icon: Icons.category_outlined,
              actionLabel: 'Customize Feed',
              onAction: () {
                // TODO: Navigate to settings or show preference dialog
              },
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
              itemCount: _prefsService.selectedTechCategories.length,
              itemBuilder: (context, index) {
                final category = _prefsService.selectedTechCategories.elementAt(index);
                final icon = _categoryIcons[category] ?? '💻';
                final displayName = '$icon $category';
                
                return FutureBuilder<List<NewsItem>>(
                  future: _newsService.getNews('technology'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        children: List.generate(3, (index) => const ShimmerCard()),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                        ),
                      );
                    }
                    
                    // Show all tech news for each selected category
                    final allNews = snapshot.data ?? [];
                    
                    return NewsFeed(
                      categoryName: displayName,
                      newsItems: allNews,
                    );
                  },
                );
              },
            );
  }
}