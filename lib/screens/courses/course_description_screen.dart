import 'dart:convert';
import 'package:campy/app_state.dart';
import 'package:campy/screens/courses/lesson_article_screen.dart';
import 'package:campy/screens/courses/lesson_video_screen.dart';
import 'package:flutter/material.dart';
import 'package:campy/api/campy_backend_manager.dart';

class CourseDescriptionScreen extends StatefulWidget {
  final dynamic course;
  final bool isOwned;

  const CourseDescriptionScreen({
    super.key,
    required this.course,
    required this.isOwned,
  });

  @override
  State<CourseDescriptionScreen> createState() =>
      _CourseDescriptionScreenState();
}

class _CourseDescriptionScreenState extends State<CourseDescriptionScreen> {
  List<dynamic> lessons = [];
  bool isLoadingLessons = true;

  @override
  void initState() {
    super.initState();
    fetchLessons();
  }

  Future<void> fetchLessons() async {
    try {
      Course tempCourse = Course(
        id: widget.course['_id'],
        title: widget.course['title'],
        description: '',
        duration: '',
        instructorID: '',
        price: '',
        category: '',
        level: '',
        thumbnail: '',
      );

      final response = await getLessonsByCourse(tempCourse);

      if (response.statusCode == 200) {
        setState(() {
          lessons = jsonDecode(response.body)['data'];
          isLoadingLessons = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching lessons: $e");
      setState(() => isLoadingLessons = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    final double price = double.tryParse(course['price'].toString()) ?? 0.0;

    String buttonText = "Enroll Now";
    if (widget.isOwned) {
      buttonText = "Continue Learning";
    } else if (price > 0) {
      buttonText = "Buy for \$$price";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  Text(
                    course['category'] ?? "Course",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      course['thumbnail'] ?? "",
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        "assets/coursedescriptionpic.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course['title'] ?? "Untitled Course",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Instructor: ${course['instructor']['name'] ?? 'Expert'}",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            course['description'] ??
                                "No description available.",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 25),
                          Text(
                            "${lessons.length} Lessons",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          isLoadingLessons
                              ? const Center(child: CircularProgressIndicator())
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: lessons.length,
                                  itemBuilder: (context, index) {
                                    final lesson = lessons[index];
                                    return _buildLessonItem(
                                      (index + 1).toString(),
                                      lesson['title'],
                                      // Logic: if videoUrl is empty, show "Article"
                                      (lesson['videoUrl'] == null ||
                                              lesson['videoUrl'].isEmpty)
                                          ? "Article"
                                          : "${lesson['duration']} min",
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () async {
                    if (lessons.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("No lessons available yet."),
                        ),
                      );
                      return;
                    }

                    // 1. NAVIGATION LOGIC
                    void startLesson(int index) {
                      final lesson = lessons[index];
                      final bool isVideo =
                          lesson['videoUrl'] != null &&
                          lesson['videoUrl'].isNotEmpty;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => isVideo
                              ? VideoLessonScreen(
                                  lessons: lessons,
                                  currentIndex: index,
                                )
                              : ArticleLessonScreen(
                                  lessons: lessons,
                                  currentIndex: index,
                                ),
                        ),
                      );
                    }

                    if (widget.isOwned) {
                      startLesson(0);
                    } else if (buttonText == "Enroll Now") {
                      try {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        );

                        final response = await enrollUserInCourse(
                          AppState().token,
                          Course(
                            id: widget.course['_id'],
                            title: widget.course['title'],
                            description: '',
                            duration: '',
                            instructorID: '',
                            price: '',
                            category: '',
                            level: '',
                            thumbnail: '',
                          ),
                          AppState().userID,
                        );
                        if (!context.mounted) return;
                        Navigator.pop(context);

                        if (response.statusCode == 200 ||
                            response.statusCode == 201) {
                          startLesson(0);
                        } else {
                          debugPrint("Enrollment failed: ${response.body}");
                        }
                      } catch (e) {
                        Navigator.pop(context);
                        debugPrint("Error during enrollment: $e");
                      }
                    } else {
                      // It's a paid course and not owned (Payment logic skipped as requested)
                      debugPrint("Proceed to payment...");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonItem(String number, String title, String info) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  number,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Expanded(child: Container(width: 1, color: Colors.grey[300])),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      info,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.orange[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
