import 'package:campy/screens/courses/courses_explore_screen.dart';
import 'package:campy/screens/home_screen.dart';
import 'package:campy/screens/leaderboard/leaderboard_screen.dart';
import 'package:campy/screens/learn/learn_screen.dart';
import 'package:campy/shared/widgets/custom_bottom_bar.dart';
import 'package:flutter/material.dart';

class NavigationManagerScreen extends StatefulWidget {
  const NavigationManagerScreen({super.key});

  @override
  State<NavigationManagerScreen> createState() =>
      _NavigationManagerScreenState();
}

class _NavigationManagerScreenState extends State<NavigationManagerScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const CoursesExploreScreen(),
    const LeaderboardScreen(),
    const LearnScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_selectedIndex],

      bottomNavigationBar: CustomBottomBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
