import 'package:shared_preferences/shared_preferences.dart';

class StreakManager {
  static const String _keyLastLogin = "last_login_date";
  static const String _keyCurrentStreak = "current_streak";

  Future<int> updateAndGetStreak() async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Get current time and stored time
    DateTime now = DateTime.now();
    // Use a string to store the date (YYYY-MM-DD) to ignore hours/minutes
    String today = "${now.year}-${now.month}-${now.day}";
    String? lastLogin = prefs.getString(_keyLastLogin);
    int currentStreak = prefs.getInt(_keyCurrentStreak) ?? 0;

    // 2. Logic Check
    if (lastLogin == null) {
      // First time ever using the app
      currentStreak = 1;
    } else if (lastLogin == today) {
      // User already opened the app today, don't change anything
      return currentStreak;
    } else {
      DateTime.parse(lastLogin);
      DateTime yesterday = now.subtract(const Duration(days: 1));
      String yesterdayString =
          "${yesterday.year}-${yesterday.month}-${yesterday.day}";

      if (lastLogin == yesterdayString) {
        // It's the very next day!
        currentStreak++;
      } else {
        // User missed a day or more
        currentStreak = 1;
      }
    }

    // 3. Save the new values
    await prefs.setString(_keyLastLogin, today);
    await prefs.setInt(_keyCurrentStreak, currentStreak);

    return currentStreak;
  }
}
