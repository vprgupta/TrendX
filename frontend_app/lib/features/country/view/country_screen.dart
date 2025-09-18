import 'package:flutter/material.dart';
import '../../../core/widgets/shimmer_card.dart';
import '../../../core/services/preferences_service.dart';
import '../controller/country_controller.dart';
import '../model/country.dart';
import 'widgets/country_trend_card.dart';

class CountryScreen extends StatefulWidget {
  const CountryScreen({super.key});

  @override
  State<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  final CountryController _controller = CountryController();
  final PreferencesService _prefsService = PreferencesService();

  @override
  void initState() {
    super.initState();
    _prefsService.addListener(_onPreferencesChanged);
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
          'Country Trends',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 8),
        itemCount: _prefsService.selectedCountries.length,
        itemBuilder: (context, index) {
          final country = _prefsService.selectedCountries.elementAt(index);
          return Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getCountryColor(country).withOpacity(0.8),
                      _getCountryColor(country).withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: _getCountryColor(country).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _getCountryFlag(country),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      country,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<CountryTrend>>(
                future: _controller.getCountryTrends(country),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      children: List.generate(2, (index) => const ShimmerCard()),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: \${snapshot.error}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: (snapshot.data ?? [])
                        .map((trend) => CountryTrendCard(trend: trend))
                        .toList(),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Color _getCountryColor(String country) {
    switch (country.toLowerCase()) {
      case 'usa':
        return Colors.blue;
      case 'india':
        return Colors.orange;
      case 'uk':
        return Colors.red;
      case 'japan':
        return Colors.pink;
      default:
        return Colors.purple;
    }
  }

  String _getCountryFlag(String country) {
    switch (country.toLowerCase()) {
      case 'usa':
        return '🇺🇸';
      case 'india':
        return '🇮🇳';
      case 'uk':
        return '🇬🇧';
      case 'japan':
        return '🇯🇵';
      default:
        return '🌍';
    }
  }
}