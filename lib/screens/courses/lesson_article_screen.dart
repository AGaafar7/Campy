import 'package:flutter/material.dart';

class ArticleLessonScreen extends StatelessWidget {
  const ArticleLessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Quit and Continue Later",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            // Banner Image
            Image.asset(
              "assets/coursedescriptionpic.png",
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            const Text(
              "Lesson 2: Make Good Designs",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Article Content Card
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Make Good Designs Step One",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Unlock your creative potential with this complete course. Learn design theory, master industry-standard tools, and create captivating user interfaces for web and mobile.",
                      style: TextStyle(
                        color: Colors.white70,
                        height: 1.5,
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    // Back/Forward Lesson Navigator
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_back_ios_rounded, size: 16),
                          const Spacer(),
                          Column(
                            children: const [
                              Text(
                                "Lesson 3: Make UI Designs",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Video",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 16),
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
    );
  }
}
