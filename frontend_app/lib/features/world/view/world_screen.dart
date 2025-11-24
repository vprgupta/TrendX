import 'package:flutter/material.dart';
import '../../../core/widgets/shimmer_card.dart';
import '../../../core/widgets/news_feed.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/models/news_item.dart';
import '../../../core/services/news_service.dart';
import '../../../core/services/preferences_service.dart';

class WorldScreen extends StatefulWidget {
  const WorldScreen({super.key});

  @override
  State<WorldScreen> createState() => _WorldScreenState();
}

class _WorldScreenState extends State<WorldScreen> {
  final NewsService _newsService = NewsService();
  final PreferencesService _prefsService = PreferencesService();

  final Map<String, String> _categoryIcons = {
    'Science': '🔬',
    'Agriculture': '🌾',
    'Space': '🚀',
    'Art': '🎨',
    'Environment': '🌍',
    'Health': '⚕️',
    'Politics': '🏛️',
    'Sports': '⚽',
    'Entertainment': '🎬',
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
    return _prefsService.selectedWorldCategories.isEmpty
          ? EmptyStateWidget(
              title: 'No Topics Selected',
              message: 'Please select world topics in the settings to see global news.',
              icon: Icons.language,
              actionLabel: 'Select Topics',
              onAction: () {
                // TODO: Navigate to settings
              },
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _prefsService.selectedWorldCategories.length,
              itemBuilder: (context, index) {
                final category = _prefsService.selectedWorldCategories.elementAt(index);
                final icon = _categoryIcons[category] ?? '🌐';
                final displayName = '$icon $category';
                
                return FutureBuilder<List<NewsItem>>(
                  future: _newsService.getNews('world'),
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
                    
                    // Show all world news for each selected category
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