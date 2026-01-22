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

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routes: {
        "/": (context) => SplashScreen(),
        "/Auth": (context) => AuthManager(),
        "/login": (context) => LoginScreen(),
        "/register": (context) => RegisterScreen(),
        "/home": (context) => HomeScreen(),
        "/learn": (context) => LearnScreen(),
        "/courses": (context) => CoursesExploreScreen(),
        "/coursedecription": (context) => CourseDescriptionScreen(),
        "/lessonarticle": (context) => ArticleLessonScreen(),
        "/lessonvideo": (context) => VideoLessonScreen(),
        "/leaderboard": (context) => LeaderboardScreen(),
        "/onboarding": (context) => OnboardingScreen(),
      },
    );
  }
}
