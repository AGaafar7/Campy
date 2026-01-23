import 'dart:convert';

import 'package:campy/api/campy_backend_manager.dart';
import 'package:campy/app_state.dart';
import 'package:campy/screens/courses/lesson_video_screen.dart';
import 'package:flutter/material.dart';

class ArticleLessonScreen extends StatelessWidget {
  final List<dynamic> lessons;
  final int currentIndex;
  final Set<String> completedLessonIds;

  const ArticleLessonScreen({
    super.key,
    required this.lessons,
    required this.currentIndex,
    required this.completedLessonIds,
  });

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
                  child: const Text("Quit", style: TextStyle(color: Colors.black)),
                ),
              ),
            ),
            Image.network(
              currentLesson['thumbnail'] ?? "",
              height: 200, width: double.infinity, fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                "assets/coursedescriptionpic.png", fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text("Lesson ${currentIndex + 1}: ${currentLesson['title']}", 
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          currentLesson['content'] ?? "No content provided.",
                          style: const TextStyle(color: Colors.white70, height: 1.5, fontSize: 15),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (hasPrev) IconButton(
                          onPressed: () => _navigate(context, currentIndex - 1, false),
                          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                        ) else const SizedBox(width: 48),
                        
                        if (hasNext) _buildNavCard(context, currentIndex + 1)
                        else TextButton(
                          onPressed: () async {
                            if (!completedLessonIds.contains(currentLesson['_id'])) {
                              await completeLesson(
                                AppState().token,
                                AppState().userID,
                                _safeId(currentLesson['courseId']),
                                _safeId(currentLesson),
                              );
                              await _awardKudos();
                            }
                            if (context.mounted) Navigator.pop(context);
                          },
                          child: const Text("Complete Course", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        ),
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

  void _navigate(BuildContext context, int index, bool markAsComplete) async {
    final currentLesson = lessons[currentIndex];
    
    if (markAsComplete) {
        if (!completedLessonIds.contains(currentLesson['_id'])) {
        try {
          await completeLesson(
            AppState().token,
            AppState().userID,
            _safeId(currentLesson['courseId']),
            _safeId(currentLesson),
          );
         completedLessonIds.add(currentLesson['_id']);
        } catch (e) {
          debugPrint("Error: $e");
        }
      }
    }

    final lesson = lessons[index];
    final isVideo = lesson['videoUrl'] != null && lesson['videoUrl'].isNotEmpty;
    
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => isVideo 
            ? VideoLessonScreen(lessons: lessons, currentIndex: index, completedLessonIds: completedLessonIds)
            : ArticleLessonScreen(lessons: lessons, currentIndex: index, completedLessonIds: completedLessonIds),
        ),
      );
    }
  }

  Widget _buildNavCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => _navigate(context, index, true),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            const Text("Next Lesson", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14),
          ],
        ),
      ),
    );
  }

  Future<void> _awardKudos() async {
  try {
    final response = await getUsersByID(AppState().userID);
    
    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body)['data'];
      
      String currentName = userData['name'];
      String currentEmail = userData['email'];
      int currentKudos = int.tryParse(userData['kudos'].toString()) ?? 0;
      int newKudos = currentKudos + 10;

      User updatedUser = User(
        name: currentName,
        email: currentEmail,
        password: "", 
        kudos: newKudos.toString(),
      );

      final updateResponse = await updateUser(
        updatedUser,
        AppState().userID,
        AppState().token,
      );

      if (updateResponse.statusCode == 200) {
        debugPrint("Awarded 10 Kudos! Total: $newKudos");
      }
    }
  } catch (e) {
    debugPrint("Error awarding kudos: $e");
  }
}
}