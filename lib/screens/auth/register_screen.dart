import 'dart:convert';

import 'package:campy/api/campy_backend_manager.dart';
import 'package:campy/app_state.dart';
import 'package:campy/screens/auth/login_screen.dart';
import 'package:campy/screens/navigation_manager_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool? isTermsAgreed = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      "assets/createaccountmap.png",
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 55,
                      left: 0,
                      right: 25,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            "Get Started",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "by creating a free account",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 20.0),
                  child: TextField(
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 226, 226, 226),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: "Full name",
                      suffixIcon: Icon(Icons.account_circle_rounded),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 20.0),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 226, 226, 226),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: "Email",
                      suffixIcon: Icon(Icons.email_rounded),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 8),
                  child: TextField(
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 226, 226, 226),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: "Password",
                      suffixIcon: Icon(Icons.password_rounded),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 0),
                  child: Row(
                    children: [
                      Checkbox.adaptive(
                        value: isTermsAgreed,
                        onChanged: (value) {
                          setState(() {
                            isTermsAgreed = value;
                          });
                        },
                      ),
                      Text(
                        "By checking the box you agree to our Terms and Conditions.",
                        textScaler: TextScaler.linear(0.7),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(8),
                        ),
                      ),
                      backgroundColor: WidgetStatePropertyAll(Colors.black),
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                      maximumSize: WidgetStatePropertyAll(Size(350, 45)),
                      fixedSize: WidgetStatePropertyAll(Size(350, 45)),
                    ),
                    onPressed: () async {
                      if (nameController.text.isEmpty ||
                          emailController.text.isEmpty ||
                          passwordController.text.isEmpty ||
                          isTermsAgreed == false ||
                          isTermsAgreed == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill in all fields'),
                          ),
                        );
                        return;
                      } else {
                        User user = User(
                          name: nameController.text.trim(),
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          kudos: "0",
                        );
                        http.Response response = await signUp(user);
                        if (response.statusCode == 201) {
                          final Map<String, dynamic> decoded = jsonDecode(
                            response.body,
                          );

                          final String token = decoded['data']['token'];
                          final String userId = decoded['data']['userId'];
                          AppState().updateUserData(userId, token);
                          debugPrint('TOKEN: $token');
                          debugPrint('USER ID: $userId');
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          await prefs.setString('auth_token', token);
                          await prefs.setString('user_id', userId);
                          if (!context.mounted) return;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NavigationManagerScreen(),
                            ),
                          );
                        } else {
                          final error = jsonDecode(response.body)['message'];
                          debugPrint('Signup failed: $error');
                        }
                      }
                    },
                    child: Text("Register"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 24),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text("Already a member? Log In"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
