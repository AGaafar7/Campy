import 'package:campy/screens/auth/register_screen.dart';
import 'package:flutter/material.dart';
//TODO: this class is not needed
class AuthManager extends StatefulWidget {
  const AuthManager({super.key});

  @override
  State<AuthManager> createState() => _AuthManagerState();
}

class _AuthManagerState extends State<AuthManager> {
  
  @override
  Widget build(BuildContext context) {
    return const RegisterScreen();
  }
}
