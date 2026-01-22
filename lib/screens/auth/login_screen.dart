import 'package:campy/screens/auth/register_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                            "Welcome back",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "sign in to access your account",
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
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 226, 226, 226),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: "Enter your email",
                      suffixIcon: Icon(Icons.email_rounded),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 8),
                  child: TextField(
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
                      Checkbox.adaptive(value: false, onChanged: (value) {}),
                      Text("Remember me", textScaler: TextScaler.linear(0.7)),
                      Spacer(),
                      Text("Forgot Password ?"),
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
                    onPressed: () {},
                    child: Text("Login"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 24),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    child: Text("New Member? Register now"),
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
