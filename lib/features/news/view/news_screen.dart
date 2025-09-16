import 'package:flutter/material.dart';
import '../controller/news_controller.dart';
import '../model/news_article.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final _newsController = NewsController();

  @override
  void initState() {
    super.initState();
    _newsController.loadTrendingNews();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trending News'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _newsController.loadTrendingNews(),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _newsController,
        builder: (context, _) {
          if (_newsController.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_newsController.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: colorScheme.error),
                  const SizedBox(height: 16),
                  Text(_newsController.errorMessage!),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => _newsController.loadTrendingNews(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (_newsController.articles.isEmpty) {
            return const Center(child: Text('No news available'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _newsController.articles.length,
            itemBuilder: (context, index) {
              final article = _newsController.articles[index];
              return _buildNewsCard(article, colorScheme);
            },
          );
        },
      ),
    );
  }

  Widget _buildNewsCard(NewsArticle article, ColorScheme colorScheme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (article.urlToImage != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                article.urlToImage!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: colorScheme.surfaceVariant,
                  child: Icon(Icons.image_not_supported, color: colorScheme.onSurfaceVariant),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  article.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.source, size: 16, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      article.source,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatDate(article.publishedAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}