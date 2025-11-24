import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_item.dart';

class NewsService {
  // For Android emulator use: 'http://10.0.2.2:3000/api'
  // For iOS simulator and web use: 'http://localhost:3000/api'
  // For physical device use your computer's IP address
  static const String baseUrl = 'http://10.22.31.214:3000/api';

  Future<List<NewsItem>> getNews(String category, {String country = 'US'}) async {
    // Simulate network delay for realistic feel
    await Future.delayed(const Duration(milliseconds: 800));
    return _generateDummyNews(category, country);
  }

  Future<List<NewsItem>> getTopNews({String country = 'US'}) async {
    return getNews('top', country: country);
  }

  List<NewsItem> _generateDummyNews(String category, String country) {
    final List<NewsItem> items = [];
    final int count = category.toLowerCase().contains('world') ? 50 : 20;

    for (int i = 0; i < count; i++) {
      items.add(NewsItem(
        title: _getDummyTitle(category, i),
        link: 'https://example.com',
        pubDate: DateTime.now().subtract(Duration(hours: i * 2)).toIso8601String(),
        content: 'This is a detailed dummy content for the news item. It contains enough text to demonstrate the UI layout and typography settings of the application.',
        contentSnippet: 'Brief summary of the news item goes here. It highlights the key points of the story...',
        source: _getDummySource(i),
        imageUrl: _getDummyImage(category, i),
        author: _getDummyAuthor(i),
        authorAvatarUrl: _getDummyAvatar(i),
        likes: (1000 + i * 500) % 50000,
        comments: (100 + i * 50) % 5000,
        shares: (50 + i * 20) % 2000,
        rank: i + 1,
      ));
    }
    return items;
  }

  String _getDummyTitle(String category, int index) {
    final titles = [
      'Revolutionary AI Model Breaks New Ground in Natural Language Processing',
      'Global Markets Rally as Tech Stocks Hit All-Time Highs',
      'New Sustainable Energy Solution Promises to Solve Power Crisis',
      'SpaceX Successfully Launches Next-Gen Starship Mission',
      'Major Breakthrough in Quantum Computing Announced by Researchers',
      'Electric Vehicle Sales Surpass Traditional Cars in Key Markets',
      'World Leaders Gather for Emergency Climate Summit',
      'New Smart City Project Unveiled in Developing Nation',
      'Medical Researchers Discover Potential Cure for Rare Disease',
      'Tech Giant Releases Revolutionary AR Glasses to Public',
      'Global Internet Speeds Double Thanks to New Fiber Tech',
      'Mars Colony Project Enters Final Planning Stages',
      'Artificial Intelligence Writes Best-Selling Novel',
      'Crypto Market Sees Unprecedented Growth Amidst Regulation',
      'Self-Driving Cars Now Legal in Major European Cities',
      'Virtual Reality Tourism Becomes the New Normal',
      'Ocean Cleanup Project Removes Record Amount of Plastic',
      'New Battery Tech Triples Smartphone Battery Life',
      'Flying Taxis to Launch in Dubai Next Month',
      'Universal Translator Device Breaks Language Barriers',
    ];
    return titles[index % titles.length];
  }

  String _getDummySource(int index) {
    final sources = ['TechCrunch', 'The Verge', 'BBC News', 'CNN', 'Reuters', 'Bloomberg', 'Wired', 'Mashable'];
    return sources[index % sources.length];
  }

  String _getDummyAuthor(int index) {
    final authors = ['Sarah Connor', 'John Doe', 'Jane Smith', 'Mike Ross', 'Rachel Green', 'Tony Stark', 'Bruce Wayne', 'Clark Kent'];
    return authors[index % authors.length];
  }

  String _getDummyAvatar(int index) {
    return 'https://i.pravatar.cc/150?img=${index % 70}';
  }

  String _getDummyImage(String category, int index) {
    // Using picsum for reliable random images
    return 'https://picsum.photos/seed/${category}_$index/800/600';
  }
}
