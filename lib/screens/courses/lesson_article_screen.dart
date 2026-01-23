import 'package:campy/screens/courses/lesson_video_screen.dart';
import 'package:flutter/material.dart';

class ArticleLessonScreen extends StatelessWidget {
  final List<dynamic> lessons;
  final int currentIndex;

  const ArticleLessonScreen({
    super.key,
    required this.lessons,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final currentLesson = lessons[currentIndex];
    final bool hasNext = currentIndex < lessons.length - 1;
    final bool hasPrev = currentIndex > 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Quit and Continue Later", style: TextStyle(color: Colors.black)),
                ),
              ),
            ),
            Image.network(
              "https://via.placeholder.com/400x250", // Or a dynamic image if your lesson has one
              height: 200, width: double.infinity, fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Text(
              "Lesson ${currentIndex + 1}: ${currentLesson['title']}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(currentLesson['title'], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    Text(
                      currentLesson['content'] ?? "No content provided.",
                      style: const TextStyle(color: Colors.white70, height: 1.5, fontSize: 15),
                    ),
                    const Spacer(),
                    // Navigation Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (hasPrev) IconButton(
                          onPressed: () => _navigate(context, currentIndex - 1),
                          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                        ) else const SizedBox(width: 48),
                        
                        if (hasNext) _buildNavCard(context, currentIndex + 1)
                        else const Text("Course Completed", style: TextStyle(color: Colors.green)),
                      ],
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

  void _navigate(BuildContext context, int index) {
    final lesson = lessons[index];
    final isVideo = lesson['videoUrl'] != null && lesson['videoUrl'].isNotEmpty;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => isVideo 
          ? VideoLessonScreen(lessons: lessons, currentIndex: index)
          : ArticleLessonScreen(lessons: lessons, currentIndex: index),
      ),
    );
  }

  Widget _buildNavCard(BuildContext context, int index) {
    final next = lessons[index];
    return GestureDetector(
      onTap: () => _navigate(context, index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Next: ${next['title']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                Text(next['videoUrl'].isNotEmpty ? "Video" : "Article", style: const TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14),
          ],
        ),
      ),
    );
  }
}