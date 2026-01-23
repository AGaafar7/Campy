import 'dart:convert';

import 'package:campy/api/campy_backend_manager.dart';
import 'package:campy/app_state.dart';
import 'package:campy/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> continueLearningCourses = [];
  List<dynamic> completedCertificates = [];
  String name = "";
  String kudos = "";
  @override
  void initState() {
    super.initState();
    setupScreen();
    fetchUserProgress();
  }

  void fetchUserProgress() async {
    final String userId = AppState().userID;
    final String token = AppState().token;
    // Endpoint: GET /progress/user/:userId
    final response = await http.get(
      Uri.parse("$baseUrl/progress/user/$userId"),
      // 2. Add the headers map here
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token', // 3. Pass the Bearer token
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      final List<dynamic> allProgress = decoded['data'];

      setState(() {
        // Filter for Continue Learning (Not completed)
        continueLearningCourses = allProgress
            .where((p) => p['isCompleted'] == false)
            .toList();

        // Filter for Certificates (Completed)
        completedCertificates = allProgress
            .where((p) => p['isCompleted'] == true)
            .toList();
      });
    } else {
      debugPrint("Fetch Progress Error: ${response.statusCode}");
      debugPrint("Used Token: $token");
    }
  }

  void setupScreen() async {
    http.Response response = await getUsersByID(AppState().userID);
    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      final String nameFromResponse = decoded['data']['name'].toString();
      final String kudosFromResponse = decoded['data']['kudos'].toString();
      setState(() {
        name = nameFromResponse;
        kudos = kudosFromResponse;
      });
    } else {
      debugPrint(response.statusCode.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      extendBody: true,
      body: SingleChildScrollView(
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(name, kudos),

              _buildStreakCard(),
              _buildKudosCard(),
              _buildSectionTitle("Continue Learning"),
              _buildContinueLearningList(),
              //_buildSectionTitle("Recent Achievement"),
              //_buildAchievementGrid(),
              //eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2OTcyNjE4NThiZjJhNmIyYTJiODRiNzIiLCJpYXQiOjE3NjkxMzAxMDAsImV4cCI6MTc2OTczNDkwMH0.05XbGG-6s-D7tf-DYR9fAp_Fga84e7BMeA2Ud3Tws9A
              //Free Course
              //CAMP-FREE : 6972c9c9e77da463e4be44f3
              //paid course
              //Flat PRO: 6972ca04e77da463e4be44f6
              _buildSectionTitle("Badges & Certificates"),
              _buildBadgesSection(),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String name, String kudos) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundImage: AssetImage("assets/profileicon.png"),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hi, $name!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              //TODO: add levels next update
              Text("$kudos Kudos", style: TextStyle(color: Colors.grey)),
            ],
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications_none_rounded),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.local_fire_department_rounded,
            color: Colors.orange,
            size: 40,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "12 Day Streak",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                "You're on fire! Keep it up.",
                style: TextStyle(color: Colors.orange),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKudosCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Reaching Thousand Kudos",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: (double.tryParse(kudos) ?? 0) / 1000,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            color: Colors.black,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(kudos, style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text(
                "$kudos Kudos to 1000 kudos",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildContinueLearningList() {
   
    if (continueLearningCourses.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text("No courses in progress. Start learning!"),
      );
    }

    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20),
        // 2. Use the actual length of your data list
        itemCount: continueLearningCourses.length,
        itemBuilder: (context, index) {
          // 3. Extract the specific course progress object
          final progressData = continueLearningCourses[index];

          // Following your API doc structure: data -> courseId -> title
          final String courseTitle =
              progressData['courseId']['title'] ?? "Unknown Course";
          final int progressPercent = progressData['overallProgress'] ?? 0;

          return Container(
            width: 200,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.asset(
                    "assets/continuelearningpic.png",
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        courseTitle,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "$progressPercent% Complete",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: 32,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            // TODO: Navigate to Course Player using progressData['courseId']['_id']
                          },
                          child: const Text("Resume"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /*Widget _buildAchievementGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 0,
          crossAxisSpacing: 10,
          childAspectRatio: 0.85,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: Colors.yellow.shade100,
                child: const Icon(Icons.stars, color: Colors.orange),
              ),
              const SizedBox(height: 4),
              const Text("5 Days", style: TextStyle(fontSize: 10)),
            ],
          );
        },
      ),
    );
  }
*/
  Widget _buildBadgesSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: completedCertificates.isEmpty
                    ? const Center(
                        child: Text(
                          "No certificates yet",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      )
                    : SizedBox(
                        height: 90,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: completedCertificates.length,
                          itemBuilder: (context, index) {
                            final cert = completedCertificates[index];

                            final String title =
                                cert['courseId']['title'] ?? "Course";
                            return _buildCertificateItem(title);
                          },
                        ),
                      ),
              ),
            ],
          ),
          if (completedCertificates.isNotEmpty)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: Navigate to All Certificates Screen
                },
                child: const Text("View All", style: TextStyle(fontSize: 12)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCertificateItem(String courseName) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.workspace_premium, // The Certificate Icon
            size: 40,
            color: Colors.amber,
          ),
          const SizedBox(height: 4),
          Text(
            courseName,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
