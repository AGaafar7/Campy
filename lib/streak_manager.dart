import 'package:shared_preferences/shared_preferences.dart';

class StreakManager {
  static const String _keyLastLogin = "last_login_date";
  static const String _keyCurrentStreak = "current_streak";

  Future<int> updateAndGetStreak() async {
    final prefs = await SharedPreferences.getInstance();

    DateTime now = DateTime.now();

    String today = "${now.year}-${now.month}-${now.day}";
    String? lastLogin = prefs.getString(_keyLastLogin);
    int currentStreak = prefs.getInt(_keyCurrentStreak) ?? 0;

    if (lastLogin == null) {
      currentStreak = 1;
    } else if (lastLogin == today) {
      return currentStreak;
    } else {
      DateTime.parse(lastLogin);
      DateTime yesterday = now.subtract(const Duration(days: 1));
      String yesterdayString =
          "${yesterday.year}-${yesterday.month}-${yesterday.day}";

      if (lastLogin == yesterdayString) {
        currentStreak++;
      } else {
        currentStreak = 1;
      }
    }

    await prefs.setString(_keyLastLogin, today);
    await prefs.setInt(_keyCurrentStreak, currentStreak);

    return currentStreak;
  }
}
