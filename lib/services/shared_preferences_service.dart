import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/health_info.dart';
import 'package:logger/logger.dart';

class SharedPreferencesService {
  static final SharedPreferencesService instance = SharedPreferencesService._init();
  static const String _healthInfoKey = 'health_info';
  static final Logger _logger = Logger();

  SharedPreferencesService._init();

  Future<void> saveHealthInfo(HealthInfo healthInfo) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final healthInfoJson = {
        'disabilityType': healthInfo.disabilityType,
        'description': healthInfo.description,
        'additionalNotes': healthInfo.additionalNotes,
      };
      await prefs.setString(_healthInfoKey, jsonEncode(healthInfoJson));
    } catch (e) {
      _logger.e('Save health info error: $e');
      rethrow;
    }
  }

  Future<HealthInfo?> getHealthInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final healthInfoString = prefs.getString(_healthInfoKey);
      
      if (healthInfoString != null) {
        final healthInfoJson = jsonDecode(healthInfoString);
        return HealthInfo(
          disabilityType: healthInfoJson['disabilityType'],
          description: healthInfoJson['description'],
          additionalNotes: healthInfoJson['additionalNotes'],
        );
      }
      return null;
    } catch (e) {
      _logger.e('Get health info error: $e');
      rethrow;
    }
  }

  Future<void> updateHealthInfo(HealthInfo healthInfo) async {
    await saveHealthInfo(healthInfo);
  }

  Future<void> clearHealthInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_healthInfoKey);
    } catch (e) {
      _logger.e('Clear health info error: $e');
      rethrow;
    }
  }
} 