import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();

  factory AppState() {
    return _instance;
  }

  AppState._internal();

  String userID = "";
  String token = "";

  void updateUserData(String newID, String newToken) {
    userID = newID;
    token = newToken;
    notifyListeners();
  }

  // Inside your AppState class
  Future<void> loadFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the values
    String? savedToken = prefs.getString('auth_token');
    String? savedId = prefs.getString('user_id');

    // If they exist, put them back into our memory singleton
    if (savedToken != null && savedId != null) {
      token = savedToken;
      userID = savedId;
      debugPrint("Restored Session: $userID");
    }
  }
}
