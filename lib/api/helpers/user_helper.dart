import 'package:campy/api/models/user_auth.dart';
import 'package:campy/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//API User Route Logic
Future<http.Response> getUsers() {
  return http.get(Uri.parse("$baseUrl/users"));
}

Future<http.Response> getUsersByID(String id) {
  if (id.isEmpty) {
    debugPrint("Warning: Attempted to fetch user with empty ID");
  }
  return http.get(Uri.parse("$baseUrl/users/$id"));
}

Future<http.Response> getUserCourses(String id) {
  return http.get(Uri.parse("$baseUrl/users/$id/courses"));
}

//Admin only function for upcoming updates
///Create new user admin only
Future<http.Response> createUserByAdmin(User user) {
  return http.post(
    Uri.parse("$baseUrl/users"),
    body: {"name": user.name, "email": user.email, "password": user.password},
  );
}

///Update User details needs authentication needs the token
//Needs refactoring for the id and token
Future<http.Response> updateUser(User user, String id, String token) {
  return http.put(
    Uri.parse("$baseUrl/users/$id"),
    headers: {"Authorization": "Bearer $token"},
    body: {"name": user.name, "email": user.email, "kudos": user.kudos},
  );
}

///Delete User
Future<http.Response> deleteUser(User user, String id, String token) {
  return http.delete(
    Uri.parse("$baseUrl/users/$id"),
    headers: {"Authorization": "Bearer $token"},
  );
}
