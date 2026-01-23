import 'dart:convert';
import 'package:campy/app_state.dart';
import 'package:campy/config.dart';
import 'package:campy/screens/courses/lesson_article_screen.dart';
import 'package:campy/screens/courses/lesson_video_screen.dart';
import 'package:campy/screens/payment/paymob_webview.dart';
import 'package:flutter/material.dart';
import 'package:campy/api/campy_backend_manager.dart';
import 'package:http/http.dart' as http;

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
  Set<String> completedLessonIds = {};
  bool isLoadingLessons = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await fetchLessons();
    if (widget.isOwned) {
      await _fetchUserProgress();
    }
  }

  Future<void> _fetchUserProgress() async {
    try {
      final response = await getCourseProgressForUser(
        AppState().token,
        AppState().userID,
        widget.course['_id'],
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        final completed = data['completedLessons'] as List;
        setState(() {
          completedLessonIds = completed
              .map((e) => e['lessonId'].toString())
              .toSet();
        });
      }
    } catch (e) {
      debugPrint("Error fetching progress: $e");
    }
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

  void _startLesson(int index) {
    if (lessons.isEmpty) return;

    final lesson = lessons[index];
    final bool isVideo =
        lesson['videoUrl'] != null && lesson['videoUrl'].isNotEmpty;

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
    ).then((_) {
      if (widget.isOwned) _fetchUserProgress();
    });
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
            _buildCustomAppBar(course),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCourseThumbnail(course),
                    const SizedBox(height: 16),
                    _buildCourseDetails(course),
                  ],
                ),
              ),
            ),
            _buildBottomActionButton(buttonText),
          ],
        ),
      ),
    );
  }


  Widget _buildCustomAppBar(dynamic course) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          Text(
            course['category'] ?? "Course",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseThumbnail(dynamic course) {
    return Image.network(
      course['thumbnail'] ?? "",
      width: double.infinity,
      height: 250,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          Image.asset("assets/coursedescriptionpic.png", fit: BoxFit.cover),
    );
  }

  Widget _buildCourseDetails(dynamic course) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            course['title'] ?? "Untitled Course",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "Instructor: ${course['instructor']['name'] ?? 'Expert'}",
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          const SizedBox(height: 12),
          Text(
            course['description'] ?? "No description available.",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 25),
          Text(
            "${lessons.length} Lessons",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    bool isDone = completedLessonIds.contains(lesson['_id']);
                    return _buildLessonItem(
                      (index + 1).toString(),
                      lesson['title'],
                      (lesson['videoUrl'] == null || lesson['videoUrl'].isEmpty)
                          ? "Article"
                          : "${lesson['duration']} min",
                      isDone,
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildBottomActionButton(String buttonText) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: () async {
            if (lessons.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("No lessons available yet.")),
              );
              return;
            }

            if (widget.isOwned) {
              _startLesson(0);
            } else if (buttonText == "Enroll Now") {
              _handleEnrollment();
            } else {
              final double price =
                  double.tryParse(widget.course['price'].toString()) ?? 0.0;
              _initiatePaymobTransaction(price);
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
    );
  }

  Future<void> _handleEnrollment() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            const Center(child: CircularProgressIndicator(color: Colors.white)),
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

      if (!mounted) return;
      Navigator.pop(context);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _startLesson(0);
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      debugPrint("Error during enrollment: $e");
    }
  }

  Widget _buildLessonItem(
    String number,
    String title,
    String info,
    bool isDone,
  ) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: isDone ? Colors.green.shade100 : Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: isDone
                    ? const Icon(Icons.check, size: 18, color: Colors.green)
                    : Text(
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

  Future<void> _initiatePaymobTransaction(double price) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            const Center(child: CircularProgressIndicator(color: Colors.black)),
      );

      final authResponse = await http.post(
        Uri.parse("https://accept.paymob.com/api/auth/tokens"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"api_key": paymobApiKey}),
      );
      final String authToken = jsonDecode(authResponse.body)['token'];

   
      final orderResponse = await http.post(
        Uri.parse("https://accept.paymob.com/api/ecommerce/orders"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "auth_token": authToken,
          "delivery_needed": "false",
          "amount_cents": (price * 100).toInt().toString(),
          "currency": "EGP",
          "items": [],
        }),
      );
      final String orderId = jsonDecode(orderResponse.body)['id'].toString();

      final keyResponse = await http.post(
        Uri.parse("https://accept.paymob.com/api/acceptance/payment_keys"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "auth_token": authToken,
          "amount_cents": (price * 100).toInt().toString(),
          "expiration": 3600,
          "order_id": orderId,
          "billing_data": {
            "apartment": "NA",
            "email": AppState().userID,
            "floor": "NA",
            "first_name": AppState().userID,
            "street": "NA",
            "building": "NA",
            "phone_number": "01000000000",
            "shipping_method": "NA",
            "postal_code": "NA",
            "city": "NA",
            "country": "NA",
            "last_name": "User",
            "state": "NA",
          },
          "currency": "EGP",
          "integration_id": paymobIntegrationId,
        }),
      );
      final String finalPaymentToken = jsonDecode(keyResponse.body)['token'];

      if (!mounted) return;
      Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymobWebView(
            paymentToken: finalPaymentToken,
            iframeId: paymobIframeId,
            onPaymentSuccess: () {
              _handleEnrollment();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Payment Successful! Welcome to the course."),
                ),
              );
            },
          ),
        ),
      );
    } catch (e) {
      if (mounted) Navigator.pop(context); 
      debugPrint("Paymob Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment Initialization Failed.")),
      );
    }
  }
}
