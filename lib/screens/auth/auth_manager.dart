import 'package:campy/screens/auth/register_screen.dart';
import 'package:flutter/material.dart';

class AuthManager extends StatefulWidget {
  const AuthManager({super.key});

  @override
  State<AuthManager> createState() => _AuthManagerState();
}

class _AuthManagerState extends State<AuthManager> {
  //Check user state and logging in and out and navigate to the correct page
  @override
  Widget build(BuildContext context) {
    return const RegisterScreen();
  }
}
