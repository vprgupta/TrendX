import 'package:flutter/material.dart';
import '../../model/platform.dart';
import 'trend_card.dart';

class PlatformFeed extends StatelessWidget {
  final String platformName;
  final List<PlatformTrend> trends;

  const PlatformFeed({
    Key? key,
    required this.platformName,
    required this.trends,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _getPlatformColor(platformName).withOpacity(0.8),
                _getPlatformColor(platformName).withOpacity(0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _getPlatformColor(platformName).withOpacity(0.3),
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
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  _getPlatformIcon(platformName),
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                platformName,
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
        ...trends.map((trend) => TrendCard(trend: trend)).toList(),
        const SizedBox(height: 8),
      ],
    );
  }

  Color _getPlatformColor(String platform) {
    switch (platform.toLowerCase()) {
      case 'instagram':
        return Colors.purple;
      case 'facebook':
        return Colors.blue;
      case 'twitter':
        return Colors.lightBlue;
      case 'youtube':
        return Colors.red;
      case 'tiktok':
        return Colors.black;
      case 'linkedin':
        return Colors.indigo;
      case 'reddit':
        return Colors.orange;
      case 'snapchat':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  IconData _getPlatformIcon(String platform) {
    switch (platform.toLowerCase()) {
      case 'instagram':
        return Icons.camera_alt;
      case 'facebook':
        return Icons.facebook;
      case 'twitter':
        return Icons.alternate_email;
      case 'youtube':
        return Icons.play_circle;
      case 'tiktok':
        return Icons.music_note;
      case 'linkedin':
        return Icons.business;
      case 'reddit':
        return Icons.forum;
      case 'snapchat':
        return Icons.camera;
      default:
        return Icons.public;
    }
  }
}