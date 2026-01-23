import 'package:campy/screens/auth/auth_manager.dart';
import 'package:campy/screens/onboarding/dots_indicator.dart';
import 'package:campy/screens/onboarding/onboarding_item.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingItem> _pages = [
    OnboardingItem(
      image: 'assets/onboarding_1.png',
      title: 'Learn smarter. Build real skills.',
      subtitle:
          'High-quality courses designed for university students in engineering, programming, and technology.',
    ),
    OnboardingItem(
      image: 'assets/onboarding_2.png',
      title: 'Master concepts through practice',
      subtitle:
          'Apply what you learn with hands-on exercises, real projects, and structured learning paths.',
    ),
    OnboardingItem(
      image: 'assets/onboarding_3.png',
      title: 'Track progress. Achieve more.',
      subtitle:
          'Follow your learning journey, earn certificates, and stay motivated as you level up your skills.',
    ),
  ];

  void _next() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthManager()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: PageView.builder(
        controller: _pageController,
        itemCount: _pages.length,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        itemBuilder: (context, index) {
          final item = _pages[index];

          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                
                    Image.asset(item.image, height: 260, fit: BoxFit.contain),

             
                    Column(
                      children: [
                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item.subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),

             
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DotsIndicator(
                          currentIndex: _currentIndex,
                          total: _pages.length,
                        ),
                        _currentIndex == _pages.length - 1
                            ? ElevatedButton(
                                onPressed: _finishOnboarding,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text(
                                  'Get Started',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : FloatingActionButton(
                                onPressed: _next,
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                child: const Icon(
                                  Icons.arrow_forward,
                                  size: 22,
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
