import 'package:flutter/material.dart';
import '../../../core/widgets/shimmer_card.dart';
import '../controller/world_controller.dart';
import '../model/world_trend.dart';
import 'widgets/world_trend_card.dart';

class WorldScreen extends StatefulWidget {
  const WorldScreen({super.key});

  @override
  State<WorldScreen> createState() => _WorldScreenState();
}

class _WorldScreenState extends State<WorldScreen> {
  final WorldController _controller = WorldController();
  late Future<List<WorldTrend>> _trendsFuture;

  @override
  void initState() {
    super.initState();
    _trendsFuture = _controller.getTop50WorldTrends();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Top 50 World Trends',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: FutureBuilder<List<WorldTrend>>(
        future: _trendsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              itemCount: 8,
              itemBuilder: (context, index) => const ShimmerCard(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading trends: \${snapshot.error}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            );
          }
          
          final trends = snapshot.data ?? [];
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            itemCount: trends.length,
            itemBuilder: (context, index) {
              return WorldTrendCard(trend: trends[index]);
            },
          );
        },
      ),
    );
  }
}