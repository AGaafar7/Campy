import 'package:campy/api/models/user_auth.dart';
import 'package:campy/config.dart';
import 'package:http/http.dart' as http;

//API Authentication Logic
//Think about param and app state logic
///Sign Up a new user
Future<http.Response> signUp(User user) {
  return http.post(
    Uri.parse("$base_url/auth/sign-up"),
    body: {"name": user.name, "email": user.email, "password": user.password},
  );
}

///User sign in
Future<http.Response> signIn(User user) {
  return http.post(
    Uri.parse("$base_url/auth/sign-in"),
    body: {"email": user.email, "password": user.password},
  );
}

///Sign out
Future<http.Response> signOut(String token) {
  return http.post(
    Uri.parse("$base_url/auth/sign-in"),
    headers: {"Authorization": "Bearer $token"},
  );
}
