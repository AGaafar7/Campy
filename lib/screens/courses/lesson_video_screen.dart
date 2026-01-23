import 'dart:convert';

import 'package:campy/api/campy_backend_manager.dart';
import 'package:campy/app_state.dart';
import 'package:campy/screens/courses/lesson_article_screen.dart';
import 'package:flutter/material.dart';

class VideoLessonScreen extends StatelessWidget {
  final List<dynamic> lessons;
  final int currentIndex;
  final Set<String> completedLessonIds; // Added set tracker

  const VideoLessonScreen({
    super.key,
    required this.lessons,
    required this.currentIndex,
    required this.completedLessonIds, // Require set in constructor
  });

  // Helper to safely get ID String
  String _safeId(dynamic data) {
    if (data == null) return "";
    if (data is String) return data;
    if (data is Map) return data['_id'] ?? "";
    return "";
  }

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
                child: const Text(
                  "Quit",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            // Video Placeholder
            Container(
              height: 250,
              color: Colors.black,
              child: const Center(
                child: Icon(
                  Icons.play_circle_fill,
                  size: 64,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Lesson ${currentIndex + 1}: ${currentLesson['title']}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Container(
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
                    "Summary",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    currentLesson['content'] ?? "",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 30),

                  // Conditional Row: Show Next Button or Finish Button
                  if (hasNext)
                    _buildNextButton(context)
                  else
                    _buildFinishButton(context, currentLesson),
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
    final currentLesson = lessons[currentIndex];

    return InkWell(
      onTap: () async {
        // CHECK: Only call API if lesson is NOT already in the set
        if (!completedLessonIds.contains(currentLesson['_id'])) {
          try {
            await completeLesson(
              AppState().token,
              AppState().userID,
              _safeId(currentLesson['courseId']),
              _safeId(currentLesson),
            );
            // Locally update the set to prevent double calls if they navigate back
            completedLessonIds.add(currentLesson['_id']);
            await _awardKudos();
          } catch (e) {
            debugPrint("Failed to mark lesson complete: $e");
          }
        }

        final isVideo = next['videoUrl'] != null && next['videoUrl'].isNotEmpty;
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => isVideo
                  ? VideoLessonScreen(
                      lessons: lessons,
                      currentIndex: nextIndex,
                      completedLessonIds: completedLessonIds,
                    )
                  : ArticleLessonScreen(
                      lessons: lessons,
                      currentIndex: nextIndex,
                      completedLessonIds: completedLessonIds,
                    ),
            ),
          );
        }
      },
      child: Container(
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
                const Text(
                  "Next Lesson",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  next['title'],
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_rounded),
          ],
        ),
      ),
    );
  }

  Widget _buildFinishButton(BuildContext context, dynamic currentLesson) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          // Check before marking the last lesson complete
          if (!completedLessonIds.contains(currentLesson['_id'])) {
            await completeLesson(
              AppState().token,
              AppState().userID,
              _safeId(currentLesson['courseId']),
              _safeId(currentLesson),
            );
          }
          if (context.mounted) Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          "Finish Course",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<void> _awardKudos() async {
    try {
      // 1. Fetch current user data to get the latest Name and Email
      final response = await getUsersByID(AppState().userID);

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body)['data'];

        String currentName = userData['name'];
        String currentEmail = userData['email'];
        // Get existing kudos from DB and add 10
        int currentKudos = int.tryParse(userData['kudos'].toString()) ?? 0;
        int newKudos = currentKudos + 10;

        // 2. Create the User object for the Update request
        User updatedUser = User(
          name: currentName,
          email: currentEmail,
          password: "", // Password is not needed for the update route usually
          kudos: newKudos.toString(),
        );

        // 3. Send the Update request
        final updateResponse = await updateUser(
          updatedUser,
          AppState().userID,
          AppState().token,
        );

        if (updateResponse.statusCode == 200) {
          // 4. (Optional) Show feedback to the user
          debugPrint("Awarded 10 Kudos! Total: $newKudos");
        }
      }
    } catch (e) {
      debugPrint("Error awarding kudos: $e");
    }
  }
}
