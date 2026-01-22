import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

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
}