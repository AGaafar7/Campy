import 'dart:convert';
import 'package:campy/app_state.dart';
import 'package:campy/api/campy_backend_manager.dart';
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
  String? selectedCourseId; // Standardized to use String ID
  List<dynamic> lessons = [];
  Set<String> completedLessonIds = {}; 
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  // Helper to check if entire course is done
  bool get isCourseFullyCompleted {
    if (lessons.isEmpty) return false;
    return lessons.every((l) => completedLessonIds.contains(l['_id'].toString().trim()));
  }

  Future<void> _loadInitialData() async {
    if (!mounted) return;
    setState(() => isLoading = true);
    
    try {
      final response = await getCourseByUserID(AppState().userID);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as List;
        
        if (data.isNotEmpty) {
          // Extract the first course ID correctly
          final String firstId = data[0]['courseId']['_id'].toString();
          setState(() {
            ownedCourses = data;
            selectedCourseId = firstId;
          });
          // Explicitly wait for content to load
          await _loadCourseContent(firstId);
        } else {
          setState(() {
            ownedCourses = [];
            isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Error loading initial data: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _loadCourseContent(String courseId) async {
    try {
      // 1. Fetch Lessons
      final lessonRes = await getLessonsByCourse(
        Course(id: courseId, title: "", description: '', duration: '', instructorID: '', price: '', category: '', level: '', thumbnail: ''),
      );
      
      // 2. Fetch Progress
      final progressRes = await getCourseProgressForUser(
        AppState().token,
        AppState().userID,
        courseId,
      );

      if (lessonRes.statusCode == 200) {
        final lessonData = jsonDecode(lessonRes.body)['data'] as List;
        Set<String> completedIds = {};
        
        if (progressRes.statusCode == 200) {
          final progressData = jsonDecode(progressRes.body)['data'];
          final List progressList = progressData['completedLessons'] ?? [];
          
          completedIds = progressList.map((e) {
            // Robust check for different backend ID formats
            if (e is Map) return e['lessonId'].toString().trim();
            return e.toString().trim();
          }).toSet();
        }

        if (mounted) {
          setState(() {
            lessons = lessonData;
            completedLessonIds = completedIds;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Error in _loadCourseContent: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.black))
            : Column(
                children: [
                  _buildHeaderDropdown(),
                  Expanded(
                    child: lessons.isEmpty 
                      ? const Center(child: Text("No lessons found for this course."))
                      : SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: lessons.length,
                                itemBuilder: (context, index) => _buildLessonStep(index),
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

  Widget _buildLessonStep(int index) {
    final lesson = lessons[index];
    final String currentId = lesson['_id'].toString().trim();
    final bool isCompleted = completedLessonIds.contains(currentId);

    // UNLOCK LOGIC:
    // 1. It is the first lesson
    // 2. OR it is already completed
    // 3. OR the previous lesson is in the completed set
    bool isUnlocked = index == 0 || isCompleted;
    if (!isUnlocked && index > 0) {
      final String prevId = lessons[index - 1]['_id'].toString().trim();
      isUnlocked = completedLessonIds.contains(prevId);
    }

    final bool isLast = index == lessons.length - 1;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepperIndicator(index, isCompleted, isUnlocked, isLast),
          const SizedBox(width: 16),
          Expanded(
            child: Opacity(
              opacity: isUnlocked ? 1.0 : 0.5,
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

  Widget _buildStepperIndicator(int index, bool isCompleted, bool isUnlocked, bool isLast) {
    return Column(
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: isCompleted ? Colors.green.shade100 : (isUnlocked ? Colors.grey.shade300 : Colors.grey.shade50),
            shape: BoxShape.circle,
            border: isUnlocked && !isCompleted ? Border.all(color: Colors.black, width: 1.5) : null,
          ),
          child: Center(
            child: isCompleted 
              ? const Icon(Icons.check, size: 20, color: Colors.green)
              : Text("${index + 1}", style: TextStyle(fontWeight: FontWeight.bold, color: isUnlocked ? Colors.black : Colors.grey)),
          ),
        ),
        if (!isLast)
          Expanded(child: Container(width: 2, color: isCompleted ? Colors.green.shade200 : Colors.grey.shade200)),
      ],
    );
  }

  Widget _buildSubLessonCard(dynamic lesson, bool isCompleted, bool isUnlocked, int index) {
    return GestureDetector(
      onTap: () {
        if (!isUnlocked) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Complete the previous lesson first!")),
          );
          return;
        }

        final bool isVideo = lesson['videoUrl'] != null && lesson['videoUrl'].isNotEmpty;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => isVideo
                ? VideoLessonScreen(lessons: lessons, currentIndex: index, completedLessonIds: completedLessonIds)
                : ArticleLessonScreen(lessons: lessons, currentIndex: index, completedLessonIds: completedLessonIds),
          ),
        ).then((_) {
          // CORRECTED: Ensure we refresh with the current selected ID
          if (selectedCourseId != null) {
            _loadCourseContent(selectedCourseId!);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D2D),
          borderRadius: BorderRadius.circular(15),
          border: isCompleted ? Border.all(color: Colors.green.withOpacity(0.5), width: 1) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(lesson['videoUrl'] != null ? Icons.play_circle_outline : Icons.book_outlined, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(lesson['videoUrl'] != null ? "Video Lesson" : "Article Lesson", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      Text(lesson['title'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                Icon(isCompleted ? Icons.check_circle : Icons.radio_button_unchecked, color: isCompleted ? Colors.green : Colors.white54, size: 24),
              ],
            ),
            if (!isCompleted && isUnlocked) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8)),
                  child: const Center(child: Text("Continue Learning", style: TextStyle(color: Colors.white, fontSize: 13))),
                ),
              ),
            ],
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
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(20)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCourseId,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: ownedCourses.map((item) {
                    final course = item['courseId'];
                    return DropdownMenuItem<String>(
                      value: course['_id'].toString(),
                      child: Text(course['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    );
                  }).toList(),
                  onChanged: (String? newId) {
                    if (newId != null && newId != selectedCourseId) {
                      setState(() {
                        selectedCourseId = newId;
                        isLoading = true;
                      });
                      _loadCourseContent(newId);
                    }
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

  Widget _buildCertificateCard() {
    bool done = isCourseFullyCompleted;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: done ? Colors.green.shade50 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25),
        border: done ? Border.all(color: Colors.green.shade200) : null,
      ),
      child: Column(
        children: [
          Icon(Icons.workspace_premium, size: 60, color: done ? Colors.green : Colors.black54),
          const SizedBox(height: 10),
          Text(done ? "Course Completed!" : "Your Certificate is Close", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(done ? "You have officially mastered this course." : "Complete all lessons to unlock it!", style: TextStyle(fontSize: 12, color: done ? Colors.green.shade700 : Colors.black45)),
          if (done) ...[
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {}, // Handle download logic
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              child: const Text("Download Certificate"),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return Stack(children: [
      Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(15)), child: const Icon(Icons.notifications_none_outlined)),
      Positioned(right: 8, top: 8, child: Container(height: 10, width: 10, decoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)))),
    ]);
  }
}