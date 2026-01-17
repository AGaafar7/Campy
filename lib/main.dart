import 'package:campy/screens/auth/login_screen.dart';
import 'package:campy/screens/auth/register_screen.dart';
import 'package:campy/screens/courses/course_description_screen.dart';
import 'package:campy/screens/courses/courses_explore_screen.dart';
import 'package:campy/screens/courses/lesson_article_screen.dart';
import 'package:campy/screens/courses/lesson_video_screen.dart';
import 'package:campy/screens/home_screen.dart';
import 'package:campy/screens/leaderboard/leaderboard_screen.dart';
import 'package:campy/screens/learn/learn_screen.dart';
import 'package:campy/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const LearnScreen(),
    );
  }
}
