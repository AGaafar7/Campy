import 'dart:convert';
import 'package:campy/api/campy_backend_manager.dart';
import 'package:campy/app_state.dart';
import 'package:campy/screens/courses/course_description_screen.dart';
import 'package:flutter/material.dart';

class CoursesExploreScreen extends StatefulWidget {
  const CoursesExploreScreen({super.key});

  @override
  State<CoursesExploreScreen> createState() => _CoursesExploreScreenState();
}

class _CoursesExploreScreenState extends State<CoursesExploreScreen> {
  final List<String> categories = [
    "All",
    "Web Development",
    "Mobile",
    "AI",
    "Design",
  ];

  List<dynamic> allCourses = [];
  List<dynamic> filteredCourses = [];
  Set<String> enrolledCourseIds = {}; // Store IDs for quick lookup
  bool isLoading = true;
  String selectedCategory = "All";
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);
    try {
      // 1. Fetch All Courses and User Enrolled Courses in parallel
      final results = await Future.wait([
        getCourses(),
        getCourseByUserID(AppState().userID),
      ]);

      if (results[0].statusCode == 200 && results[1].statusCode == 200) {
        final coursesData = jsonDecode(results[0].body)['data'] as List;
        final enrolledData = jsonDecode(results[1].body)['data'] as List;

        setState(() {
          allCourses = coursesData;
          filteredCourses = coursesData;
          // Extract just the IDs of courses the user owns
          enrolledCourseIds = enrolledData
              .map((item) => item['courseId']['_id'].toString())
              .toSet();
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading courses: $e");
      setState(() => isLoading = false);
    }
  }

  void _filterCourses() {
    setState(() {
      filteredCourses = allCourses.where((course) {
        final nameMatches = course['title'].toString().toLowerCase().contains(
          searchQuery.toLowerCase(),
        );
        final categoryMatches =
            selectedCategory == "All" || course['category'] == selectedCategory;
        return nameMatches && categoryMatches;
      }).toList();
    });
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
            : CustomScrollView(
                slivers: [
                  _buildHeader(),
                  _buildSearchBar(),
                  _buildCategoryFilters(),
                  _buildCourseGrid(),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Explore\nCourses",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            const CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage("assets/profileicon.png"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: TextField(
          onChanged: (value) {
            searchQuery = value;
            _filterCourses();
          },
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: "Search for courses...",
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SliverToBoxAdapter(
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            final isSelected = selectedCategory == cat;
            return GestureDetector(
              onTap: () {
                selectedCategory = cat;
                _filterCourses();
              },
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    cat,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCourseGrid() {
    if (filteredCourses.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(50),
            child: Text("No courses found."),
          ),
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          childAspectRatio: 0.75,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final course = filteredCourses[index];
          final bool isOwned = enrolledCourseIds.contains(course['_id']);
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CourseDescriptionScreen(course: course, isOwned: isOwned),
                ),
              );
            },
            child: CourseCard(course: course, isOwned: isOwned),
          );
        }, childCount: filteredCourses.length),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final dynamic course;
  final bool isOwned;

  const CourseCard({super.key, required this.course, required this.isOwned});

  @override
  Widget build(BuildContext context) {
    // Dynamic price logic
    final double price = double.tryParse(course['price'].toString()) ?? 0.0;
    final String priceText = price == 0 ? "Free" : "\$$price";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              child: Image.network(
                // Use Network image for backend data
                course['thumbnail'] ?? "",
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset("assets/coursepic.png", fit: BoxFit.cover),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course['category']?.toUpperCase() ?? "GENERAL",
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  course['title'] ?? "Untitled Course",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  isOwned ? "Continue Course" : priceText,
                  style: TextStyle(
                    color: isOwned
                        ? Colors.blue
                        : (price == 0 ? Colors.green : Colors.black),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
