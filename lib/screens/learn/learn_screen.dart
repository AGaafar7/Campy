import 'dart:convert';
import 'package:campy/app_state.dart';
import 'package:campy/api/campy_backend_manager.dart';
import 'package:campy/config.dart';
import 'package:campy/screens/courses/lesson_article_screen.dart';
import 'package:campy/screens/courses/lesson_video_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  List<dynamic> ownedCourses = [];
  String? selectedCourseId;
  List<dynamic> lessons = [];
  Set<String> completedLessonIds = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await _fetchOwnedCourses();
  }

  // 1. Get User's Enrolled Courses (Endpoint: /courses/user/:userId)
  Future<void> _fetchOwnedCourses() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/courses/user/${AppState().userID}"),
        headers: {"Authorization": "Bearer ${AppState().token}"},
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body)['data'];
        if (data.isNotEmpty) {
          setState(() {
            ownedCourses = data;
            selectedCourseId = data[0]['courseId']['_id'];
          });
          await _loadCourseData(selectedCourseId!);
        } else {
          setState(() => isLoading = false);
        }
      } else if (response.statusCode == 429) {
        _handleRateLimit();
      }
    } catch (e) {
      debugPrint("Error fetching courses: $e");
      setState(() => isLoading = false);
    }
  }

  // 2. Load Lessons AND Progress simultaneously to avoid 429s
  Future<void> _loadCourseData(String courseId) async {
    setState(() => isLoading = true);
    try {
      final results = await Future.wait([
        http.get(Uri.parse("$baseUrl/lessons/course/$courseId")),
        http.get(
          Uri.parse("$baseUrl/progress/${AppState().userID}/$courseId"),
          headers: {"Authorization": "Bearer ${AppState().token}"},
        ),
      ]);

      final lessonRes = results[0];
      final progressRes = results[1];

      if (lessonRes.statusCode == 200 && progressRes.statusCode == 200) {
        final List lessonData = jsonDecode(lessonRes.body)['data'];
        final dynamic progressBody = jsonDecode(progressRes.body)['data'];

        // 1. Target IDs from the course lessons
        final List cleanedLessons = lessonData.map((lesson) {
          return {...lesson, '_id': lesson['_id'].toString().trim()};
        }).toList();

        // 2. EXTRACT THE NESTED ID
        final List progressList = progressBody['completedLessons'] ?? [];
        final Set<String> cleanedCompletedIds = progressList.map((item) {
          if (item is Map) {
            // Your backend is 'populating' the lessonId.
            // We need to check if lessonId is a Map itself.
            var lessonRef = item['lessonId'];

            if (lessonRef is Map) {
              // Extract _id from the populated lesson object
              return lessonRef['_id'].toString().trim();
            } else {
              // Fallback if it's just a String ID
              return lessonRef.toString().trim();
            }
          }
          return item.toString().trim();
        }).toSet();

        // THESE TWO LOGS SHOULD FINALLY MATCH EXACTLY
        debugPrint("CLEANED PROGRESS SET: $cleanedCompletedIds");
        debugPrint(
          "TARGET LESSON IDs: ${cleanedLessons.map((l) => l['_id']).toList()}",
        );

        setState(() {
          lessons = cleanedLessons
            ..sort((a, b) => (a['order'] ?? 0).compareTo(b['order'] ?? 0));
          completedLessonIds = cleanedCompletedIds;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("Error: $e");
      setState(() => isLoading = false);
    }
  }

  void _handleRateLimit() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Server limit reached. Please wait a moment."),
      ),
    );
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.black),
              )
            : Column(
                children: [
                  _buildHeaderDropdown(),
                  Expanded(
                    child: lessons.isEmpty
                        ? const Center(child: Text("No lessons found."))
                        : SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                ...lessons
                                    .asMap()
                                    .entries
                                    .map((entry) => _buildLessonStep(entry.key))
                                    .toList(),
                                const SizedBox(height: 30),
                                _buildCertificateCard(),
                                const SizedBox(height: 100),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildLessonStep(int index) {
    final lesson = lessons[index];
    final String currentId = lesson['_id'];
    final bool isCompleted = completedLessonIds.contains(currentId);

    // NEW LOGIC:
    // 1. First lesson is always unlocked.
    // 2. If this lesson is completed, it's unlocked (can re-watch).
    // 3. If the PREVIOUS lesson is in the completed set, this one unlocks.
    bool isUnlocked = false;
    if (index == 0) {
      isUnlocked = true;
    } else if (isCompleted) {
      isUnlocked = true;
    } else {
      final String prevLessonId = lessons[index - 1]['_id'];
      if (completedLessonIds.contains(prevLessonId)) {
        isUnlocked = true;
      }
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stepper Icon Logic
          Column(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Colors.green.shade50
                      : (isUnlocked
                            ? Colors.grey.shade200
                            : Colors.grey.shade50),
                  shape: BoxShape.circle,
                  border: isUnlocked && !isCompleted
                      ? Border.all(color: Colors.black12)
                      : null,
                ),
                child: Icon(
                  isCompleted
                      ? Icons.check
                      : (isUnlocked ? Icons.play_arrow : Icons.lock_outline),
                  size: 18,
                  color: isCompleted
                      ? Colors.green
                      : (isUnlocked ? Colors.black : Colors.grey),
                ),
              ),
              if (index != lessons.length - 1)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isCompleted
                        ? Colors.green.shade100
                        : Colors.grey.shade100,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 15),
          // Lesson Card
          Expanded(
            child: Opacity(
              opacity: isUnlocked ? 1.0 : 0.4,
              child: GestureDetector(
                onTap: isUnlocked
                    ? () => _openLesson(lesson, index)
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Finish previous lesson to unlock!"),
                          ),
                        );
                      },
                child: _buildLessonCard(lesson, isCompleted, isUnlocked),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openLesson(dynamic lesson, int index) {
    final bool isVideo =
        lesson['videoUrl'] != null && lesson['videoUrl'].toString().isNotEmpty;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => isVideo
            ? VideoLessonScreen(
                lessons: lessons,
                currentIndex: index,
                completedLessonIds: completedLessonIds,
              )
            : ArticleLessonScreen(
                lessons: lessons,
                currentIndex: index,
                completedLessonIds: completedLessonIds,
              ),
      ),
    ).then((_) => _loadCourseData(selectedCourseId!));
  }

  Widget _buildLessonCard(dynamic lesson, bool isDone, bool isUnlocked) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Lesson ${lesson['order'] ?? ''}",
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
                Text(
                  lesson['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          if (isDone)
            const Icon(Icons.check_circle, color: Colors.green)
          else if (!isUnlocked)
            const Icon(Icons.lock, color: Colors.white24, size: 20),
        ],
      ),
    );
  }

  Widget _buildHeaderDropdown() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(15),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedCourseId,
            isExpanded: true,
            items: ownedCourses.map((c) {
              return DropdownMenuItem<String>(
                value: c['courseId']['_id'],
                child: Text(
                  c['courseId']['title'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                setState(() => selectedCourseId = val);
                _loadCourseData(val);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCertificateCard() {
    bool done =
        lessons.isNotEmpty &&
        lessons.every((l) => completedLessonIds.contains(l['_id']));
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: done ? Colors.green.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            Icons.workspace_premium,
            size: 50,
            color: done ? Colors.green : Colors.grey,
          ),
          const SizedBox(height: 10),
          Text(
            done ? "Course Mastered!" : "Certificate Locked",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          //TODO: Will add a way to download the certificate
          //if (done)
          // ElevatedButton(onPressed: () {}, child: const Text("Download")),
        ],
      ),
    );
  }
}
