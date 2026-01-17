import 'package:flutter/material.dart';

class CoursesExploreScreen extends StatefulWidget {
  const CoursesExploreScreen({super.key});

  @override
  State<CoursesExploreScreen> createState() => _CoursesExploreScreenState();
}

class _CoursesExploreScreenState extends State<CoursesExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Text("Course"),
                    Spacer(),
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/profileicon.png"),
                      radius: 30,
                    ),
                  ],
                ),
              ),

              //Search Box
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 226, 226, 226),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Search",
                    suffixIcon: Icon(Icons.filter_list),
                  ),
                ),
              ),
              //TODO: when Searching show a box here containing the results
              //Choose your Course
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8,
                ),
                child: Text("Choose your course"),
              ),
              //Filters
              //TODO: Should be a list containing all the filter from the categories that are in the database
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: 60,
                  height: 22,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: BoxBorder.all(style: BorderStyle.solid),
                  ),
                  child: Center(child: Text("All")),
                ),
              ),
              //Courses it self also should be a list from the backend
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: BoxBorder.all(style: BorderStyle.solid),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset("assets/coursepic.png"),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Mobile Development"),
                            Text("Introduction to Flutter"),
                            const SizedBox(height: 10),
                            //Price
                            Text("Free"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
