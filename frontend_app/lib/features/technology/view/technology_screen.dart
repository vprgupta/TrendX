import 'package:flutter/material.dart';
import '../../../core/widgets/shimmer_card.dart';
import '../../../core/services/preferences_service.dart';
import '../controller/technology_controller.dart';
import '../model/technology.dart';
import 'widgets/tech_trend_card.dart';

class TechnologyScreen extends StatefulWidget {
  const TechnologyScreen({super.key});

  @override
  State<TechnologyScreen> createState() => _TechnologyScreenState();
}

class _TechnologyScreenState extends State<TechnologyScreen> {
  final TechnologyController _controller = TechnologyController();
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
          'Technology Trends',
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
        itemCount: _prefsService.selectedTechCategories.length,
        itemBuilder: (context, index) {
          final category = _prefsService.selectedTechCategories.elementAt(index);
          return Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  category,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              FutureBuilder<List<TechTrend>>(
                future: _controller.getTechTrends(category),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      children: List.generate(2, (index) => const ShimmerCard(hasImage: false)),
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
                        .map((trend) => TechTrendCard(trend: trend))
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
}