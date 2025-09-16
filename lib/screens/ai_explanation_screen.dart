import 'package:flutter/material.dart';
import '../services/ai_explainer_service.dart';

class AIExplanationScreen extends StatefulWidget {
  final String title;
  final String content;
  final String platform;
  final String userAvatarUrl;
  final String userName;

  const AIExplanationScreen({
    Key? key,
    required this.title,
    required this.content,
    required this.platform,
    required this.userAvatarUrl,
    required this.userName,
  }) : super(key: key);

  @override
  State<AIExplanationScreen> createState() => _AIExplanationScreenState();
}

class _AIExplanationScreenState extends State<AIExplanationScreen>
    with TickerProviderStateMixin {
  final AIExplainerService _aiService = AIExplainerService();
  String? _fullExplanation;
  Map<String, String> _explanationParts = {};
  Map<String, String> _displayedParts = {};
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
      final text = _explanationParts[category] ?? '';
      final words = text.split(' ');
      
      for (int i = 0; i < words.length; i++) {
        await Future.delayed(const Duration(milliseconds: 100));
        setState(() {
          _displayedParts[category] = words.sublist(0, i + 1).join(' ');
        });
      }
      
      await Future.delayed(const Duration(milliseconds: 300));
    }
    
    setState(() {
      _isTyping = false;
    });
  }

  Widget _buildAnalysisContainer(String category) {
    final colors = {
      'WHO': const Color(0xFF667eea),
      'WHAT': const Color(0xFF764ba2),
      'WHEN': const Color(0xFF4facfe),
      'WHERE': const Color(0xFF00f2fe),
      'WHY': const Color(0xFFa8edea),
      'HOW': const Color(0xFFfed6e3),
    };

    final icons = {
      'WHO': Icons.person,
      'WHAT': Icons.info,
      'WHEN': Icons.schedule,
      'WHERE': Icons.location_on,
      'WHY': Icons.help,
      'HOW': Icons.settings,
    };

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors[category]!,
            colors[category]!.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colors[category]!.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icons[category],
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                category,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              if (_isTyping && _displayedParts[category]?.isNotEmpty == true)
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _displayedParts[category] ?? '',
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
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
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(widget.userAvatarUrl),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.userName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                widget.platform,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
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
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.content,
                      style: const TextStyle(fontSize: 14),
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
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.psychology,
                    color: Colors.blue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'AI Explanation',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
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
            

          ],
        ),
      ),
    );
  }
}