import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState with ChangeNotifier {
  List<String> _selectedSpecialties = [];
  List<String> _selectedDays = [];
  String? _address;

  List<String> get selectedSpecialties => _selectedSpecialties;
  List<String> get selectedDays => _selectedDays;
  String? get address => _address;

  String? profileImagePath;

  void setProfileImage(String path) {
    profileImagePath = path;
    notifyListeners();
  }

  void setSelectedSpecialties(List<String> specialties) {
    _selectedSpecialties = specialties;
    notifyListeners();
  }

  void setSelectedDays(List<String> days) {
    _selectedDays = days;
    notifyListeners();
  }

  void setAddress(String address) {
    _address = address;
    notifyListeners();
  }

  // في AppState
  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selectedSpecialties', _selectedSpecialties);
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedSpecialties = prefs.getStringList('selectedSpecialties') ?? [];
    notifyListeners();
  }
}
