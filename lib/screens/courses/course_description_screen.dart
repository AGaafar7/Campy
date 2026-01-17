import 'package:flutter/material.dart';

class CourseDescriptionScreen extends StatefulWidget {
  const CourseDescriptionScreen({super.key});

  @override
  State<CourseDescriptionScreen> createState() =>
      _CourseDescriptionScreenState();
}

class _CourseDescriptionScreenState extends State<CourseDescriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  const Text(
                    "Explore",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.menu_rounded),
                  ),
                ],
              ),
            ),

            // Main Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/coursedescriptionpic.png",
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Complete Web & Mobile Design",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "John Doe",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Unlock your creative potential with this complete course. Learn design theory, master industry-standard tools, and create captivating user interfaces for web and mobile.",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "24 Lessons",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Lessons List with Stepper Effect
                          _buildLessonItem("1", "Intro to good design", "3:00"),
                          _buildLessonItem("2", "Intro to good design", "7:58"),
                          _buildLessonItem(
                            "3",
                            "Intro to good design",
                            "article",
                          ),
                          _buildLessonItem("4", "Intro to good design", "7:58"),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Enroll Button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Enroll Now",
                    style: TextStyle(
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

  // Helper widget to build the vertical timeline (stepper)
  Widget _buildLessonItem(String number, String title, String duration) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  number,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              // The vertical line (don't show for the last item if you want, or keep it)
              Expanded(child: Container(width: 2, color: Colors.grey[300])),
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
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      duration,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
                const SizedBox(height: 24), // Spacing between lessons
              ],
            ),
          ),
        ],
      ),
    );
  }
}
