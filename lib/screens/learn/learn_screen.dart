import 'dart:convert';
import 'package:campy/app_state.dart';
import 'package:campy/api/campy_backend_manager.dart';
import 'package:campy/screens/courses/lesson_article_screen.dart';
import 'package:campy/screens/courses/lesson_video_screen.dart';
import 'package:flutter/material.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  List<dynamic> ownedCourses = [];
  dynamic selectedCourse;
  List<dynamic> lessons = [];
  Set<String> completedLessonIds = {}; // Track progress from backend
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => isLoading = true);
    try {
      final response = await getCourseByUserID(AppState().userID);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as List;
        setState(() {
          ownedCourses = data;
          if (ownedCourses.isNotEmpty) {
            // Default to the first owned course
            selectedCourse = ownedCourses[0]['courseId'];
            _loadCourseContent(selectedCourse['_id']);
          } else {
            isLoading = false;
          }
        });
      }
    } catch (e) {
      debugPrint("Error loading owned courses: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadCourseContent(String courseId) async {
    try {
      // 1. Load Lessons
      final lessonRes = await getLessonsByCourse(
        Course(
          id: courseId,
          title: "",
          description: '',
          duration: '',
          instructorID: '',
          price: '',
          category: '',
          level: '',
          thumbnail: '',
        ),
      );
      // 2. Load Progress
      final progressRes = await getCourseProgressForUser(
        AppState().token,
        AppState().userID,
        courseId,
      );

      if (lessonRes.statusCode == 200) {
        final lessonData = jsonDecode(lessonRes.body)['data'] as List;
        final progressData = progressRes.statusCode == 200
            ? jsonDecode(progressRes.body)['data']['completedLessons'] as List
            : [];

        setState(() {
          lessons = lessonData;
          completedLessonIds = progressData.map((e) => e.toString()).toSet();
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading lessons: $e");
      setState(() => isLoading = false);
    }
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
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: lessons.length,
                            itemBuilder: (context, index) {
                              return _buildLessonStep(index);
                            },
                          ),
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

  Widget _buildHeaderDropdown() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<dynamic>(
                  value: selectedCourse,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                  items: ownedCourses.map((item) {
                    final course = item['courseId'];
                    return DropdownMenuItem(
                      value: course,
                      child: Text(
                        course['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCourse = value;
                      isLoading = true;
                    });
                    _loadCourseContent(value['_id']);
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          _buildNotificationIcon(),
        ],
      ),
    );
  }

  Widget _buildLessonStep(int index) {
    final lesson = lessons[index];
    final bool isCompleted = completedLessonIds.contains(lesson['_id']);

    // Logic: A lesson is unlocked if it's the first one, OR if the previous one is completed
    final bool isUnlocked =
        index == 0 || completedLessonIds.contains(lessons[index - 1]['_id']);
    final bool isLast = index == lessons.length - 1;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vertical Stepper
          Column(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? Colors.grey.shade300
                      : Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  "${index + 1}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: Colors.grey.shade200),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Lesson Card
          Expanded(
            child: Opacity(
              opacity: isUnlocked
                  ? 1.0
                  : 0.5, // Faded effect for locked lessons
              child: Column(
                children: [
                  _buildSubLessonCard(lesson, isCompleted, isUnlocked, index),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubLessonCard(
    dynamic lesson,
    bool isCompleted,
    bool isUnlocked,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        if (!isUnlocked) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Complete the previous lesson first!"),
            ),
          );
          return;
        }

        final bool isVideo =
            lesson['videoUrl'] != null && lesson['videoUrl'].isNotEmpty;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => isVideo
                ? VideoLessonScreen(lessons: lessons, currentIndex: index, completedLessonIds: completedLessonIds,)
                : ArticleLessonScreen(lessons: lessons, currentIndex: index, completedLessonIds: completedLessonIds,),
          ),
        ).then(
          (_) => _loadCourseContent(selectedCourse['_id']),
        ); // Refresh progress when returning
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D2D),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.book_outlined, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson['videoUrl'] != null
                            ? "Video Lesson"
                            : "Article Lesson",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        lesson['title'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (isCompleted)
                  const Icon(Icons.check_circle, color: Colors.green, size: 24)
                else
                  const Icon(
                    Icons.radio_button_unchecked,
                    color: Colors.white54,
                  ),
              ],
            ),
            if (!isCompleted && isUnlocked) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => {}, // Handled by GestureDetector onTap
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Learn",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(Icons.notifications_none_outlined),
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCertificateCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          const Icon(Icons.workspace_premium, size: 60, color: Colors.black54),
          const SizedBox(height: 10),
          const Text(
            "Your Certificate is Close",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Text(
            "Complete all lessons to unlock it!",
            style: TextStyle(fontSize: 12, color: Colors.black45),
          ),
        ],
      ),
    );
  }
}
