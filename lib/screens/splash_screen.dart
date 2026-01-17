import 'package:campy/screens/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToOnboarding();
  }

  void _navigateToOnboarding() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF0055),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/campyballoon.png',
              width: 180,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 32),
            const Text(
              'CAMPY',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
