import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService extends ChangeNotifier {
  static final PreferencesService _instance = PreferencesService._internal();
  factory PreferencesService() => _instance;
  PreferencesService._internal();

  final Set<String> _selectedPlatforms = {'Instagram', 'Facebook', 'Twitter', 'TikTok', 'YouTube'};
  Set<String> get selectedPlatforms => _selectedPlatforms;

  final Set<String> _selectedCountries = {'USA', 'India'};
  Set<String> get selectedCountries => _selectedCountries;

  final Set<String> _selectedWorldCategories = {'Science', 'Space', 'Art'};
  Set<String> get selectedWorldCategories => _selectedWorldCategories;

  final Set<String> _selectedTechCategories = {'AI', 'Mobile'};
  Set<String> get selectedTechCategories => _selectedTechCategories;

  String _selectedCountryFilter = 'Worldwide';
  String get selectedCountryFilter => _selectedCountryFilter;

  void updatePlatforms(Set<String> platforms) {
    _selectedPlatforms.clear();
    _selectedPlatforms.addAll(platforms);
    notifyListeners();
  }

  void updateCountries(Set<String> countries) {
    _selectedCountries.clear();
    _selectedCountries.addAll(countries);
    notifyListeners();
  }

  void updateWorldCategories(Set<String> categories) {
    _selectedWorldCategories.clear();
    _selectedWorldCategories.addAll(categories);
    notifyListeners();
  }

  void updateTechCategories(Set<String> categories) {
    _selectedTechCategories.clear();
    _selectedTechCategories.addAll(categories);
    notifyListeners();
  }

  Future<void> loadCountryFilter() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedCountryFilter = prefs.getString('selectedCountryFilter') ?? 'Worldwide';
    notifyListeners();
  }

  Future<void> updateCountryFilter(String country) async {
    _selectedCountryFilter = country;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedCountryFilter', country);
    notifyListeners();
  }
}