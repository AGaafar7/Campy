import 'package:campy/screens/courses/lesson_article_screen.dart';
import 'package:flutter/material.dart';

class VideoLessonScreen extends StatelessWidget {
  final List<dynamic> lessons;
  final int currentIndex;

  const VideoLessonScreen({
    super.key,
    required this.lessons,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final currentLesson = lessons[currentIndex];
    final bool hasNext = currentIndex < lessons.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Quit", style: TextStyle(color: Colors.black)),
              ),
            ),
            // Video Placeholder
            Container(
              height: 250, color: Colors.black,
              child: const Center(child: Icon(Icons.play_circle_fill, size: 64, color: Colors.white)),
            ),
            const SizedBox(height: 20),
            Text("Lesson ${currentIndex + 1}: ${currentLesson['title']}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Summary", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(currentLesson['content'] ?? "", style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 30),
                  if (hasNext) _buildNextButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    final int nextIndex = currentIndex + 1;
    final next = lessons[nextIndex];
    return InkWell(
      onTap: () {
        final isVideo = next['videoUrl'] != null && next['videoUrl'].isNotEmpty;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => isVideo 
              ? VideoLessonScreen(lessons: lessons, currentIndex: nextIndex)
              : ArticleLessonScreen(lessons: lessons, currentIndex: nextIndex),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Next Lesson", style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(next['title'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_rounded),
          ],
        ),
      ),
    );
  }
}