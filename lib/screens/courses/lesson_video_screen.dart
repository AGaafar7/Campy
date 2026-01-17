import 'package:flutter/material.dart';

class VideoLessonScreen extends StatelessWidget {
  const VideoLessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Quit and Continue Later",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            // Video Preview Section
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  "assets/coursedescriptionpic.png",
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    size: 50,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Lesson 1: Intro to good design",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            // Media Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.fast_rewind_rounded, size: 40),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.play_circle_fill_rounded, size: 50),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.fast_forward_rounded, size: 40),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Summary Black Card
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Summary;",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Unlock your creative potential with this complete course. Learn design theory, master industry-standard tools, and create captivating user interfaces for web and mobile.",
                      style: TextStyle(color: Colors.white70, height: 1.5),
                    ),
                    const Spacer(),
                    // Next Lesson Navigator
                    _buildNextLessonCard(
                      "Lesson 2: Make Good Designs",
                      "Article",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextLessonCard(String title, String type) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                type,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        ],
      ),
    );
  }
}
