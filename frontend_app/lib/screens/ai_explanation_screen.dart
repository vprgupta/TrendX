import 'package:flutter/material.dart';
import '../services/ai_explainer_service.dart';
import 'package:url_launcher/url_launcher.dart';

class AIExplanationScreen extends StatefulWidget {
  final String title;
  final String content;
  final String platform;
  final String userAvatarUrl;
  final String userName;
  final String? sourceUrl;

  const AIExplanationScreen({
    super.key,
    required this.title,
    required this.content,
    required this.platform,
    required this.userAvatarUrl,
    required this.userName,
    this.sourceUrl,
  });

  @override
  State<AIExplanationScreen> createState() => _AIExplanationScreenState();
}

class _AIExplanationScreenState extends State<AIExplanationScreen>
    with TickerProviderStateMixin {
  final AIExplainerService _aiService = AIExplainerService();
  String? _fullExplanation;
  final Map<String, String> _explanationParts = {};
  final Map<String, String> _displayedParts = {};
  bool _isLoading = true;
  bool _isTyping = false;
  String _selectedLanguage = 'English';

  final List<String> _languages = ['English', 'Spanish', 'Hindi', 'French', 'German'];
  final List<String> _categories = ['WHO', 'WHAT', 'WHEN', 'WHERE', 'WHY', 'HOW'];

  @override
  void initState() {
    super.initState();
    _loadExplanation();
  }

  Future<void> _loadExplanation() async {
    setState(() {
      _isLoading = true;
    });

    final explanation = await _aiService.explainTrend(
      widget.title,
      widget.content,
      widget.platform,
      _selectedLanguage,
    );

    setState(() {
      _fullExplanation = explanation;
      _parseExplanation(explanation);
      _isLoading = false;
    });

    // Start typing animation
    _startTypingAnimation();
  }

  void _parseExplanation(String explanation) {
    print('Full AI Response: $explanation'); // Debug output
    
    for (String category in _categories) {
      final regex = RegExp('$category:\\s*(.+?)(?=\\n(?:WHO|WHAT|WHEN|WHERE|WHY|HOW):|\$)', multiLine: true, dotAll: true);
      final match = regex.firstMatch(explanation);
      if (match != null) {
        String content = match.group(1)?.trim() ?? 'No information available';
        // Remove any trailing newlines or extra whitespace
        content = content.replaceAll(RegExp(r'\n+'), ' ').trim();
        _explanationParts[category] = content;
        print('Parsed $category: $content'); // Debug output
      } else {
        _explanationParts[category] = 'Could not parse $category from AI response';
        print('Failed to parse $category from response'); // Debug output
      }
      _displayedParts[category] = '';
    }
  }

  void _startTypingAnimation() async {
    if (_explanationParts.isEmpty) return;
    
    setState(() {
      _isTyping = true;
    });

    for (String category in _categories) {
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() {
        _displayedParts[category] = _explanationParts[category] ?? '';
      });
    }
    
    setState(() {
      _isTyping = false;
    });
  }

  Widget _buildAnalysisContainer(String category) {
    final colorScheme = Theme.of(context).colorScheme;
    
    final colors = {
      'WHO': const Color(0xFF6366F1),
      'WHAT': const Color(0xFF8B5CF6),
      'WHEN': const Color(0xFF06B6D4),
      'WHERE': const Color(0xFF10B981),
      'WHY': const Color(0xFFF59E0B),
      'HOW': const Color(0xFFEF4444),
    };

    final icons = {
      'WHO': Icons.person_outline,
      'WHAT': Icons.info_outline,
      'WHEN': Icons.schedule_outlined,
      'WHERE': Icons.location_on_outlined,
      'WHY': Icons.help_outline,
      'HOW': Icons.settings_outlined,
    };

    final accentColor = colors[category]!;
    final hasContent = _displayedParts[category]?.isNotEmpty == true;

    return AnimatedOpacity(
      opacity: hasContent ? 1.0 : 0.3,
      duration: const Duration(milliseconds: 300),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: accentColor.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icons[category],
                      color: accentColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    category,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: accentColor,
                    ),
                  ),
                  const Spacer(),
                  if (_isTyping && !hasContent)
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                      ),
                    ),
                ],
              ),
              if (hasContent) ...[
                const SizedBox(height: 16),
                AnimatedOpacity(
                  opacity: hasContent ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    _displayedParts[category] ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Explanation'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (language) {
              setState(() {
                _selectedLanguage = language;
              });
              _loadExplanation();
            },
            itemBuilder: (context) => _languages.map((lang) {
              return PopupMenuItem(
                value: lang,
                child: Text(lang),
              );
            }).toList(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Original Post Card
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(
                minHeight: 160,
                maxHeight: 200,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(widget.userAvatarUrl),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.userName,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  widget.platform,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        widget.content,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // AI Explanation Section
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.psychology_outlined,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'AI Analysis',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (_isLoading)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Generating 5W+1H analysis...'),
                  ],
                ),
              )
            else
              Column(
                children: _categories.map((category) => _buildAnalysisContainer(category)).toList(),
              ),
            
            if (widget.sourceUrl != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () async {
                    final Uri url = Uri.parse(widget.sourceUrl!);
                    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Could not launch ${widget.sourceUrl}')),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Read Full Article'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}