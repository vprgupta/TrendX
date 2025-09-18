import 'dart:convert';
import 'package:http/http.dart' as http;
import '../secrets.dart';

class AIExplainerService {
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';

  Future<String> explainTrend(String title, String content, String platform, [String language = 'English']) async {
    print('Analyzing: Title="$title", Content="$content", Platform="$platform"'); // Debug
    
    // Try free Gemini API first
    try {
      final result = await _explainWithGemini(title, content, platform, language);
      print('Gemini API Success: ${result.substring(0, result.length > 100 ? 100 : result.length)}...'); // Debug
      return result;
    } catch (e) {
      print('Gemini API failed, trying OpenAI: $e');
      // Fallback to OpenAI if available
      try {
        final result = await _explainWithOpenAI(title, content, platform, language);
        print('OpenAI API Success: ${result.substring(0, result.length > 100 ? 100 : result.length)}...'); // Debug
        return result;
      } catch (e2) {
        print('OpenAI API failed, using fallback: $e2');
        return _getFallbackExplanation(title, content, platform, language);
      }
    }
  }

  Future<String> _explainWithGemini(String title, String content, String platform, String language) async {
    final response = await http.post(
      Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=${Secrets.geminiApiKey}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'contents': [{
          'parts': [{
            'text': 'Analyze this $platform post using 5W+1H principle in $language language. Provide detailed explanations (2-3 sentences each). Format each point on new line:\n\nWHO: [who is involved - be specific about creators, influencers, or communities]\nWHAT: [what happened - describe the content and its significance]\nWHEN: [when it occurred - timing and context]\nWHERE: [where it\'s happening - platform, geographic reach]\nWHY: [why it\'s trending - detailed reasons for popularity]\nHOW: [how it\'s spreading - mechanisms of viral growth]\n\nTitle: "$title" Content: "$content"'
          }]
        }],
        'generationConfig': {
          'maxOutputTokens': 1000,
          'temperature': 0.7
        }
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['candidates'] != null && data['candidates'].isNotEmpty) {
        return data['candidates'][0]['content']['parts'][0]['text'].trim();
      } else {
        throw Exception('No response from Gemini');
      }
    } else {
      print('Gemini API Response: ${response.body}');
      throw Exception('Gemini API Error: ${response.statusCode}');
    }
  }

  Future<String> _explainWithOpenAI(String title, String content, String platform, String language) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Bearer ${Secrets.openAIApiKey}',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {
            'role': 'system',
            'content': 'You are a helpful assistant that explains trending social media content in simple terms. Explain why this content is trending, its context, and significance. Respond in $language language.'
          },
          {
            'role': 'user',
            'content': 'Analyze this trending $platform post using 5W+1H principle. Provide detailed explanations (2-3 sentences each). Format each point on new line:\n\nWHO: [who is involved - be specific about creators, influencers, or communities]\nWHAT: [what happened - describe the content and its significance]\nWHEN: [when it occurred - timing and context]\nWHERE: [where it\'s happening - platform, geographic reach]\nWHY: [why it\'s trending - detailed reasons for popularity]\nHOW: [how it\'s spreading - mechanisms of viral growth]\n\nTitle: "$title" Content: "$content"'
          }
        ],
        'max_tokens': 800,
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['choices'][0]['message']['content'].trim();
    } else {
      throw Exception('OpenAI API Error: ${response.statusCode}');
    }
  }

  String _getFallbackExplanation(String title, String content, String platform, String language) {
    // Create dynamic explanation based on actual content
    final contentPreview = content.length > 50 ? '${content.substring(0, 50)}...' : content;
    
    return 'WHO: Content creators and users on $platform sharing trending material\n'
           'WHAT: "$title" - $contentPreview This content has gained significant attention and engagement\n'
           'WHEN: Recently posted and currently trending across the platform\n'
           'WHERE: $platform platform with global reach and audience engagement\n'
           'WHY: The content resonates with users due to its relevance, entertainment value, or informational content that meets current interests\n'
           'HOW: Spreading through platform algorithms, user shares, likes, comments, and organic viral mechanisms';
  }

  String _detectLanguage() {
    // Simple language detection based on system locale
    // In a real app, you'd use proper language detection
    return 'English';
  }
}