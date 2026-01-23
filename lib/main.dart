import 'package:campy/app_state.dart';
import 'package:campy/screens/auth/auth_manager.dart';
import 'package:campy/screens/auth/login_screen.dart';
import 'package:campy/screens/auth/register_screen.dart';
import 'package:campy/screens/courses/course_description_screen.dart';
import 'package:campy/screens/courses/courses_explore_screen.dart';
import 'package:campy/screens/courses/lesson_article_screen.dart';
import 'package:campy/screens/courses/lesson_video_screen.dart';
import 'package:campy/screens/home_screen.dart';
import 'package:campy/screens/leaderboard/leaderboard_screen.dart';
import 'package:campy/screens/learn/learn_screen.dart';
import 'package:campy/screens/onboarding/onboarding_screen.dart';
import 'package:campy/screens/splash_screen.dart';
import 'package:campy/style_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MyApp(onBoard: hasSeenOnboarding),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool onBoard;
  const MyApp({super.key, required this.onBoard});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routes: {
        "/": (context) => SplashScreen(onBoard: onBoard),
        "/Auth": (context) => AuthManager(),
        "/login": (context) => LoginScreen(),
        "/register": (context) => RegisterScreen(),
        "/home": (context) => HomeScreen(),
        "/learn": (context) => LearnScreen(),
        "/courses": (context) => CoursesExploreScreen(),
        "/leaderboard": (context) => LeaderboardScreen(),
        "/onboarding": (context) => OnboardingScreen(),
      },
    );
  }
}
