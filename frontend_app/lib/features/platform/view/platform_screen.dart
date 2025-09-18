import 'package:flutter/material.dart';
import '../../../core/widgets/shimmer_card.dart';
import '../../../core/services/preferences_service.dart';
import '../controller/platform_controller.dart';
import '../model/platform.dart';
import 'widgets/platform_feed.dart';
import '../../../screens/trending_shorts_screen.dart';

class PlatformScreen extends StatefulWidget {
  const PlatformScreen({super.key});

  @override
  State<PlatformScreen> createState() => _PlatformScreenState();
}

class _PlatformScreenState extends State<PlatformScreen> {
  final PlatformController _controller = PlatformController();
  final PreferencesService _prefsService = PreferencesService();

  final Map<String, String> _countries = {
    'Worldwide': '🌍 Worldwide',
    'US': '🇺🇸 United States',
    'IN': '🇮🇳 India',
    'PK': '🇵🇰 Pakistan',
    'BD': '🇧🇩 Bangladesh',
    'LK': '🇱🇰 Sri Lanka',
    'NP': '🇳🇵 Nepal',
    'BT': '🇧🇹 Bhutan',
    'MV': '🇲🇻 Maldives',
    'AF': '🇦🇫 Afghanistan',
    'GB': '🇬🇧 United Kingdom',
    'CA': '🇨🇦 Canada',
    'AU': '🇦🇺 Australia',
    'DE': '🇩🇪 Germany',
    'FR': '🇫🇷 France',
    'JP': '🇯🇵 Japan',
    'KR': '🇰🇷 South Korea',
    'BR': '🇧🇷 Brazil',
  };

  @override
  void initState() {
    super.initState();
    _prefsService.addListener(_onPreferencesChanged);
    _prefsService.loadCountryFilter();
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Trending Platforms',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,

        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              _prefsService.updateCountryFilter(value);
            },
            itemBuilder: (context) => _countries.entries.map((entry) {
              return PopupMenuItem(
                value: entry.key,
                child: Text(entry.value),
              );
            }).toList(),
          ),
        ],
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: _buildShortsCard(),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8),
              itemCount: _prefsService.selectedPlatforms.length,
              itemBuilder: (context, index) {
                final platform = _prefsService.selectedPlatforms.elementAt(index);
                final countryCode = _prefsService.selectedCountryFilter == 'Worldwide' ? 'US' : _prefsService.selectedCountryFilter;
                return FutureBuilder<List<PlatformTrend>>(
                  future: _controller.getPlatformTrends(platform, countryCode),
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
                    return PlatformFeed(
                      platformName: platform,
                      trends: snapshot.data ?? [],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShortsCard() {
    return Container(
      margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
      width: 200,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TrendingShortsScreen(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6B6B).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Shorts',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}