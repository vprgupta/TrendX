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
  late Future<List<NewsItem>> _newsFuture;

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
    _newsFuture = _newsService.getNews('world');
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
    // Show empty state if no categories selected
    if (_prefsService.selectedWorldCategories.isEmpty) {
      return EmptyStateWidget(
        title: 'No Topics Selected',
        message: 'Please select world topics in the settings to see global news.',
        icon: Icons.language,
        actionLabel: 'Select Topics',
        onAction: () {
          // TODO: Navigate to settings
        },
      );
    }

    // Single FutureBuilder that wraps the entire content
    return FutureBuilder<List<NewsItem>>(
      future: _newsFuture,
      builder: (context, snapshot) {
        // Show loading shimmer
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: List.generate(3, (index) => const ShimmerCard()),
          );
        }

        // Show error message
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading world news',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () {
                    setState(() {
                      _newsFuture = _newsService.getNews('world');
                    });
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Show news feeds for each category
        final allNews = snapshot.data ?? [];
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _prefsService.selectedWorldCategories.length,
          itemBuilder: (context, index) {
            final category = _prefsService.selectedWorldCategories.elementAt(index);
            final icon = _categoryIcons[category] ?? '🌐';
            final displayName = '$icon $category';
            
            // Filter news by category (you may want to implement proper filtering based on category)
            // For now, showing all world news for each category
            
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