import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing app preferences consistently across the app
class PreferencesService {
  static const String _onboardingCompletedKey = 'onboardingCompleted';
  static const String _isDarkModeKey = 'isDarkMode';
  static const String _userLoggedInKey = 'userLoggedIn';
  static const String _userIdKey = 'userId';

  /// Sets onboarding as completed
  static Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, true);
  }

  /// Checks if onboarding is completed
  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  /// Sets the theme mode preference
  static Future<void> setDarkMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDarkModeKey, isDarkMode);
  }

  /// Gets the theme mode preference
  static Future<bool?> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isDarkModeKey);
  }

  /// Sets user as logged in
  static Future<void> setUserLoggedIn(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_userLoggedInKey, true);
    await prefs.setString(_userIdKey, userId);
  }

  /// Checks if user is logged in
  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_userLoggedInKey) ?? false;
  }

  /// Logs out user
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_userLoggedInKey, false);
    await prefs.remove(_userIdKey);
  }

  /// Gets current user ID
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  /// Clears all preferences
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
