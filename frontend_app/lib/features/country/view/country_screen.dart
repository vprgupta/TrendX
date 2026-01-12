import 'package:flutter/material.dart';
import '../../../core/widgets/shimmer_card.dart';
import '../../../core/widgets/news_feed.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/models/news_item.dart';
import '../../../core/services/news_service.dart';
import '../../../core/services/preferences_service.dart';
import '../../../core/ui/neon_text.dart';
import '../../../core/ui/glass_container.dart';

class CountryScreen extends StatefulWidget {
  const CountryScreen({super.key});

  @override
  State<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  final NewsService _newsService = NewsService();
  final PreferencesService _prefsService = PreferencesService();

  final Map<String, String> _countryCodeMap = {
    'USA': 'US',
    'India': 'IN',
    'UK': 'UK',
    'Japan': 'JP',
    'Germany': 'DE',
    'France': 'FR',
    'Brazil': 'BR',
    'Canada': 'CA',
  };

  final Map<String, String> _countryFlags = {
    'USA': '🇺🇸',
    'India': '🇮🇳',
    'UK': '🇬🇧',
    'Japan': '🇯🇵',
    'Germany': '🇩🇪',
    'France': '🇫🇷',
    'Brazil': '🇧🇷',
    'Canada': '🇨🇦',
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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Country News',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
      body: _prefsService.selectedCountries.isEmpty
          ? EmptyStateWidget(
              title: 'No Countries Selected',
              message: 'Please select countries in the settings to see local news.',
              icon: Icons.public,
              actionLabel: 'Select Countries',
              onAction: () {
                // TODO: Navigate to settings
              },
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
              itemCount: _prefsService.selectedCountries.length,
              itemBuilder: (context, index) {
                final country = _prefsService.selectedCountries.elementAt(index);
                final countryCode = _countryCodeMap[country] ?? 'US';
                final flag = _countryFlags[country] ?? '🏳️';
                final displayName = '$flag $country';
                
                return FutureBuilder<List<NewsItem>>(
                  future: _newsService.getNews('country', country: countryCode),
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
                    return NewsFeed(
                      categoryName: displayName,
                      newsItems: snapshot.data ?? [],
                    );
                  },
                );
              },
            ),
    );
  }
}